//
//  LiveView.swift
//
//  Created by Guillermo Cique on 23/03/2019.
//

import UIKit
import PlaygroundSupport

class TicTacToeViewController: BaseViewController, TicTacToeViewDelegate {
    let gameView = TicTacToeView()
    var game = Game()
    var state: GameState {
        return game.state
    }
    let neuralNetwork: NeuralNetwork = {
        guard let fileUrl = Bundle.main.path(forResource: "ttt0_27x3_1", ofType: nil),
            FileManager.default.fileExists(atPath: fileUrl) else {
                fatalError("File does not exist!")
        }
        if let data = FileManager.default.contents(atPath: fileUrl) {
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(NeuralNetwork.self, from: data)
            } catch {
                fatalError("No data at \(fileUrl)!")
            }
        } else {
            fatalError("No data at \(fileUrl)!")
        }
    }()
    var playingAsWhite = true
    let messageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor.defaultBackgroundColor.withAlphaComponent(0.9)
        view.alpha = 0
        return view
    }()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .defaultTintColor
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackgroundColor
        view.tintColor = .defaultTintColor
        
        view.addSubview(gameView)
        gameView.translatesAutoresizingMaskIntoConstraints = false
        
        let restartButton = Button()
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.titleLabel.text = "Restart"
        restartButton.addTarget(self, action: #selector(restart), for: .touchUpInside)
        messageView.addSubview(messageLabel)
        messageView.addSubview(restartButton)
        view.addSubview(messageView)
        
        let padding: CGFloat = 32
        let topConstraint = gameView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: padding)
        topConstraint.priority = .defaultHigh
        let leftConstraint = gameView.leftAnchor.constraint(equalTo: liveViewSafeAreaGuide.leftAnchor, constant: padding)
        leftConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            gameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gameView.topAnchor.constraint(greaterThanOrEqualTo: liveViewSafeAreaGuide.topAnchor, constant: padding),
            gameView.leftAnchor.constraint(greaterThanOrEqualTo: liveViewSafeAreaGuide.leftAnchor, constant: padding),
            gameView.rightAnchor.constraint(lessThanOrEqualTo: liveViewSafeAreaGuide.rightAnchor, constant: -padding),
            gameView.bottomAnchor.constraint(lessThanOrEqualTo: liveViewSafeAreaGuide.bottomAnchor, constant: -padding),
            gameView.widthAnchor.constraint(equalTo: gameView.heightAnchor),
            topConstraint, leftConstraint,
            
            messageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: padding),
            messageLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: padding),
            messageLabel.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: -padding),
            restartButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            restartButton.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
            restartButton.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -padding)
        ])
        
        gameView.delegate = self
    }
    
    @objc func restart() {
        game = Game()
        playingAsWhite = !playingAsWhite
        if !playingAsWhite {
            autoMove()
        }
        gameView.reloadData()
        gameView.isUserInteractionEnabled = true
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: {
                self.messageView.alpha = 0
        }, completion: nil)
    }
    
    func ticTacToeView(_ ticTacToeView: TicTacToeView, stateForSquareAt coordinate: Int) -> SquareState {
        return game.board[coordinate]
    }
    
    func ticTacToeView(_ ticTacToeView: TicTacToeView, didMoveToCoordinate coordinate: Int) {
        guard state == .ongoing else {
            restart()
            return
        }
        
        do {
            try game.performMove(coordinate)
            gameView.reloadData()
            autoMove()
            checkGameState()
        } catch {
            print("Invalid move")
        }
    }
    
    func autoMove() {
        guard state == .ongoing else {
            return
        }
        
        let moves = game.calculateLegalMoves()
        let outputs = neuralNetwork.process(inputs: game.toInputs())
        let sortedOutputs = outputs.enumerated().sorted(by: { $0.element > $1.element })
        let maxLegalMove = sortedOutputs.first { (offset, _) in moves.contains(offset) }
        let move = maxLegalMove!.offset
        try! game.performMove(move)
        gameView.reloadData()
    }
    
    func checkGameState() {
        switch state {
        case .ongoing:
            return
        case .draw:
            showGameEndedMessage("Draw")
        case .won(let player):
            if player == .white && playingAsWhite || player == .black && !playingAsWhite {
                showGameEndedMessage("You won!")
            } else {
                showGameEndedMessage("You lost")
            }
        }
    }
    
    func showGameEndedMessage(_ message: String) {
        gameView.isUserInteractionEnabled = false
        messageLabel.text = message
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: {
                self.messageView.alpha = 1
        }, completion: nil)
    }
}

// Instantiate a new instance of the live view from the book's auxiliary sources and pass it to PlaygroundSupport.
PlaygroundPage.current.liveView = TicTacToeViewController()
