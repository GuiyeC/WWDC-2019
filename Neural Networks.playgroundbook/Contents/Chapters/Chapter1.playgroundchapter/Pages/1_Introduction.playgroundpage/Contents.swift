//#-hidden-code
//
//  Contents.swift
//
//  Created by Guillermo Cique on 23/03/2019.
//
//#-end-hidden-code
/*:
 # Neural Networks: How do they work? How do they learn?? Let's find out!
 Neural networks are brain-inspired systems which try to replicate the way that we humans learn. You might be thinking "Well obviously, I still don't know what they are or how they work", but don't worry, today we are gonna try to grasp what are the building blocks of a neural network and how do they actually work.
 
 They might be inspired by how a brain works, but they are far from having the same complexity. A neural network is basically an array of ```NeuralLayer```:
 */
class NeuralNetwork {
    let layers: [NeuralLayer]
    //#-hidden-code
    
    init(layers: [NeuralLayer]) {
        self.layers = layers
    }
    //#-end-hidden-code
}
/*:
 We will call the first of these layers the **input layer**, the output of the last layer will be our **output layer** and all the layers in between will be called **hidden layers** because a neural network basically works as a __black box__, you feed it some data and receive an answer.
 
 This layers are themselves formed by an array of ```Neuron```:
 */
class NeuralLayer {
    let neurons: [Neuron]
    //#-hidden-code
    
    init(neurons: [Neuron]) {
        self.neurons = neurons
    }
    //#-end-hidden-code
}
/*:
 The layer will need a neuron for each output we want it to have.
 
 Finally these neurons are basically an array of **weights**, one weight for every input of the layer, and a **bias**:
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
}
/*:
 On the live view you have an example of a neural network being fed random data, each line of circles on the view on the right is a layer, each circle on the view on the right is a neuron and the lines joining the circles represent the weights.
 
 Let's continue to the next page to actually see how we can feed them some inputs and get some results.
 */
//#-hidden-code
//#-editable-code
//#-end-editable-code
//#-end-hidden-code
