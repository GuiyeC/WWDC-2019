//
//  Board.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import Foundation

public typealias Coordinate = Int

extension Coordinate {
    public var x: Int {
        return self - 4*y
    }
    public var y: Int {
        return self/4
    }
    public init(x: Int, y: Int) {
        self = y*4 + x
    }
    public func inverse() -> Coordinate {
        return (self - 15) * -1
    }
}

public enum SquareState: Equatable {
    case empty
    case occupied(player: Player, piece: Piece)
}

public struct Board {
    private(set) var data: [SquareState]
    public private(set) var whitePieces: [Piece: Int] = [:]
    public private(set) var blackPieces: [Piece: Int] = [:]
    
    init(data: [SquareState]) {
        self.data = data
        for (index, state) in data.enumerated() {
            if case .occupied(let player, let piece) = state {
                if player == .white {
                    whitePieces.updateValue(index, forKey: piece)
                } else {
                    blackPieces.updateValue(index, forKey: piece)
                }
            }
        }
    }
    
    init() {
        self.data = [SquareState](repeating: .empty, count: 16)
    }
    
    public subscript(cell: Int) -> SquareState {
        get {
            return data[cell]
        }
        set(newValue) {
            if case .occupied(let player, let piece) = data[cell] {
                if player == .white {
                    whitePieces.removeValue(forKey: piece)
                } else {
                    blackPieces.removeValue(forKey: piece)
                }
            }
            if case .occupied(let player, let piece) = newValue {
                if player == .white {
                    whitePieces.updateValue(cell, forKey: piece)
                } else {
                    blackPieces.updateValue(cell, forKey: piece)
                }
            }
            data[cell] = newValue
        }
    }
    
    func coordinateFor(piece: Piece, player: Player) -> Coordinate? {
        switch player {
        case .white:
            if let cell = whitePieces[piece] {
                return cell
            }
        case .black:
            if let cell = blackPieces[piece] {
                return cell
            }
        }
        return nil
    }
    
    func pieceCount(for player: Player) -> Int {
        switch player {
        case .white:
            return whitePieces.count
        case .black:
            return blackPieces.count
        }
    }
    
    func checkWinner(player: Player) -> Bool {
        switch player {
        case .white:
            return checkWinner(pieces: whitePieces)
        case .black:
            return checkWinner(pieces: blackPieces)
        }
    }
    
    private func checkWinner(pieces: [Piece:Int]) -> Bool {
        guard pieces.count == 4 else {
            return false
        }
        let coordinates = pieces.values.sorted()
        // Horizontal
        if coordinates[0]%4 == 0,
            coordinates[3] == coordinates[0] + 3 {
            return true
        }
        // Vertical
        if coordinates[0]%4 == coordinates[1]%4,
            coordinates[0]%4 == coordinates[2]%4,
            coordinates[0]%4 == coordinates[3]%4 {
            return true
        }
        // Diagonal top left to bottom right
        if !coordinates.contains(where: { $0%5 != 0} ) {
            return true
        }
        // Diagonal top right to bottom left
        if !coordinates.contains(where: { ($0 == 0 || $0 == 15 || $0%3 != 0) }) {
            return true
        }
        return false
    }
    
    func alignedPieceCount(for player: Player) -> Int {
        switch player {
        case .white:
            return alignedPieceCount(pieces: whitePieces)
        case .black:
            return alignedPieceCount(pieces: blackPieces)
        }
    }
    
    private func alignedPieceCount(pieces: [Piece:Int]) -> Int {
        let coordinates = pieces.values.sorted()
        var piecesPerRow = [
            coordinates.filter({ $0%5 == 0 }).count,
            coordinates.filter({ ($0 != 0 && $0 != 15 && $0%3 == 0) }).count
        ]
        for i in stride(from: 0, to: 16, by: 4) {
            piecesPerRow.append(
                coordinates.filter({ ($0 >= i && $0 < i+4) }).count
            )
        }
        for i in 0..<4 {
            piecesPerRow.append(
                coordinates.filter({ $0%4 == i }).count
            )
        }
        return piecesPerRow.max()!
    }
}
