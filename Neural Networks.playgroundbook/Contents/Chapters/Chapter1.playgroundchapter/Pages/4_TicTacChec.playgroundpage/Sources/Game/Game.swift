//
//  Game.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
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

public enum Piece: Int, CaseIterable, Codable {
    case pawn = 0
    case knight
    case bishop
    case rook
}

public enum Direction {
    case up
    case down
    
    func inverse() -> Direction {
        switch self {
        case .up:
            return .down
        case .down:
            return .up
        }
    }
}

public struct Move: Equatable, Hashable, Codable {
    public let piece: Piece
    public let coordinate: Coordinate
    
    public init(piece: Piece, coordinate: Coordinate) {
        self.piece = piece
        self.coordinate = coordinate
    }
}

public struct UndoData: Equatable {
    public let previousCoordinate: Coordinate?
    public let move: Move
    public let previousSquareState: SquareState
    public let whitePawnDirection: Direction?
    public let blackPawnDirection: Direction?
}

public enum GameState: Equatable {
    case ongoing
    case draw
    case won(player: Player)
}

public enum GameError: Error {
    case invalidMove
}

public class Game {
    public var depthOffset: Int = 1
    public private(set) var turn: Player = .white
    public private(set) var state: GameState = .ongoing
    public private(set) var board: Board = Board()
    public private(set) var whitePawnDirection: Direction?
    public private(set) var blackPawnDirection: Direction?
    public private(set) var history: [UndoData] = []
    
    public init() {}
    
    @discardableResult
    public func performMove(_ move: Move) throws -> GameState {
        guard checkLegalMove(move) else {
            throw GameError.invalidMove
        }
        let piece = move.piece
        let coordinate = move.coordinate
        let previousCoordinate = board.coordinateFor(piece: piece, player: turn)
        let undoData = UndoData(previousCoordinate: previousCoordinate,
                                move: move,
                                previousSquareState: board[coordinate],
                                whitePawnDirection: whitePawnDirection,
                                blackPawnDirection: blackPawnDirection)
        if let previousCoordinate = previousCoordinate {
            board[previousCoordinate] = .empty
        }
        if case .occupied(let cellPlayer, let cellPiece) = board[coordinate],
            cellPiece == .pawn {
            if cellPlayer == .white {
                whitePawnDirection = nil
            } else {
                blackPawnDirection = nil
            }
        }
        board[coordinate] = .occupied(player: turn, piece: piece)
        if piece == .pawn {
            if coordinate.y == 0 {
                if turn == .white {
                    whitePawnDirection = .down
                } else {
                    blackPawnDirection = .down
                }
            } else if coordinate.y == 3 {
                if turn == .white {
                    whitePawnDirection = .up
                } else {
                    blackPawnDirection = .up
                }
            } else if previousCoordinate == nil {
                if turn == .white {
                    whitePawnDirection = .up
                } else {
                    blackPawnDirection = .down
                }
            }
        }
        history.insert(undoData, at: 0)
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
        let undoData = history.removeFirst()
        turn.change()
        board[undoData.move.coordinate] = undoData.previousSquareState
        if let previousCoordinate = undoData.previousCoordinate {
            board[previousCoordinate] = .occupied(player: turn, piece: undoData.move.piece)
        }
        state = .ongoing
        whitePawnDirection = undoData.whitePawnDirection
        blackPawnDirection = undoData.blackPawnDirection
    }
    
    func checkDraw() -> Bool {
        guard history.count >= 12 else {
            return false
        }
        guard history.count < 80 else {
            return true
        }
        return history[0].move == history[4].move && history[1].move == history[5].move
            && history[0].move == history[8].move && history[1].move == history[9].move
            && history[2].move == history[6].move && history[3].move == history[7].move
            && history[2].move == history[10].move && history[3].move == history[11].move
    }
}
