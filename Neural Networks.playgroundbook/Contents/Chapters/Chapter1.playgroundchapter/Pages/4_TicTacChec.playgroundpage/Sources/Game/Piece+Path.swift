//
//  Piece+Path.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import UIKit

extension Piece {
    public var path: UIBezierPath {
        switch self {
        case .pawn:
            return PiecePath.pawn.copy() as! UIBezierPath
        case .knight:
            return PiecePath.knight.copy() as! UIBezierPath
        case .bishop:
            return PiecePath.bishop.copy() as! UIBezierPath
        case .rook:
            return PiecePath.rook.copy() as! UIBezierPath
        }
    }
}

fileprivate struct PiecePath {
    static let pawn: UIBezierPath = {
        let pawnPath = UIBezierPath()
        pawnPath.move(to: CGPoint(x: 59.29, y: 38.16))
        pawnPath.addCurve(to: CGPoint(x: 48.79, y: 21.5), controlPoint1: CGPoint(x: 59.29, y: 38.16), controlPoint2: CGPoint(x: 51.54, y: 21.5))
        pawnPath.addCurve(to: CGPoint(x: 37.5, y: 38.5), controlPoint1: CGPoint(x: 46.03, y: 21.5), controlPoint2: CGPoint(x: 37.5, y: 38.5))
        pawnPath.move(to: CGPoint(x: 37.5, y: 51.5))
        pawnPath.addCurve(to: CGPoint(x: 33.6, y: 63.55), controlPoint1: CGPoint(x: 33.5, y: 56.5), controlPoint2: CGPoint(x: 33.47, y: 61.18))
        pawnPath.addCurve(to: CGPoint(x: 48.08, y: 78.44), controlPoint1: CGPoint(x: 34.02, y: 71.34), controlPoint2: CGPoint(x: 40.24, y: 77.75))
        pawnPath.addCurve(to: CGPoint(x: 65.48, y: 61.85), controlPoint1: CGPoint(x: 57.83, y: 79.29), controlPoint2: CGPoint(x: 65.97, y: 71.45))
        pawnPath.addCurve(to: CGPoint(x: 49.72, y: 46.85), controlPoint1: CGPoint(x: 65.06, y: 53.57), controlPoint2: CGPoint(x: 58.09, y: 46.95))
        pawnPath.addCurve(to: CGPoint(x: 44.71, y: 47.59), controlPoint1: CGPoint(x: 47.97, y: 46.83), controlPoint2: CGPoint(x: 46.29, y: 47.09))
        return pawnPath
    }()
    static let knight: UIBezierPath = {
        let knightPath = UIBezierPath()
        knightPath.move(to: CGPoint(x: 34.66, y: 52.33))
        knightPath.addCurve(to: CGPoint(x: 21.31, y: 57.65), controlPoint1: CGPoint(x: 26.38, y: 61.54), controlPoint2: CGPoint(x: 22.89, y: 59.4))
        knightPath.addCurve(to: CGPoint(x: 42.85, y: 28.15), controlPoint1: CGPoint(x: 18.39, y: 54.4), controlPoint2: CGPoint(x: 37.17, y: 25.31))
        knightPath.addCurve(to: CGPoint(x: 42.96, y: 76.89), controlPoint1: CGPoint(x: 49.54, y: 31.48), controlPoint2: CGPoint(x: 36.42, y: 71.85))
        knightPath.addCurve(to: CGPoint(x: 79.11, y: 77.3), controlPoint1: CGPoint(x: 49.77, y: 82.14), controlPoint2: CGPoint(x: 62.66, y: 80.16))
        
        knightPath.move(to: CGPoint(x: 44.8, y: 20))
        knightPath.addCurve(to: CGPoint(x: 51.55, y: 52.12), controlPoint1: CGPoint(x: 55.47, y: 22.31), controlPoint2: CGPoint(x: 53.5, y: 39.31))
        
        knightPath.move(to: CGPoint(x: 36.96, y: 40.59))
        knightPath.addCurve(to: CGPoint(x: 36.96, y: 40.59), controlPoint1: CGPoint(x: 36.88, y: 40.86), controlPoint2: CGPoint(x: 37.03, y: 40.32))
        return knightPath
    }()
    static let bishop: UIBezierPath = {
        let bishopPath = UIBezierPath()
        bishopPath.move(to: CGPoint(x: 39.73, y: 68.67))
        bishopPath.addLine(to: CGPoint(x: 48.38, y: 62.62))
        bishopPath.addCurve(to: CGPoint(x: 51.62, y: 62.62), controlPoint1: CGPoint(x: 49.36, y: 61.95), controlPoint2: CGPoint(x: 50.64, y: 61.95))
        bishopPath.addLine(to: CGPoint(x: 73.47, y: 77.48))
        bishopPath.addCurve(to: CGPoint(x: 77.48, y: 73.47), controlPoint1: CGPoint(x: 76.1, y: 79.27), controlPoint2: CGPoint(x: 79.27, y: 76.1))
        bishopPath.addLine(to: CGPoint(x: 62.62, y: 51.62))
        bishopPath.addCurve(to: CGPoint(x: 62.62, y: 48.38), controlPoint1: CGPoint(x: 61.95, y: 50.64), controlPoint2: CGPoint(x: 61.95, y: 49.36))
        bishopPath.addLine(to: CGPoint(x: 77.48, y: 26.53))
        bishopPath.addCurve(to: CGPoint(x: 73.47, y: 22.52), controlPoint1: CGPoint(x: 79.27, y: 23.9), controlPoint2: CGPoint(x: 76.1, y: 20.73))
        bishopPath.addLine(to: CGPoint(x: 51.62, y: 37.38))
        bishopPath.addCurve(to: CGPoint(x: 48.38, y: 37.38), controlPoint1: CGPoint(x: 50.64, y: 38.05), controlPoint2: CGPoint(x: 49.36, y: 38.05))
        bishopPath.addLine(to: CGPoint(x: 26.53, y: 22.52))
        bishopPath.addCurve(to: CGPoint(x: 22.52, y: 26.53), controlPoint1: CGPoint(x: 23.9, y: 20.73), controlPoint2: CGPoint(x: 20.73, y: 23.9))
        bishopPath.addLine(to: CGPoint(x: 37.38, y: 48.38))
        bishopPath.addCurve(to: CGPoint(x: 37.38, y: 51.62), controlPoint1: CGPoint(x: 38.05, y: 49.36), controlPoint2: CGPoint(x: 38.05, y: 50.64))
        bishopPath.addLine(to: CGPoint(x: 22.52, y: 73.47))
        bishopPath.addCurve(to: CGPoint(x: 26.53, y: 77.48), controlPoint1: CGPoint(x: 20.73, y: 76.1), controlPoint2: CGPoint(x: 23.9, y: 79.27))
        bishopPath.addLine(to: CGPoint(x: 31.33, y: 74.27))
        return bishopPath
    }()
    static let rook: UIBezierPath = {
        let rookPath = UIBezierPath()
        rookPath.move(to: CGPoint(x: 25.16, y: 41.9))
        rookPath.addLine(to: CGPoint(x: 24.8, y: 41.9))
        rookPath.addCurve(to: CGPoint(x: 23, y: 40.1), controlPoint1: CGPoint(x: 23.81, y: 41.9), controlPoint2: CGPoint(x: 23, y: 41.1))
        rookPath.addLine(to: CGPoint(x: 23, y: 28.4))
        rookPath.addCurve(to: CGPoint(x: 28.4, y: 23), controlPoint1: CGPoint(x: 23, y: 25.42), controlPoint2: CGPoint(x: 25.42, y: 23))
        rookPath.addLine(to: CGPoint(x: 40.1, y: 23))
        rookPath.addCurve(to: CGPoint(x: 41.9, y: 24.8), controlPoint1: CGPoint(x: 41.1, y: 23), controlPoint2: CGPoint(x: 41.9, y: 23.81))
        rookPath.addLine(to: CGPoint(x: 41.9, y: 33.8))
        rookPath.addCurve(to: CGPoint(x: 43.7, y: 35.6), controlPoint1: CGPoint(x: 41.9, y: 34.8), controlPoint2: CGPoint(x: 42.71, y: 35.6))
        rookPath.addLine(to: CGPoint(x: 56.3, y: 35.6))
        rookPath.addCurve(to: CGPoint(x: 58.1, y: 33.8), controlPoint1: CGPoint(x: 57.29, y: 35.6), controlPoint2: CGPoint(x: 58.1, y: 34.8))
        rookPath.addLine(to: CGPoint(x: 58.1, y: 24.8))
        rookPath.addCurve(to: CGPoint(x: 59.9, y: 23), controlPoint1: CGPoint(x: 58.1, y: 23.81), controlPoint2: CGPoint(x: 58.9, y: 23))
        rookPath.addLine(to: CGPoint(x: 71.6, y: 23))
        rookPath.addCurve(to: CGPoint(x: 77, y: 28.4), controlPoint1: CGPoint(x: 74.58, y: 23), controlPoint2: CGPoint(x: 77, y: 25.42))
        rookPath.addLine(to: CGPoint(x: 77, y: 40.1))
        rookPath.addCurve(to: CGPoint(x: 75.2, y: 41.9), controlPoint1: CGPoint(x: 77, y: 41.1), controlPoint2: CGPoint(x: 76.19, y: 41.9))
        rookPath.addLine(to: CGPoint(x: 66.2, y: 41.9))
        rookPath.addCurve(to: CGPoint(x: 64.4, y: 43.7), controlPoint1: CGPoint(x: 65.2, y: 41.9), controlPoint2: CGPoint(x: 64.4, y: 42.71))
        rookPath.addLine(to: CGPoint(x: 64.4, y: 56.3))
        rookPath.addCurve(to: CGPoint(x: 66.2, y: 58.1), controlPoint1: CGPoint(x: 64.4, y: 57.29), controlPoint2: CGPoint(x: 65.2, y: 58.1))
        rookPath.addLine(to: CGPoint(x: 75.2, y: 58.1))
        rookPath.addCurve(to: CGPoint(x: 77, y: 59.9), controlPoint1: CGPoint(x: 76.19, y: 58.1), controlPoint2: CGPoint(x: 77, y: 58.9))
        rookPath.addLine(to: CGPoint(x: 77, y: 71.6))
        rookPath.addCurve(to: CGPoint(x: 71.6, y: 77), controlPoint1: CGPoint(x: 77, y: 74.58), controlPoint2: CGPoint(x: 74.58, y: 77))
        rookPath.addLine(to: CGPoint(x: 59.9, y: 77))
        rookPath.addCurve(to: CGPoint(x: 58.1, y: 75.2), controlPoint1: CGPoint(x: 58.9, y: 77), controlPoint2: CGPoint(x: 58.1, y: 76.19))
        rookPath.addLine(to: CGPoint(x: 58.1, y: 66.2))
        rookPath.addCurve(to: CGPoint(x: 56.3, y: 64.4), controlPoint1: CGPoint(x: 58.1, y: 65.2), controlPoint2: CGPoint(x: 57.29, y: 64.4))
        rookPath.addLine(to: CGPoint(x: 43.7, y: 64.4))
        rookPath.addCurve(to: CGPoint(x: 41.9, y: 66.2), controlPoint1: CGPoint(x: 42.71, y: 64.4), controlPoint2: CGPoint(x: 41.9, y: 65.2))
        rookPath.addLine(to: CGPoint(x: 41.9, y: 75.2))
        rookPath.addCurve(to: CGPoint(x: 40.1, y: 77), controlPoint1: CGPoint(x: 41.9, y: 76.19), controlPoint2: CGPoint(x: 41.1, y: 77))
        rookPath.addLine(to: CGPoint(x: 28.4, y: 77))
        rookPath.addCurve(to: CGPoint(x: 23, y: 71.6), controlPoint1: CGPoint(x: 25.42, y: 77), controlPoint2: CGPoint(x: 23, y: 74.58))
        rookPath.addLine(to: CGPoint(x: 23, y: 59.9))
        rookPath.addCurve(to: CGPoint(x: 24.8, y: 58.1), controlPoint1: CGPoint(x: 23, y: 58.9), controlPoint2: CGPoint(x: 23.81, y: 58.1))
        rookPath.addLine(to: CGPoint(x: 33.8, y: 58.1))
        rookPath.addCurve(to: CGPoint(x: 35.6, y: 56.3), controlPoint1: CGPoint(x: 34.8, y: 58.1), controlPoint2: CGPoint(x: 35.6, y: 57.29))
        rookPath.addLine(to: CGPoint(x: 35.6, y: 43.7))
        rookPath.addCurve(to: CGPoint(x: 33.8, y: 41.9), controlPoint1: CGPoint(x: 35.6, y: 42.71), controlPoint2: CGPoint(x: 34.8, y: 41.9))
        return rookPath
    }()
}
