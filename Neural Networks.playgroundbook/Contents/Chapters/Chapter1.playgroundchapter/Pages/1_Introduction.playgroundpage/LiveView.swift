//
//  LiveView.swift
//
//  Created by Guillermo Cique on 23/03/2019.
//

import UIKit
import PlaygroundSupport

class IntroductionViewController: BaseViewController {
    let neuralNetwork = NeuralNetwork(layers: [
        NeuralLayer(inputs: 6, neurons: 8),
        NeuralLayer(inputs: 8, neurons: 8),
        NeuralLayer(inputs: 8, neurons: 4)
        ])
    let networkView: NeuralNetworkView = NeuralNetworkView(inputCount: 6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var inputs: [[Double]] = [[Double]](repeating: [0,0,0,0,0,0], count: 6)
        for index in 0..<inputs.count {
            inputs[index][index] = 1
        }
        let goals: [[Double]] = (0..<6).map { _ in (0..<4).map { _ in Double(Int.random(in: 0...1)) } }
        
        // Train the network
        for _ in 0..<1000 {
            zip(inputs, goals).forEach {
                neuralNetwork.process(inputs: $0)
                neuralNetwork.update(goals: $1)
            }
        }
        
        networkView.neuralNetwork = neuralNetwork
        networkView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(networkView)
        
        let padding: CGFloat = 32
        NSLayoutConstraint.activate([
            networkView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: padding),
            networkView.leftAnchor.constraint(equalTo: liveViewSafeAreaGuide.leftAnchor, constant: padding),
            networkView.rightAnchor.constraint(equalTo: liveViewSafeAreaGuide.rightAnchor, constant: -padding),
            networkView.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor, constant: -padding)
            ])
        updateNeuralNetwork()
    }
    
    var lastInput: Int?
    func updateNeuralNetwork() {
        var inputs: [Double] = [Double](repeating: 0, count: 6)
        var selectedInput = Int.random(in: 0..<inputs.count)
        while selectedInput == lastInput {
            selectedInput = Int.random(in: 0..<inputs.count)
        }
        lastInput = selectedInput
        inputs[selectedInput] = 1
        neuralNetwork.process(inputs: inputs)
        
        UIView.transition(
            with: networkView,
            duration: 0.3,
            options: [.beginFromCurrentState, .allowUserInteraction, .transitionCrossDissolve],
            animations: {
                self.networkView.reloadData()
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600)) {
            self.updateNeuralNetwork()
        }
    }
}

// Instantiate a new instance of the live view from the book's auxiliary sources and pass it to PlaygroundSupport.
PlaygroundPage.current.liveView = IntroductionViewController()
