//#-hidden-code
//
//  Contents.swift
//
//  Created by Guillermo Cique on 23/03/2019.
//
//#-end-hidden-code
/*:
 We now know what makes a neural network a neural network, now let's see how they actually produce results. We will need an array of inputs, we can define what these inputs will be, how many we will have and what each of them and their value mean. Once we have it we can start feeding it to our neural network and start generating results.
 
 Here we can see what the network does, it feeds the inputs to its first layer, which generates some outputs, then proceeds to feed these outputs to the next layer, this process is repeated until we reach the final layer which will generate our final outputs.
 */
class NeuralNetwork {
    public let layers: [NeuralLayer]
    //#-hidden-code
    
    public init(layers: [NeuralLayer]) {
        self.layers = layers
    }
    //#-end-hidden-code
    
    func process(inputs: [Double]) -> [Double] {
        return layers.reduce(inputs) { $1.process(inputs: $0) }
    }
}
/*:
 Let's see what the layer is doing. The layer gets some inputs and feeds them all to every one of its neurons and generates an array of outputs, one ouput for each neuron.
 */
class NeuralLayer {
    let neurons: [Neuron]
    //#-hidden-code
    
    init(neurons: [Neuron]) {
        self.neurons = neurons
    }
    //#-end-hidden-code
    
    func process(inputs: [Double]) -> [Double] {
        return neurons.map { $0.process(inputs: inputs) }
    }
}
/*:
 The neuron looks like its doing all the work, it gets the inputs and pairs each one with the corresponding **weight**, multiplies the input by the weight and then sums it all up.
 
 Now that we have the sum of all these values we add the **bias**, the bias is a value independent of the inputs which increases the flexibility of the model.
 
 Finally we use a **sigmoid** function as our activation function, the sigmoid function will transform our output to a value between 0 and 1.
 */
class Neuron {
    var weights: [Double]
    var bias: Double
    //#-hidden-code
    
    init(weights: [Double], bias: Double) {
        self.weights = weights
        self.bias = bias
    }
    //#-end-hidden-code
    
    func process(inputs: [Double]) -> Double {
        let sum = zip(inputs, weights).reduce(0) { $0 + ($1.0*$1.1) }
        return sigmoid(sum + bias)
    }
}
//#-hidden-code
import Foundation
//#-end-hidden-code

// We will use the logistic function
func sigmoid(_ z: Double) -> Double {
    return 1.0 / (1.0 + exp(-z))
}
/*:
 On the live view you can play Tic Tac Toe against a real life neural network! This network has 3 layers, one input layer of 21 neurons and two hidden layers of 15 and 9 neurons each.
 
 It takes 27 inputs, 3 per square, having the first input active (a value of 1) when the square is empty, the second active when it's occupied by the current player and the third when it's occupied by the opponent. The other two have a value of 0.
 
 In the end it produces 9 outputs, 9 values between 0 and 1, the index of the max value is taken and it's considered the move the neural network wants to make, being the output 0 the coordinate (0,0) and the output 8 the coordinate (2,2).
 */
//#-hidden-code
//#-editable-code
//#-end-editable-code
//#-end-hidden-code
