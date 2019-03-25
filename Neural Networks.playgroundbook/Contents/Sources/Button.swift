//
//  Button.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import UIKit

public class Button: UIControl {
    struct Constants {
        static let shadowRadius: CGFloat = 3
        static let shadowOpacity: Float = 0.35
        static let borderWidthRatio: CGFloat = 0.03
    }
    
    let glowLayer: CAShapeLayer = CAShapeLayer()
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    override public var isHighlighted: Bool {
        didSet {
            layer.backgroundColor = isHighlighted ? tintColor.withAlphaComponent(0.4).cgColor : UIColor.clear.cgColor
        }
    }
    
    override public init(frame: CGRect = .zero) {
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didLoad() {
        isOpaque = false
        layer.masksToBounds = false
        layer.shadowColor = tintColor.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        layer.borderColor = tintColor.cgColor
        
        glowLayer.frame = bounds
        glowLayer.shadowColor = tintColor.cgColor
        glowLayer.shadowOffset = CGSize.zero
        glowLayer.shadowRadius = 5
        glowLayer.shadowOpacity = 1.0
        glowLayer.borderColor = tintColor.cgColor
        
        // Create an animation that slowly fades the glow view in and out forever.
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.2
        animation.toValue = 0.6
        animation.repeatCount = .infinity
        animation.duration = 1.0
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        glowLayer.add(animation, forKey: "neonGlow")
        layer.addSublayer(glowLayer)
        
        titleLabel.text = "1"
        titleLabel.textColor = tintColor
        addSubview(titleLabel)
        let padding: CGFloat = 24
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding)
            ])
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let borderWidth = min(bounds.height, bounds.width) * Constants.borderWidthRatio
        let cornerRadius = min(bounds.height, bounds.width) / 2
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        glowLayer.borderWidth = borderWidth
        glowLayer.cornerRadius = cornerRadius
        // Animate glowLayer
        CATransaction.begin()
        if let animation = layer.animation(forKey: "bounds") {
            CATransaction.setAnimationDuration(animation.duration)
            CATransaction.setAnimationTimingFunction(animation.timingFunction)
            let animation = CABasicAnimation(keyPath: "path")
            glowLayer.add(animation, forKey: "path")
        } else {
            CATransaction.disableActions()
        }
        glowLayer.frame = bounds
        CATransaction.commit()
    }
    
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        titleLabel.textColor = tintColor
        layer.borderColor = tintColor.cgColor
        layer.shadowColor = tintColor.cgColor
        glowLayer.shadowColor = tintColor.cgColor
        glowLayer.borderColor = tintColor.cgColor
        setNeedsDisplay()
    }
}
