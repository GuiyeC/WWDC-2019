//
//  TicTacToeView.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import UIKit

public protocol TicTacToeViewDelegate: class {
    func ticTacToeView(_ ticTacToeView: TicTacToeView, stateForSquareAt coordinate: Int) -> SquareState
    func ticTacToeView(_ ticTacToeView: TicTacToeView, didMoveToCoordinate coordinate: Int)
}

public class TicTacToeView: GameView {
    public weak var delegate: TicTacToeViewDelegate!
    var selectedIndex: Int?
    
    public init(frame: CGRect = .zero) {
        super.init(rows: 3, columns: 3, frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        reloadData()
    }
    
    public func reloadData() {
        for (index, squareView) in squareViews.enumerated() {
            switch delegate.ticTacToeView(self, stateForSquareAt: index) {
            case .empty:
                squareView.path = nil
                squareView.tintColor = nil
                continue
            case .occupied(let player):
                let color = player == .white ? Constants.playerColor : Constants.opponentColor
                let path = player.path
                squareView.path = path
                squareView.tintColor = color
            }
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let position = touch.location(in: self)
        guard let index = squareViews.enumerated().first(where: { $1.frame.contains(position) })?.offset else {
            return
        }
        switch delegate.ticTacToeView(self, stateForSquareAt: index) {
        case .empty:
            selectedIndex = index
        case .occupied:
            selectedIndex = nil
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let position = touch.location(in: self)
        guard let index = squareViews.enumerated().first(where: { $1.frame.contains(position) })?.offset,
            let selectedIndex = selectedIndex,
            index == selectedIndex else {
                self.selectedIndex = nil
                return
        }
        self.selectedIndex = nil
        delegate.ticTacToeView(self, didMoveToCoordinate: selectedIndex)
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedIndex = nil
    }
}
