//
//  Game+DrawBoard.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import Foundation

extension Piece {
    public func description(for player: Player) -> String {
        switch self {
        case .pawn:
            return player == .white ? "♙" : "♟︎"
        case .knight:
            return player == .white ? "♘" : "♞"
        case .bishop:
            return player == .white ? "♗" : "♝"
        case .rook:
            return player == .white ? "♖" : "♜"
        }
    }
}

extension SquareState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "　"
        case .occupied(let player, let piece):
            return piece.description(for: player)
        }
    }
}

extension Direction: CustomStringConvertible {
    public var description: String {
        switch self {
        case .up:
            return "↑"
        case .down:
            return "↓"
        }
    }
}

extension Game: CustomStringConvertible {
    public var description: String {
        var description = "╔═　═╤═　═╤═　═╤═　═╗\n║ "
        for i in 0..<3 {
            let state = board[i]
            description += "\(state) │ "
        }
        description += "\(board[3]) ║\n╟─　─┼─　─┼─　─┼─　─╢\n║ "
        for i in 4..<7 {
            let state = board[i]
            description += "\(state) │ "
        }
        description += "\(board[7]) ║\n╟─　─┼─　─┼─　─┼─　─╢\n║ "
        for i in 8..<11 {
            let state = board[i]
            description += "\(state) │ "
        }
        description += "\(board[11]) ║\n╟─　─┼─　─┼─　─┼─　─╢\n║ "
        for i in 12..<15 {
            let state = board[i]
            description += "\(state) │ "
        }
        description += "\(board[15]) ║\n╚═　═╧═　═╧═　═╧═　═╝ W: \(String(describing: whitePawnDirection?.description)) B: \(String(describing: blackPawnDirection?.description))"
        description += "\nEvaluation: \(evaluateBoard())"
        return description
    }
}

