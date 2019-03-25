//
//  Game+NeuralInputs.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 24/03/2019.
//

import Foundation

extension SquareState {
    public func toInputs(for player: Player) -> [Double] {
        var inputs: [Double] = [Double](repeating: 0, count: 3)
        switch self {
        case .empty:
            inputs[0] = 1
        case .occupied(let cellPlayer):
            if player == cellPlayer {
                inputs[1] = 1
            } else {
                inputs[2] = 1
            }
        }
        return inputs
    }
}

extension Game {
    public func toInputs() -> [Double] {
        let inputArrays = board.data.map { $0.toInputs(for: turn) }
        return inputArrays.reduce([]) { $0 + $1 }
    }
}
