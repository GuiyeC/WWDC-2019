//
//  BoardView.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import UIKit

public class BoardView: UIView {
    public struct Constants {
        public static let shadowRadius: CGFloat = 3
        public static let shadowOpacity: Float = 0.35
        public static let borderWidthRatio: CGFloat = 0.015
        public static let cornerRadiusRatio: CGFloat = 0.08
        public static let squareAlpha: CGFloat = 0.08
    }
    
    let rows: Int
    let columns: Int
    let glowLayer: CAShapeLayer = CAShapeLayer()
    
    public init(rows: Int, columns: Int, frame: CGRect = .zero) {
        self.rows = rows
        self.columns = columns
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didLoad() {
        isUserInteractionEnabled = false
        isOpaque = false
        layer.masksToBounds = false
        layer.shadowColor = tintColor.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        
        glowLayer.frame = bounds
        glowLayer.shadowColor = tintColor.cgColor
        glowLayer.shadowOffset = CGSize.zero
        glowLayer.shadowRadius = 5
        glowLayer.shadowOpacity = 1.0
        glowLayer.fillColor = UIColor.clear.cgColor
        glowLayer.strokeColor = tintColor.cgColor
        
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
    }
    
    override public func draw(_ rect: CGRect) {
        let borderWidth = min(rect.height, rect.width) * Constants.borderWidthRatio
        let cornerRadius = min(rect.height, rect.width) * Constants.cornerRadiusRatio
        let inset = borderWidth/2
        var innerRect = rect
        innerRect.origin.x += inset
        innerRect.origin.y += inset
        innerRect.size.width -= borderWidth
        innerRect.size.height -= borderWidth
        tintColor.setFill()
        let rowHeight: CGFloat = innerRect.height / CGFloat(rows)
        let columnWidth: CGFloat = innerRect.width / CGFloat(columns)
        for row in 0..<rows {
            for column in 0..<columns {
                if row % 2 == column % 2 {
                    let squareRect = CGRect(
                        x: columnWidth*CGFloat(column) + inset,
                        y: rowHeight*CGFloat(row) + inset,
                        width: columnWidth, height: rowHeight)
                    let squarePath = squarePathFor(row: row, column: column,
                                                   rect: squareRect, cornerRadius: cornerRadius)
                    squarePath.fill(with: .lighten, alpha: Constants.squareAlpha)
                }
            }
        }
        tintColor.setStroke()
        let path = UIBezierPath(roundedRect: innerRect, cornerRadius: cornerRadius)
        glowLayer.path = path.cgPath
        glowLayer.lineWidth = borderWidth
        path.lineWidth = borderWidth
        path.stroke(with: .lighten, alpha: 1)
        UIColor.black.setStroke()
        path.lineWidth = inset
        path.stroke(with: .darken, alpha: 0.05)
    }
    
    func squarePathFor(row: Int, column: Int, rect: CGRect, cornerRadius: CGFloat) -> UIBezierPath {
        switch (row, column) {
        case (0, 0):
            return UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: .topLeft,
                cornerRadii: CGSize(width: cornerRadius, height: 0))
        case (0, columns-1):
            return UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: .topRight,
                cornerRadii: CGSize(width: cornerRadius, height: 0))
        case (rows-1, 0):
            return UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: .bottomLeft,
                cornerRadii: CGSize(width: cornerRadius, height: 0))
        case (rows-1, columns-1):
            return UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: .bottomRight,
                cornerRadii: CGSize(width: cornerRadius, height: 0))
        default:
            return UIBezierPath(rect: rect)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
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
        setNeedsDisplay()
        CATransaction.commit()
    }
    
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        layer.shadowColor = tintColor.cgColor
        glowLayer.shadowColor = tintColor.cgColor
        glowLayer.strokeColor = tintColor.cgColor
        setNeedsDisplay()
    }
}
