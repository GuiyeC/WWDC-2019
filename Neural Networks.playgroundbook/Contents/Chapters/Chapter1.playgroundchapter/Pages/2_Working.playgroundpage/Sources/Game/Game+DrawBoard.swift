//
//  Game+DrawBoard.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 24/03/2019.
//

import Foundation

extension SquareState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return " "
        case .occupied(let player):
            switch player {
            case .white:
                return "X"
            case .black:
                return "O"
            }
        }
    }
}

extension Game: CustomStringConvertible {
    public var description: String {
        var description = "╔═══╤═══╤═══╗\n║ "
        for i in 0..<2 {
            let state = board[i]
            description += "\(state) │ "
        }
        description += "\(board[2]) ║\n╟───┼───┼───╢\n║ "
        for i in 3..<5 {
            let state = board[i]
            description += "\(state) │ "
        }
        description += "\(board[5]) ║\n╟───┼───┼───╢\n║ "
        for i in 6..<8 {
            let state = board[i]
            description += "\(state) │ "
        }
        description += "\(board[8]) ║\n╚═══╧═══╧═══╝"
        description += "\nEvaluation: \(evaluateBoard())"
        return description
    }
}
