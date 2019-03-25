//
//  Board.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 24/03/2019.
//

import Foundation

import Foundation

public enum SquareState: Equatable {
    case empty
    case occupied(player: Player)
}

public typealias Coordinate = Int

public struct Board {
    private(set) var data: [SquareState]
    public private(set) var whitePieces: Set<Int> = []
    public private(set) var blackPieces: Set<Int> = []
    
    init(data: [SquareState]) {
        self.data = data
        for (index, state) in data.enumerated() {
            if case .occupied(let player) = state {
                if player == .white {
                    whitePieces.insert(index)
                } else {
                    blackPieces.insert(index)
                }
            }
        }
    }
    
    init() {
        self.data = [SquareState](repeating: .empty, count: 9)
    }
    
    public subscript(cell: Int) -> SquareState {
        get {
            return data[cell]
        }
        set(newValue) {
            if case .occupied(let player) = data[cell] {
                if player == .white {
                    whitePieces.remove(cell)
                } else {
                    blackPieces.remove(cell)
                }
            }
            if case .occupied(let player) = newValue {
                if player == .white {
                    whitePieces.insert(cell)
                } else {
                    blackPieces.insert(cell)
                }
            }
            data[cell] = newValue
        }
    }
    
    func checkWinner(player: Player) -> Bool {
        switch player {
        case .white:
            return alignedPieceCount(pieces: whitePieces).max()! >= 3
        case .black:
            return alignedPieceCount(pieces: blackPieces).max()! >= 3
        }
    }
    
    func alignedPieceCount(for player: Player) -> [Int] {
        switch player {
        case .white:
            return alignedPieceCount(pieces: whitePieces)
        case .black:
            return alignedPieceCount(pieces: blackPieces)
        }
    }
    
    private func alignedPieceCount(pieces: Set<Int>) -> [Int] {
        let coordinates = pieces.sorted()
        var piecesPerRow = [
            coordinates.filter({ $0%4 == 0 }).count,
            coordinates.filter({ ($0 != 0 && $0 != 8 && $0%2 == 0) }).count
        ]
        for i in stride(from: 0, to: 9, by: 3) {
            piecesPerRow.append(
                coordinates.filter({ ($0 >= i && $0 < i+3) }).count
            )
        }
        for i in 0..<3 {
            piecesPerRow.append(
                coordinates.filter({ $0%3 == i }).count
            )
        }
        return piecesPerRow
    }
}
