//
//  SquareView.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import UIKit

public class SquareView: UIControl {
    public struct Constants {
        public static let selectedAlpha: CGFloat = 0.25
        public static let shadowRadius: CGFloat = 7
        public static let lightShadowRadius: CGFloat = 2
        public static let shadowOpacity: Float = 0.3
        public static let borderWidthRatio: CGFloat = 0.04
        public static let cornerRadiusRatio: CGFloat = 0.08
    }
    
    public var path: UIBezierPath? {
        didSet {
            setNeedsLayout()
        }
    }
    let darkLayer: CAShapeLayer = CAShapeLayer()
    let pathLayer: CAShapeLayer = CAShapeLayer()
    let glowLayer: CAShapeLayer = CAShapeLayer()
    let lightLayer: CAShapeLayer = CAShapeLayer()
    var shadowOffset: CGSize {
        set {
            pathLayer.shadowOffset = newValue
            lightLayer.shadowOffset = newValue
        }
        get {
            return pathLayer.shadowOffset
        }
    }
    public var isOn: Bool = true {
        didSet {
            updateState()
        }
    }
    override public var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = tintColor.withAlphaComponent(Constants.selectedAlpha)
            } else {
                backgroundColor = .clear
            }
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
        isUserInteractionEnabled = false
        
        lightLayer.frame = bounds
        lightLayer.shadowOffset = .zero
        lightLayer.shadowRadius = Constants.lightShadowRadius
        lightLayer.shadowOpacity = Constants.shadowOpacity
        lightLayer.fillColor = UIColor.clear.cgColor
        lightLayer.lineCap = .round
        layer.addSublayer(lightLayer)
        
        pathLayer.shadowOffset = .zero
        pathLayer.shadowRadius = Constants.shadowRadius
        pathLayer.shadowOpacity = Constants.shadowOpacity
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.lineCap = .round
        layer.addSublayer(pathLayer)
        
        darkLayer.shadowColor = UIColor.black.cgColor
        darkLayer.shadowOffset = .zero
        darkLayer.shadowOpacity = 1
        darkLayer.shadowRadius = 4
        darkLayer.fillColor = UIColor.clear.cgColor
        darkLayer.strokeColor = UIColor.black.cgColor
        darkLayer.opacity = 0.1
        darkLayer.lineCap = .round
        layer.addSublayer(darkLayer)
        
        glowLayer.frame = bounds
        glowLayer.shadowOffset = CGSize.zero
        glowLayer.shadowRadius = 5
        glowLayer.shadowOpacity = 1.0
        glowLayer.fillColor = UIColor.clear.cgColor
        glowLayer.lineCap = .round
        
        // Create an animation that slowly fades the glow view in and out forever.
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.5
        animation.toValue = 1
        animation.repeatCount = .infinity
        animation.duration = 0.8
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        glowLayer.add(animation, forKey: "neonGlow")
        
        updateState()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.height, bounds.width) * Constants.cornerRadiusRatio
        guard let scaledPath = path?.copy() as? UIBezierPath else {
            darkLayer.path = nil
            pathLayer.path = nil
            glowLayer.path = nil
            lightLayer.path = nil
            return
        }
        scaledPath.apply(CGAffineTransform(scaleX: bounds.width/100, y: bounds.height/100))
        darkLayer.path = scaledPath.cgPath
        pathLayer.path = scaledPath.cgPath
        glowLayer.path = scaledPath.cgPath
        lightLayer.path = scaledPath.cgPath
        
        pathLayer.frame = bounds
        glowLayer.frame = bounds
        lightLayer.frame = bounds
        darkLayer.frame = bounds
        let borderWidth = min(bounds.height, bounds.width) * Constants.borderWidthRatio
        pathLayer.lineWidth = borderWidth
        glowLayer.lineWidth = borderWidth
        lightLayer.lineWidth = borderWidth * 0.3
        darkLayer.lineWidth = borderWidth * 0.4
    }
    
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        updateState()
    }
    
    func updateState() {
        let color: CGColor
        let shadowColor: CGColor
        if isOn {
            color = tintColor.cgColor
            shadowColor = tintColor.cgColor
            layer.addSublayer(glowLayer)
            glowLayer.frame = bounds
        } else {
            color = UIColor(white: 0.3, alpha: 0.8).cgColor
            shadowColor = UIColor.clear.cgColor
            glowLayer.removeFromSuperlayer()
        }
        pathLayer.strokeColor = color
        pathLayer.shadowColor = shadowColor
        glowLayer.strokeColor = color
        glowLayer.shadowColor = shadowColor
        lightLayer.strokeColor = color
        lightLayer.shadowColor = shadowColor
    }
}
