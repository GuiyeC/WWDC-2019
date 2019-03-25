//
//  TrainingViewController.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//

import UIKit
import PlaygroundSupport

public class TrainingViewController: BaseViewController {
    let neuralNetwork = NeuralNetwork(layers: [
        NeuralLayer(inputs: 3, neurons: 4),
        NeuralLayer(inputs: 4, neurons: 3)
        ])
    
    let iterations: UInt
    let inputs: [[Double]] = [[1,0,0],[0,1,0],[0,0,1]]
    let goals: [[Double]]
    let networkView: NeuralNetworkView = NeuralNetworkView(inputCount: 3)
    let outputView: UIView = UIView()
    let goalView: UIView = UIView()
    let infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        infoLabel.text = "Tap on an input to see the neural network's output and the expected output side by side."
        infoLabel.textColor = .defaultTintColor
        infoLabel.textAlignment = .center
        infoLabel.layer.cornerRadius = 8
        infoLabel.layer.masksToBounds = true
        infoLabel.backgroundColor = UIColor.defaultBackgroundColor.withAlphaComponent(0.8)
        return infoLabel
    }()
    
    public init(iterations: UInt, goalColors: [UIColor]) {
        self.iterations = iterations
        self.goals = goalColors.map { $0.cgColor.components!.dropLast().map { Double($0) } }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Train the network
        for _ in 0..<iterations {
            zip(inputs, goals).forEach {
                neuralNetwork.process(inputs: $0)
                neuralNetwork.update(goals: $1)
            }
        }
        neuralNetwork.clearPreviousData()
        networkView.neuralNetwork = neuralNetwork
        networkView.translatesAutoresizingMaskIntoConstraints = false
        
        let resultsView = UIStackView(arrangedSubviews: [
            setUpResultView(outputView, title: "Output"),
            setUpResultView(goalView, title: "Goal")
            ])
        resultsView.translatesAutoresizingMaskIntoConstraints = false
        resultsView.spacing = 16
        resultsView.axis = .horizontal
        resultsView.distribution = .fillEqually
        
        let inputButtons: [Button] = (1...3).map { index in
            let button = Button()
            button.titleLabel.text = "Input \(index)"
            button.tag = index-1
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            return button
        }
        let buttonsView = UIStackView(arrangedSubviews: inputButtons)
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.spacing = 16
        buttonsView.axis = .horizontal
        buttonsView.distribution = .fillEqually
        
        view.addSubview(networkView)
        view.addSubview(resultsView)
        view.addSubview(buttonsView)
        view.addSubview(infoLabel)
        
        let padding: CGFloat = 32
        NSLayoutConstraint.activate([
            networkView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: padding),
            networkView.leftAnchor.constraint(equalTo: liveViewSafeAreaGuide.leftAnchor, constant: padding),
            networkView.rightAnchor.constraint(equalTo: liveViewSafeAreaGuide.rightAnchor, constant: -padding),
            resultsView.topAnchor.constraint(equalTo: networkView.bottomAnchor, constant: 24),
            resultsView.leftAnchor.constraint(equalTo: liveViewSafeAreaGuide.leftAnchor, constant: padding),
            resultsView.rightAnchor.constraint(equalTo: liveViewSafeAreaGuide.rightAnchor, constant: -padding),
            buttonsView.topAnchor.constraint(equalTo: resultsView.bottomAnchor, constant: 32),
            buttonsView.leftAnchor.constraint(equalTo: liveViewSafeAreaGuide.leftAnchor, constant: padding),
            buttonsView.rightAnchor.constraint(equalTo: liveViewSafeAreaGuide.rightAnchor, constant: -padding),
            buttonsView.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor, constant: -padding),
            infoLabel.leftAnchor.constraint(equalTo: resultsView.leftAnchor, constant: padding),
            infoLabel.rightAnchor.constraint(equalTo: resultsView.rightAnchor, constant: -padding),
            infoLabel.centerYAnchor.constraint(equalTo: resultsView.centerYAnchor),
            networkView.heightAnchor.constraint(equalTo: resultsView.heightAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setUpResultView(_ resultView: UIView, title: String) -> UIView {
        resultView.layer.cornerRadius = 16
        resultView.layer.borderColor = view.tintColor.withAlphaComponent(0.4).cgColor
        resultView.layer.borderWidth = 2
        let label = UILabel()
        label.text = title
        label.textColor = view.tintColor
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.setContentHuggingPriority(.required, for: .vertical)
        let stackView = UIStackView(arrangedSubviews: [label, resultView])
        stackView.spacing = 16
        stackView.axis = .vertical
        return stackView
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        let tag = sender.tag
        let output = neuralNetwork.process(inputs: inputs[tag])
        let goal = goals[tag]
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: {
                self.infoLabel.removeFromSuperview()
                self.outputView.backgroundColor = UIColor(componets: output)
                self.goalView.backgroundColor = UIColor(componets: goal)
        }, completion: nil)
        UIView.transition(
            with: networkView,
            duration: 0.3,
            options: [.beginFromCurrentState, .allowUserInteraction, .transitionCrossDissolve],
            animations: {
                self.networkView.reloadData()
        }, completion: nil)
    }
}

extension UIColor {
    convenience init(componets: [Double]) {
        self.init(red: CGFloat(componets[0]),
                  green: CGFloat(componets[1]),
                  blue: CGFloat(componets[2]),
                  alpha: 1)
    }
}
