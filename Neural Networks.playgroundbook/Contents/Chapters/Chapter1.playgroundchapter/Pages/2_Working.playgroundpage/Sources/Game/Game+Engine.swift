//
//  Game+Engine.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 24/03/2019.
//

import Foundation

extension Game {
    public func findMove() -> Coordinate? {
        guard state == .ongoing else {
            return nil
        }
        return findBestMoves().0.randomElement()
    }
    func findBestMoves() -> ([Coordinate], [Coordinate: Int]) {
        let legalMoves = calculateLegalMoves()
        precondition(legalMoves.count > 0, "No legal moves available")
        var bestMove = Int.min
        var scoredMoves: [Coordinate: Int] = [:]
        var bestMovesFound: [Coordinate] = []
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
                let value = minimax(depth: 5, maximize: false, player: player)
                scoredMoves.updateValue(value, forKey: move)
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
        if depth == 0 {
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
        let alignedPieces = board.alignedPieceCount(for: player)
        let maxAlignedPieces = alignedPieces.max()!
        switch maxAlignedPieces {
        case 0:
            return 0
        case 1:
            return 5
        case 2:
            if alignedPieces.filter({ $0 == 2 }).count == 2 {
                return 1000
            }
            return 25
        case 3:
            return 1000
        default:
            return 1000
        }
    }
}
