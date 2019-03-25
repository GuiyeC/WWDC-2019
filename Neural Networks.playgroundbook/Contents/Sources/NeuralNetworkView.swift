//
//  NeuralNetworkView.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 24/03/2019.
//

import UIKit

public class NeuralNetworkView: UIView {
    struct Constants {
        static let activeColor: UIColor = UIColor(red: 47/255, green: 227/255, blue: 234/255, alpha: 1)
        static let inactiveColor: UIColor = UIColor(white: 0.2, alpha: 1)
        static let inactiveLinesOpacity: CGFloat = 0.7
    }
    
    let inputCount: Int
    public weak var neuralNetwork: NeuralNetwork? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public init(inputCount: Int, frame: CGRect = .zero) {
        self.inputCount = inputCount
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didLoad() {
        isOpaque = false
    }
    
    override public func draw(_ rect: CGRect) {
        guard let neuralNetwork = neuralNetwork else {
            return
        }
        var data = neuralNetwork.layers.map { layer -> [Double] in
            return layer.lastInputs ?? [Double](repeating: 0, count: layer.neurons.count)
        }
        if let lastOutputs = neuralNetwork.lastOutputs {
            data.append(lastOutputs)
        } else {
            data.insert([Double](repeating: 0, count: inputCount), at: 0)
        }
        let maxCount = data.map({ $0.count }).max()!
        let size = rect.height / CGFloat(maxCount)
        let halfSize = size/2
        let spaceBetween = (rect.width-size)/CGFloat(data.count-1)
        let ySpace: CGFloat = (maxCount-1 <= 0 ? 0 : (rect.height-size)/CGFloat(maxCount-1))
        let topPaddings: [CGFloat] = data.map { (rect.height - CGFloat($0.count) * size) / 2 }
        
        for layer in 0..<(data.count-1) {
            let x = CGFloat(layer) * spaceBetween + halfSize
            for dataPoint in 0..<data[layer].count {
                let dataPointY = CGFloat(dataPoint) * ySpace + topPaddings[layer] + halfSize
                let active = data[layer][dataPoint] >= 0.5
                if active {
                    Constants.activeColor.setStroke()
                } else {
                    Constants.inactiveColor.withAlphaComponent(Constants.inactiveLinesOpacity).setStroke()
                }
                let path = UIBezierPath()
                let nextX = CGFloat(layer+1) * spaceBetween + halfSize
                for nextdataPoint in 0..<data[layer+1].count {
                    let nextdataPointY = CGFloat(nextdataPoint) * ySpace + topPaddings[layer+1] + halfSize
                    path.move(to: CGPoint(x: x, y: dataPointY))
                    path.addLine(to: CGPoint(x: nextX, y: nextdataPointY))
                }
                path.lineWidth = 2
                path.stroke()
            }
        }
        
        let inset = size * 0.2
        let dataPointSize = size * 0.6
        for layer in 0..<data.count {
            let x = CGFloat(layer) * spaceBetween + inset
            for dataPoint in 0..<data[layer].count {
                let dataPointY = CGFloat(dataPoint) * ySpace + topPaddings[layer] + inset
                let active = data[layer][dataPoint] >= 0.5
                if active {
                    Constants.activeColor.setFill()
                } else {
                    Constants.inactiveColor.setFill()
                }
                let path = UIBezierPath(ovalIn: CGRect(x: x, y: dataPointY, width: dataPointSize, height: dataPointSize))
                path.fill()
            }
        }
    }
    
    public func reloadData() {
        setNeedsDisplay()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
}
