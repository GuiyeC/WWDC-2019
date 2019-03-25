//
//  TicTacChecView.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import UIKit

public protocol TicTacChecViewDelegate: class {
    func currentPlayerForTicTacChecView(_ ticTacChecView: TicTacChecView) -> Player
    func lastMoveForTicTacChecView(_ ticTacChecView: TicTacChecView) -> (from: Coordinate?, to: Coordinate?)
    func ticTacChecView(_ ticTacChecView: TicTacChecView, stateForSquareAt coordinate: Int) -> SquareState
    func ticTacChecView(_ ticTacChecView: TicTacChecView, pawnDirectionForPlayer player: Player) -> Direction?
    func ticTacChecView(_ ticTacChecView: TicTacChecView, pocketPiecesForPlayer player: Player) -> Set<Piece>
    func ticTacChecView(_ ticTacChecView: TicTacChecView, legalMovesForPiece piece: Piece) -> [Coordinate]
    func ticTacChecView(_ ticTacChecView: TicTacChecView, didMovePiece piece: Piece, toCoordinate coordinate: Int)
}

public class TicTacChecView: GameView {
    public weak var delegate: TicTacChecViewDelegate!
    public var viewPlayer: Player = .white {
        didSet {
            reloadData()
        }
    }
    var selectedPiece: Piece? {
        didSet {
            reloadData()
        }
    }
    var originalView: SquareView? {
        didSet {
            if let oldValue = oldValue {
                oldValue.isOn = true
                draggingView?.removeFromSuperview()
                draggingView = nil
            }
            if let view = originalView {
                view.isOn = false
                let draggingView = SquareView(frame: view.frame)
                draggingView.path = selectedPiece?.path
                draggingView.tintColor = view.tintColor
                self.draggingView = draggingView
                addSubview(draggingView)
            }
        }
    }
    var draggingView: SquareView?
    let pocketView: UIStackView = {
        let pocketView = UIStackView()
        pocketView.translatesAutoresizingMaskIntoConstraints = false
        pocketView.axis = .horizontal
        pocketView.distribution = .fillEqually
        pocketView.tintColor = Constants.playerColor
        return pocketView
    }()
    let opponentPocketView: UIStackView = {
        let pocketView = UIStackView()
        pocketView.translatesAutoresizingMaskIntoConstraints = false
        pocketView.axis = .horizontal
        pocketView.distribution = .fillEqually
        pocketView.tintColor = Constants.opponentColor
        return pocketView
    }()
    let hintsView: HintsBoardView
    
    public init(frame: CGRect = .zero) {
        self.hintsView = HintsBoardView(rows: 4, columns: 4)
        super.init(rows: 4, columns: 4, frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func didLoad() {
        addSubview(hintsView)
        super.didLoad()
        for piece in Piece.allCases {
            let squareView = SquareView()
            squareView.path = piece.path
            pocketView.addArrangedSubview(squareView)
            let opponentSquareView = SquareView()
            if piece == .pawn {
                let path = piece.path
                path.apply(CGAffineTransform(rotationAngle: .pi))
                path.apply(CGAffineTransform(translationX: 100, y: 100))
                opponentSquareView.path = path
            } else {
                opponentSquareView.path = piece.path
            }
            opponentPocketView.addArrangedSubview(opponentSquareView)
        }
        addSubview(pocketView)
        addSubview(opponentPocketView)
        boardView.translatesAutoresizingMaskIntoConstraints = false
        hintsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hintsView.topAnchor.constraint(equalTo: boardView.topAnchor),
            hintsView.leftAnchor.constraint(equalTo: boardView.leftAnchor),
            hintsView.rightAnchor.constraint(equalTo: boardView.rightAnchor),
            hintsView.bottomAnchor.constraint(equalTo: boardView.bottomAnchor),
            boardView.widthAnchor.constraint(equalTo: boardView.heightAnchor),
            opponentPocketView.topAnchor.constraint(equalTo: topAnchor),
            opponentPocketView.leftAnchor.constraint(equalTo: leftAnchor),
            opponentPocketView.rightAnchor.constraint(equalTo: rightAnchor),
            boardView.topAnchor.constraint(equalTo: opponentPocketView.bottomAnchor, constant: 16),
            boardView.leftAnchor.constraint(equalTo: leftAnchor),
            boardView.rightAnchor.constraint(equalTo: rightAnchor),
            pocketView.topAnchor.constraint(equalTo: boardView.bottomAnchor, constant: 16),
            pocketView.leftAnchor.constraint(equalTo: leftAnchor),
            pocketView.rightAnchor.constraint(equalTo: rightAnchor),
            pocketView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pocketView.heightAnchor.constraint(equalTo: boardView.heightAnchor, multiplier: 0.25),
            opponentPocketView.heightAnchor.constraint(equalTo: pocketView.heightAnchor)
        ])
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        reloadData()
    }
    
    public func reloadData() {
        var hints: [Coordinate: HintsBoardView.HintType] = [:]
        let lastMove = delegate.lastMoveForTicTacChecView(self)
        if let fromCoordinate = lastMove.from {
            let fixedcoordinate = viewPlayer == .white ? fromCoordinate : fromCoordinate.inverse()
            hints[fixedcoordinate] = .lastMove
        }
        if let toCoordinate = lastMove.to {
            let fixedcoordinate = viewPlayer == .white ? toCoordinate : toCoordinate.inverse()
            hints[fixedcoordinate] = .lastMove
        }
        
        for (index, squareView) in squareViews.enumerated() {
            let fixedIndex = viewPlayer == .white ? index : index.inverse()
            switch delegate.ticTacChecView(self, stateForSquareAt: fixedIndex) {
            case .empty:
                squareView.path = nil
                squareView.tintColor = nil
                continue
            case .occupied(let player, let piece):
                let color = player == viewPlayer ? Constants.playerColor : Constants.opponentColor
                let path = piece.path
                if piece == .pawn {
                    let direction = delegate.ticTacChecView(self, pawnDirectionForPlayer: player)
                    if direction == .down && viewPlayer == .white ||
                        direction == .up && viewPlayer == .black {
                        path.apply(CGAffineTransform(rotationAngle: .pi))
                        path.apply(CGAffineTransform(translationX: 100, y: 100))
                    }
                }
                squareView.path = path
                squareView.tintColor = color
                if player == viewPlayer && piece == selectedPiece {
                    hints[index] = .selected
                }
            }
        }
        
        if let piece = selectedPiece {
            let legalMoves = delegate.ticTacChecView(self, legalMovesForPiece: piece)
            for index in legalMoves {
                let fixedIndex = viewPlayer == .white ? index : index.inverse()
                if delegate.ticTacChecView(self, stateForSquareAt: index) == .empty {
                    hints[fixedIndex] = .legalMove
                } else {
                    hints[fixedIndex] = .legalTakingMove
                }
            }
        }
        hintsView.hints = hints
        
        let opponent: Player = viewPlayer == .white ? .black : .white
        let pocketPieces = delegate.ticTacChecView(self, pocketPiecesForPlayer: viewPlayer)
        let opponentPocketPieces = delegate.ticTacChecView(self, pocketPiecesForPlayer: opponent)
        for piece in Piece.allCases {
            if let squareView = pocketView.subviews[piece.rawValue] as? SquareView,
                squareView != originalView {
                let onPocket = pocketPieces.contains(piece)
                squareView.isOn = onPocket
                squareView.isSelected = onPocket && piece == selectedPiece
            }
            if let squareView = opponentPocketView.subviews[piece.rawValue] as? SquareView {
                squareView.isOn = opponentPocketPieces.contains(piece)
            }
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let position = touch.location(in: self)
        guard let index = squareViews.enumerated().first(where: { $1.frame.contains(position) })?.offset else {
            let pocketPosition = touch.location(in: pocketView)
            if let index = pocketView.subviews.enumerated().first(where: { $1.frame.contains(pocketPosition) })?.offset,
                let squareView = pocketView.subviews[index] as? SquareView,
                squareView.isOn {
                selectedPiece = Piece(rawValue: index)!
                
                originalView = squareView
                draggingView?.center = position
            } else {
                selectedPiece = nil
            }
            return
        }
        let fixedIndex = viewPlayer == .white ? index : index.inverse()
        switch delegate.ticTacChecView(self, stateForSquareAt: fixedIndex) {
        case .occupied(let player, let piece) where player == delegate.currentPlayerForTicTacChecView(self):
            selectedPiece = piece
        default:
            return
        }
        
        originalView = squareViews[index]
        if let draggingView = draggingView {
            draggingView.center = position
            updateShadowOffset(squareView: draggingView)
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
            let draggingView = draggingView else {
            return
        }
        let position = touch.location(in: self)
        draggingView.center = position
        updateShadowOffset(squareView: draggingView)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        originalView = nil
        guard let touch = touches.first else {
            return
        }
        let position = touch.location(in: self)
        guard let index = squareViews.enumerated().first(where: { $1.frame.contains(position) })?.offset else {
            return
        }
        guard let piece = selectedPiece else {
            return
        }
        let fixedIndex = viewPlayer == .white ? index : index.inverse()
        switch delegate.ticTacChecView(self, stateForSquareAt: fixedIndex) {
        case .occupied(let player, let piece) where player == delegate.currentPlayerForTicTacChecView(self):
            if piece != selectedPiece {
                selectedPiece = nil
            }
        default:
            selectedPiece = nil
            delegate.ticTacChecView(self, didMovePiece: piece, toCoordinate: fixedIndex)
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        originalView = nil
        selectedPiece = nil
    }
}
