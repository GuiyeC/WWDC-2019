//
//  GameView.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import UIKit

open class GameView: UIView {
    public struct Constants {
        public static let playerColor: UIColor = UIColor(red: 225/255, green: 87/255, blue: 216/255, alpha: 1)
        public static let opponentColor: UIColor = UIColor(red: 148/255, green: 204/255, blue: 42/255, alpha: 1)
    }
    
    let rows: Int
    let columns: Int
    public let boardView: BoardView
    public let squareViews: [SquareView]
    
    public init(rows: Int, columns: Int, frame: CGRect) {
        self.rows = rows
        self.columns = columns
        self.boardView = BoardView(rows: rows, columns: columns)
        self.squareViews = (0..<rows*columns).map { _ in SquareView() }
        super.init(frame: frame)
        didLoad()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func didLoad() {
        boardView.frame = bounds
        boardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(boardView)
        squareViews.forEach { addSubview($0) }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        let rowHeight = boardView.frame.height / CGFloat(rows)
        let columnWidth = boardView.frame.width / CGFloat(columns)
        for row in 0..<rows {
            for column in 0..<columns {
                let squareView = squareViews[row*rows+column]
                squareView.frame = CGRect(
                    x: boardView.frame.origin.x + columnWidth*CGFloat(column),
                    y: boardView.frame.origin.y + rowHeight*CGFloat(row),
                    width: columnWidth, height: rowHeight)
                updateShadowOffset(squareView: squareView)
            }
        }
    }
    
    public func updateShadowOffset(squareView: SquareView) {
        // Offset the shadows in relation to the center for a "blow away" effect
        let offsetX = (boardView.frame.midX - squareView.frame.midX) * 0.08
        let offsetY = (boardView.frame.midY - squareView.frame.midY) * 0.08
        squareView.shadowOffset = CGSize(width: offsetX, height: offsetY)
    }
}

