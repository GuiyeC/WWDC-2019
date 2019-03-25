//
//  HintsBoardView.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import UIKit

class HintsBoardView: UIView {
    enum HintType {
        case lastMove
        case selected
        case legalMove
        case legalTakingMove
    }
    
    struct Constants {
        static let hintAlpha: CGFloat = 0.25
        static let lastMoveColor: UIColor = UIColor(red: 12/255, green: 229/255, blue: 190/255, alpha: 1)
        static let selectedColor: UIColor = UIColor(red: 225/255, green: 87/255, blue: 216/255, alpha: 1)
        static let legalMoveColor: UIColor = UIColor(red: 251/255, green: 128/255, blue: 208/255, alpha: 1)
    }
    
    let rows: Int
    let columns: Int
    var hints: [Coordinate: HintType] = [:] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    init(rows: Int, columns: Int, frame: CGRect = .zero) {
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
        layer.masksToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        let borderWidth = min(rect.height, rect.width) * BoardView.Constants.borderWidthRatio
        let cornerRadius = min(rect.height, rect.width) * BoardView.Constants.cornerRadiusRatio
        let inset = borderWidth/2
        var innerRect = rect
        innerRect.origin.x += inset
        innerRect.origin.y += inset
        innerRect.size.width -= borderWidth
        innerRect.size.height -= borderWidth
        let rowHeight: CGFloat = innerRect.height / CGFloat(rows)
        let columnWidth: CGFloat = innerRect.width / CGFloat(columns)
        for (index, hint) in hints {
            let row = index.y
            let column = index.x
            switch hint {
            case .lastMove:
                let squareRect = CGRect(
                    x: columnWidth*CGFloat(column) + inset,
                    y: rowHeight*CGFloat(row) + inset,
                    width: columnWidth, height: rowHeight)
                let squarePath = squarePathFor(row: row, column: column,
                                               rect: squareRect, cornerRadius: cornerRadius)
                Constants.lastMoveColor.setFill()
                squarePath.fill(with: .lighten, alpha: Constants.hintAlpha)
            case .selected:
                let squareRect = CGRect(
                    x: columnWidth*CGFloat(column) + inset,
                    y: rowHeight*CGFloat(row) + inset,
                    width: columnWidth, height: rowHeight)
                let squarePath = squarePathFor(row: row, column: column,
                                               rect: squareRect, cornerRadius: cornerRadius)
                Constants.selectedColor.setFill()
                squarePath.fill(with: .lighten, alpha: Constants.hintAlpha)
            case .legalMove:
                let ovalInset = columnWidth * 0.35
                let ovalRect = CGRect(
                    x: columnWidth*CGFloat(column) + inset + ovalInset,
                    y: rowHeight*CGFloat(row) + inset + ovalInset,
                    width: columnWidth - ovalInset*2, height: rowHeight - ovalInset*2)
                let ovalPath = UIBezierPath(ovalIn: ovalRect)
                Constants.legalMoveColor.setFill()
                ovalPath.fill(with: .lighten, alpha: Constants.hintAlpha)
            case .legalTakingMove:
                let squareRect = CGRect(
                    x: columnWidth*CGFloat(column) + inset,
                    y: rowHeight*CGFloat(row) + inset,
                    width: columnWidth, height: rowHeight)
                let squarePath = squarePathFor(row: row, column: column,
                                               rect: squareRect, cornerRadius: cornerRadius)
                let ovalInset = columnWidth * 0.05
                let ovalRect = CGRect(
                    x: columnWidth*CGFloat(column) + inset + ovalInset,
                    y: rowHeight*CGFloat(row) + inset + ovalInset,
                    width: columnWidth - ovalInset*2, height: rowHeight - ovalInset*2)
                let ovalPath = UIBezierPath(ovalIn: ovalRect).reversing()
                squarePath.append(ovalPath)
                squarePath.usesEvenOddFillRule = true
                Constants.legalMoveColor.setFill()
                squarePath.fill(with: .lighten, alpha: Constants.hintAlpha)
            }
        }
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        setNeedsDisplay()
    }
}

