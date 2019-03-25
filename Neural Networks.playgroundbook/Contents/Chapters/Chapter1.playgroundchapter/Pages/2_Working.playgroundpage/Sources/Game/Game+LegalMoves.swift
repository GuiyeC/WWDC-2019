//
//  Game+LegalMoves.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 24/03/2019.
//

import Foundation

extension Game {
    public func calculateLegalMoves() -> [Coordinate] {
        guard state == .ongoing else {
            return []
        }
        return (0..<9).filter { checkLegalMove($0) }
    }
    
    func checkLegalMove(_ coordinate: Coordinate) -> Bool {
        return board[coordinate] == .empty
    }
}
