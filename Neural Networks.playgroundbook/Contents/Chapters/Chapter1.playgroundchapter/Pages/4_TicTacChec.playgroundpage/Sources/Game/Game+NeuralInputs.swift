//
//  Game+NeuralInputs.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import Foundation

extension SquareState {
    public func toInputs(for player: Player) -> [Double] {
        var inputs: [Double] = [Double](repeating: 0, count: 9)
        var activeInputIndex = 0
        switch self {
        case .empty:
            break
        case .occupied(let cellPlayer, let piece):
            switch piece {
            case .pawn:
                activeInputIndex = 1
            case .knight:
                activeInputIndex = 2
            case .bishop:
                activeInputIndex = 3
            case .rook:
                activeInputIndex = 4
            }
            if player != cellPlayer {
                activeInputIndex += 4
            }
        }
        inputs[activeInputIndex] = 1
        return inputs
    }
}

extension Game {
    public func toInputs() -> [Double] {
        let inputArrays = board.data.map { $0.toInputs(for: turn) }
        var inputs = inputArrays.reduce([]) { $0 + $1 }
        if turn == .white {
            inputs.append(inputFromDirection(whitePawnDirection))
            inputs.append(inputFromDirection(blackPawnDirection))
        } else {
            inputs.append(inputFromDirection(blackPawnDirection))
            inputs.append(inputFromDirection(whitePawnDirection))
        }
        return inputs
    }
    
    func inputFromDirection(_ direction: Direction?) -> Double {
        guard let direction = direction else {
            return 0
        }
        switch direction {
        case .up:
            return 1
        case .down:
            return -1
        }
    }
}
