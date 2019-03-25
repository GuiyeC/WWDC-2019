//
//  NeuralNetwork.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import Foundation

func sigmoid(_ z: Double) -> Double {
    return 1.0 / (1.0 + exp(-z))
}

/* When backpropagating we can take advantage that we already have sigmoid(z)
 and use that to simplify obtaining its derivative */
func derivative(sigmoid z: Double) -> Double {
    return z * (1 - z)
}

public class Neuron: Codable {
    public internal(set) var weights: [Double]
    public internal(set) var bias: Double
    
    init(weights: [Double], bias: Double) {
        self.weights = weights
        self.bias = bias
    }
    
    func process(inputs: [Double]) -> Double {
        let sum = zip(inputs, weights).reduce(0) { $0 + ($1.0*$1.1) }
        return sigmoid(sum + bias)
    }
}

public class NeuralLayer: Codable {
    public let neurons: [Neuron]
    public internal(set) var lastInputs: [Double]?
    
    init(neurons: [Neuron]) {
        self.neurons = neurons
    }
    
    public init(inputs: Int, neurons: Int) {
        self.neurons = (0..<neurons).map { _ in
            let weights = (0..<inputs).map { _ in Double.random(in: 0...0.1) }
            return Neuron(weights: weights, bias: 0)
        }
    }
    
    func process(inputs: [Double]) -> [Double] {
        // We can save the inputs to save us computations when backpropagating
        lastInputs = inputs
        let outputs = neurons.map { $0.process(inputs: inputs) }
        return outputs
    }
    
    enum CodingKeys: String, CodingKey {
        case neurons
    }
}

public class NeuralNetwork: Codable {
    public let layers: [NeuralLayer]
    // We can set the rate at which weights and biases are updated
    // This is useful to avoid overcorrecting which could cause
    // the network to forget what it already has learnt
    public var learningRate: Double = 1
    public var biasLearningRate: Double = 1
    public internal(set) var lastOutputs: [Double]?
    
    public init(layers: [NeuralLayer]) {
        self.layers = layers
    }
    
    @discardableResult
    public func process(inputs: [Double]) -> [Double] {
        let ouputs = layers.reduce(inputs) { $1.process(inputs: $0) }
        // We can save the ouputs to save us computations when backpropagating
        lastOutputs = ouputs
        return ouputs
    }
    
    public func update(goals: [Double]) {
        guard let lastOutputs = lastOutputs else {
            fatalError("Can't update layer withour previous data")
        }
        precondition(lastOutputs.count == goals.count, "Output and goal counts don't match")
        
        // First, we calculate how wrong we were
        var lastDeltas = zip(lastOutputs, goals).map { (derivative(sigmoid: $0) * ($0 - $1)) }
        var layerDeltas = [lastDeltas]
        
        // We iterate the layers backwards calculating the errors of each one of them
        for layer in layers.reversed() {
            guard let inputs = layer.lastInputs else {
                fatalError("Can't update layer withour previous data")
            }
            var newDeltas: [Double] = []
            for (index, input) in inputs.enumerated() {
                var weights = [Double]()
                for neuron in layer.neurons {
                    weights.append(neuron.weights[index])
                }
                let dot = zip(lastDeltas, weights).reduce(0) { $0 + ($1.0*$1.1) }
                let r = derivative(sigmoid: input) * dot
                newDeltas.append(r)
            }
            layerDeltas.append(newDeltas)
            lastDeltas = newDeltas
        }
        
        /* Finally we update the weights and biases
         The more they contribute to the error the more they need to change */
        for (deltas, layer) in zip(layerDeltas, layers.reversed()) {
            guard let inputs = layer.lastInputs else {
                fatalError("Can't update layer withour previous data")
            }
            for (delta, neuron) in zip(deltas, layer.neurons) {
                /* The bias is also updated when backpropagating
                 it's updated as if it had an input of 1 */
                neuron.bias -= delta * biasLearningRate
                for (index, input) in inputs.enumerated() {
                    let change = delta * input * learningRate
                    neuron.weights[index] -= change
                }
            }
        }
    }
    
    public func clearPreviousData() {
        lastOutputs = nil
        for layer in layers {
            layer.lastInputs = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case layers
    }
}
