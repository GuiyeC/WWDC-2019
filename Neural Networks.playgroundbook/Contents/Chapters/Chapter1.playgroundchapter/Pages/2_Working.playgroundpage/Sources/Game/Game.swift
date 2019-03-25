//
//  Game.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 24/03/2019.
//

import Foundation

public enum Player {
    case white
    case black
    
    mutating func change() {
        switch self {
        case .white: self = .black
        case .black: self = .white
        }
    }
}

public enum GameState: Equatable {
    case ongoing
    case draw
    case won(player: Player)
}

public class Game {
    public private(set) var turn: Player = .white
    public private(set) var state: GameState = .ongoing
    public private(set) var board: Board = Board()
    public private(set) var history: [Coordinate] = []
    
    public init() {}
    
    @discardableResult
    public func performMove(_ coordinate: Coordinate) throws -> GameState {
        guard checkLegalMove(coordinate) else {
            throw NSError(domain: "", code: 1, userInfo: nil)
        }
        board[coordinate] = .occupied(player: turn)
        history.insert(coordinate, at: 0)
        if board.checkWinner(player: turn) {
            state = .won(player: turn)
        } else if checkDraw() {
            state = .draw
        }
        turn.change()
        return state
    }
    
    func undo() {
        guard !history.isEmpty else {
            return
        }
        let lastCoordinate = history.removeFirst()
        turn.change()
        board[lastCoordinate] = .empty
        state = .ongoing
    }
    
    func checkDraw() -> Bool {
        return !board.data.contains { $0 == .empty }
    }
}
