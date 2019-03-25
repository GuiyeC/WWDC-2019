//
//  Player+Path.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 24/03/2019.
//

import UIKit

extension Player {
    var path: UIBezierPath {
        switch self {
        case .white:
            return PlayerPath.white.copy() as! UIBezierPath
        case .black:
            return UIBezierPath(ovalIn: CGRect(x: 20, y: 20, width: 60, height: 60))
        }
    }
}

fileprivate struct PlayerPath {
    static let white: UIBezierPath = {
        let whitePath = UIBezierPath()
        whitePath.move(to: CGPoint(x: 39, y: 70))
        whitePath.addLine(to: CGPoint(x: 48.26, y: 63.52))
        whitePath.addCurve(to: CGPoint(x: 51.74, y: 63.52), controlPoint1: CGPoint(x: 49.31, y: 62.81), controlPoint2: CGPoint(x: 50.69, y: 62.81))
        whitePath.addLine(to: CGPoint(x: 75.15, y: 79.44))
        whitePath.addCurve(to: CGPoint(x: 79.44, y: 75.15), controlPoint1: CGPoint(x: 77.97, y: 81.36), controlPoint2: CGPoint(x: 81.36, y: 77.97))
        whitePath.addLine(to: CGPoint(x: 63.52, y: 51.74))
        whitePath.addCurve(to: CGPoint(x: 63.52, y: 48.26), controlPoint1: CGPoint(x: 62.81, y: 50.69), controlPoint2: CGPoint(x: 62.81, y: 49.31))
        whitePath.addLine(to: CGPoint(x: 79.44, y: 24.85))
        whitePath.addCurve(to: CGPoint(x: 75.15, y: 20.56), controlPoint1: CGPoint(x: 81.36, y: 22.03), controlPoint2: CGPoint(x: 77.97, y: 18.64))
        whitePath.addLine(to: CGPoint(x: 51.74, y: 36.48))
        whitePath.addCurve(to: CGPoint(x: 48.26, y: 36.48), controlPoint1: CGPoint(x: 50.69, y: 37.19), controlPoint2: CGPoint(x: 49.31, y: 37.19))
        whitePath.addLine(to: CGPoint(x: 24.85, y: 20.56))
        whitePath.addCurve(to: CGPoint(x: 20.56, y: 24.85), controlPoint1: CGPoint(x: 22.03, y: 18.64), controlPoint2: CGPoint(x: 18.64, y: 22.03))
        whitePath.addLine(to: CGPoint(x: 36.48, y: 48.26))
        whitePath.addCurve(to: CGPoint(x: 36.48, y: 51.74), controlPoint1: CGPoint(x: 37.19, y: 49.31), controlPoint2: CGPoint(x: 37.19, y: 50.69))
        whitePath.addLine(to: CGPoint(x: 20.56, y: 75.15))
        whitePath.addCurve(to: CGPoint(x: 24.85, y: 79.44), controlPoint1: CGPoint(x: 18.64, y: 77.97), controlPoint2: CGPoint(x: 22.03, y: 81.36))
        whitePath.addLine(to: CGPoint(x: 30, y: 76))
        return whitePath
    }()
}
