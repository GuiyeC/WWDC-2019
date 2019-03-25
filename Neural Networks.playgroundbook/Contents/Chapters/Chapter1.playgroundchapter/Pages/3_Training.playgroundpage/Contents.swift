//#-hidden-code
//
//  Contents.swift
//
//  Created by Guillermo Cique on 23/03/2019.
//
//#-end-hidden-code
/*:
 This is all cool but, **how do they learn?** Well, that might be the trickiest part of all. Training a neural network can be more art than science. After getting some results from a neural network we might not be able to measure how wrong they are or even if they are wrong at all. We would need some way of letting it know its doing a good job or if it's not, give it data to improve towards better results.
 
 There is a lot of math involved in training a neural network, so taking that into account, let's try to at least understand what's going on without digging too deep into the mathematics of it.
 
 A way of updating the weights and biases of a neural network in order to improve it is called **backpropagation**. Basically we will take the actual outputs of a neural network, compare them to a set of goal outputs and calculate how wrong our predictions were. Then we iterate backwards calculating the amount of error each neuron on each layer is responsible for. Finally we calibrate all the weights and biases to end up with an improved neural network. We need to repeat this process calibrating little by little until we have a neural network that is able to output correct values.
 */
class NeuralNetwork {
    let layers: [NeuralLayer]
    /* We can set the rate at which weights and biases are updated
       This is useful to avoid overcorrecting which could cause
       the network to forget what it already has learnt */
    var learningRate: Double = 0.2
    var biasLearningRate: Double = 0.2
    // We can save the ouputs to save us computations when backpropagating
    var lastOutputs: [Double]?
    //#-hidden-code
    
    init(layers: [NeuralLayer]) {
        self.layers = layers
    }
    //#-end-hidden-code
    
    func update(goals: [Double]) {
        var lastOutputs = self.lastOutputs!
        
        // First, we calculate how wrong we were
        var lastDeltas = zip(lastOutputs, goals).map { (derivative(sigmoid: $0) * ($0 - $1)) }
        var layerDeltas = [lastDeltas]
        
        // We iterate the layers backwards calculating the errors of each one of them
        for layer in layers.reversed() {
            let inputs = layer.lastInputs!
            
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
            var inputs = layer.lastInputs!
            
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
}

/* When backpropagating we can take advantage that we already have sigmoid(z)
 and use that to simplify obtaining its derivative */
func derivative(sigmoid z: Double) -> Double {
    return z * (1 - z)
}
//#-hidden-code
func sigmoid(_ z: Double) -> Double {
    return 1.0 / (1.0 + exp(-z))
}

class NeuralLayer {
    let neurons: [Neuron] = []
    var lastInputs: [Double]?
}

class Neuron {
    var weights: [Double] = []
    var bias: Double = 0
}

import UIKit
//#-end-hidden-code
/*:
 Here you can play with training your own neural network, try entering different colors and changing the amoung of iterations to see how it affects the outputs of the neural network.
 */
let trainingIterations: UInt = /*#-editable-code*/1000/*#-end-editable-code*/
let input1Color: UIColor = /*#-editable-code*/.cyan/*#-end-editable-code*/
let input2Color: UIColor = /*#-editable-code*/.yellow/*#-end-editable-code*/
let input3Color: UIColor = /*#-editable-code*/UIColor(red: 253/255, green: 26/255, blue: 146/255, alpha: 1)/*#-end-editable-code*/
/*:
 These colors will be transformed to an array of values (red, green, blue), then you will be able to select the input by pressing a button and the neural network will try to predict what the expected color is.
 */
//#-hidden-code
import PlaygroundSupport

let viewController = TrainingViewController(iterations: trainingIterations,
                                            goalColors: [input1Color, input2Color, input3Color])
PlaygroundPage.current.liveView = viewController
//#-end-hidden-code
