//
//  Game+LegalMoves.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import Foundation

extension Game {
    public func calculateLegalMoves() -> [Move] {
        guard state == .ongoing else {
            return []
        }
        var moves: [Move] = []
        for coordinate in 0..<16 {
            for piece in Piece.allCases {
                let move = Move(piece: piece, coordinate: coordinate)
                if checkLegalMove(move) {
                    moves.append(move)
                }
            }
        }
        return moves
    }
    
    func checkLegalMove(_ move: Move) -> Bool {
        guard state == .ongoing else {
            return false
        }
        let piece = move.piece
        let coordinate = move.coordinate
        guard coordinate >= 0 && coordinate <= 15 else {
            return false
        }
        guard let currentCoordinate = board.coordinateFor(piece: piece, player: turn) else {
            return board[coordinate] == .empty
        }
        // Piece already on the board but not enough pieces to move
        guard board.pieceCount(for: turn) >= 3 else {
            return false
        }
        let taking: Bool
        if case .occupied(let cellPlayer, _) = board[coordinate] {
            if turn == cellPlayer {
                // Coordinate already occupied by the player
                // This takes into account "moving" the piece to the same cell
                return false
            }
            taking = true
        } else {
            taking = false
        }
        switch piece {
        case .pawn:
            guard checkPawnLegalMove(from: currentCoordinate, to: coordinate, taking: taking) else {
                return false
            }
        case .knight:
            guard checkKnightLegalMove(from: currentCoordinate, to: coordinate) else {
                return false
            }
        case .bishop:
            guard checkBishopLegalMove(from: currentCoordinate, to: coordinate) else {
                return false
            }
        case .rook:
            guard checkRookLegalMove(from: currentCoordinate, to: coordinate) else {
                return false
            }
        }
        return true
    }
    
    private func checkPawnLegalMove(from fromCoordinate: Coordinate, to toCoordinate: Coordinate, taking: Bool) -> Bool {
        guard abs(fromCoordinate.y-toCoordinate.y) == 1 else {
            return false
        }
        let direction = turn == .white ? whitePawnDirection! : blackPawnDirection!
        guard direction == .up && fromCoordinate.y-toCoordinate.y > 0
            || direction == .down && fromCoordinate.y-toCoordinate.y < 0 else {
                return false
        }
        if taking {
            guard abs(fromCoordinate.x-toCoordinate.x) == 1 else {
                return false
            }
        } else {
            guard fromCoordinate.x == toCoordinate.x else {
                return false
            }
        }
        return true
    }
    
    private func checkKnightLegalMove(from fromCoordinate: Coordinate, to toCoordinate: Coordinate) -> Bool {
        guard abs(fromCoordinate.x-toCoordinate.x) == 1 && abs(fromCoordinate.y-toCoordinate.y) == 2 ||
            abs(fromCoordinate.x-toCoordinate.x) == 2 && abs(fromCoordinate.y-toCoordinate.y) == 1 else {
                return false
        }
        return true
    }
    
    private func checkBishopLegalMove(from fromCoordinate: Coordinate, to toCoordinate: Coordinate) -> Bool {
        let moved = abs(fromCoordinate.x-toCoordinate.x)
        guard moved == abs(fromCoordinate.y-toCoordinate.y) else {
            return false
        }
        let xModifier = fromCoordinate.x < toCoordinate.x ? 1 : -1
        let yModifier = fromCoordinate.y < toCoordinate.y ? 1 : -1
        var tempX = fromCoordinate.x + xModifier
        var tempY = fromCoordinate.y + yModifier
        for _ in 1..<moved {
            if case .occupied = board[Coordinate(x: tempX, y: tempY)] {
                return false
            }
            tempX += xModifier
            tempY += yModifier
        }
        return true
    }
    
    private func checkRookLegalMove(from fromCoordinate: Coordinate, to toCoordinate: Coordinate) -> Bool {
        if fromCoordinate.x == toCoordinate.x {
            let yModifier = fromCoordinate.y < toCoordinate.y ? 1 : -1
            var tempY = fromCoordinate.y + yModifier
            for _ in 1..<abs(fromCoordinate.y-toCoordinate.y) {
                if case .occupied = board[Coordinate(x: toCoordinate.x, y: tempY)] {
                    return false
                }
                tempY += yModifier
            }
            return true
        } else if fromCoordinate.y == toCoordinate.y {
            let xModifier = fromCoordinate.x < toCoordinate.x ? 1 : -1
            var tempX = fromCoordinate.x + xModifier
            for _ in 1..<abs(fromCoordinate.x-toCoordinate.x) {
                if case .occupied = board[Coordinate(x: tempX, y: toCoordinate.y)] {
                    return false
                }
                tempX += xModifier
            }
            return true
        } else {
            return false
        }
    }
}
