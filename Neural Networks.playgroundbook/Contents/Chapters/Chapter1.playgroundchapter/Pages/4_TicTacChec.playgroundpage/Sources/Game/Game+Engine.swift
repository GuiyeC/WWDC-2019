//
//  Game+Engine.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import Foundation

extension Game {
    public func findMove() -> Move? {
        guard state == .ongoing else {
            return nil
        }
        return findBestMoves().0.randomElement()
    }
    func findBestMoves() -> ([Move], [Move: Int]) {
        let legalMoves = calculateLegalMoves()
        precondition(legalMoves.count > 0, "No legal moves available")
        var bestMove = Int.min
        var scoredMoves: [Move: Int] = [:]
        var bestMovesFound: [Move] = []
        let player = turn
        for move in legalMoves {
            let state = try! performMove(move)
            if case .won = state {
                if bestMove < 10000 {
                    bestMove = 10000
                    bestMovesFound = [move]
                } else if bestMove == 10000 {
                    bestMovesFound.append(move)
                }
                scoredMoves.updateValue(10000, forKey: move)
            } else if state == .draw {
                if bestMove < -20 {
                    bestMove = -20
                    bestMovesFound = [move]
                }
                scoredMoves.updateValue(-20, forKey: move)
            } else {
                //                print("Move: \(move)")
                let value = minimax(depth: board.pieceCount(for: player)-depthOffset, maximize: false, player: player)
                scoredMoves.updateValue(value, forKey: move)
                //                print("Value: \(value)")
                if bestMove < value {
                    bestMove = value
                    bestMovesFound = [move]
                } else if bestMove == value {
                    bestMovesFound.append(move)
                }
            }
            undo()
        }
        return (bestMovesFound, scoredMoves)
    }
    
    func minimax(depth: Int, alpha: Int = Int.min, beta: Int = Int.max, maximize: Bool, player: Player) -> Int {
        if depth <= 0 {
            if player == .white {
                return evaluateBoard()
            } else {
                return -evaluateBoard()
            }
        }
        var alpha = alpha
        var beta = beta
        let legalMoves = calculateLegalMoves()
        if maximize {
            var bestMove = -10000
            for move in legalMoves {
                let state = try! performMove(move)
                if case .won = state {
                    bestMove = 10000
                } else if state == .draw {
                    bestMove = max(bestMove, -20)
                } else {
                    bestMove = max(bestMove, minimax(depth: depth-1, alpha: alpha, beta: beta, maximize: !maximize, player: player))
                }
                undo()
                alpha = max(alpha, bestMove)
                if beta <= alpha {
                    return bestMove
                }
            }
            return bestMove
        } else {
            var bestMove = 10000
            for move in legalMoves {
                let state = try! performMove(move)
                if case .won = state {
                    bestMove = -10000
                } else if state == .draw {
                    bestMove = min(bestMove, 15)
                } else {
                    bestMove = min(bestMove, minimax(depth: depth-1, alpha: alpha, beta: beta, maximize: !maximize, player: player))
                }
                undo()
                beta = min(beta, bestMove)
                if beta <= alpha {
                    return bestMove
                }
            }
            return bestMove
        }
    }
    
    func evaluateBoard() -> Int {
        switch state {
        case .ongoing:
            return evaluateBoard(for: .white) - evaluateBoard(for: .black)
        case .draw:
            return 0
        case .won(let player):
            switch player {
            case .white:
                return 1000
            case .black:
                return -1000
            }
        }
    }
    
    func evaluateBoard(for player: Player) -> Int {
        var evaluation = 0
        let alignedPieces = board.alignedPieceCount(for: player)
        guard alignedPieces < 4 else {
            return 1000
        }
        evaluation += Int(pow(Double(alignedPieces), 3))
        if board.pieceCount(for: player) == 4 {
            evaluation -= 5
        }
        if let coordinate = board.coordinateFor(piece: .rook, player: player) {
            if coordinate.isCentral {
                evaluation += 6
            } else {
                evaluation += 4
            }
        }
        if let coordinate = board.coordinateFor(piece: .bishop, player: player) {
            if coordinate.isCentral {
                evaluation += 5
            } else {
                evaluation += 3
            }
        }
        if let coordinate = board.coordinateFor(piece: .knight, player: player) {
            if !coordinate.isCorner {
                evaluation += 5
            } else {
                evaluation += 2
            }
        }
        if let coordinate = board.coordinateFor(piece: .pawn, player: player) {
            if coordinate.isSide {
                evaluation -= 5
            }
        }
        return evaluation
    }
}

extension Coordinate {
    var isCentral: Bool {
        return self == 5 ||
            self == 6 ||
            self == 9 ||
            self == 10
    }
    var isSide: Bool {
        return self < 4 ||
            self <= 12 ||
            self%4 == 0 ||
            self%4 == 3
    }
    var isCorner: Bool {
        return self == 0 ||
            self == 12 ||
            self == 3 ||
            self == 15
    }
}
