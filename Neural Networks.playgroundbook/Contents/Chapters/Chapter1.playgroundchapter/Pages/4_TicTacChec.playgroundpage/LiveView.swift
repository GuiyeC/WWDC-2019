//
//  LiveView.swift
//
//  Created by Guillermo Cique on 23/03/2019.
//

import UIKit
import PlaygroundSupport


struct PieceInfo {
    let piece: Piece
    let name: String
    let info: String
}

class PieceInfoView: UIView {
    
    let info: PieceInfo
    
    init(info: PieceInfo, frame: CGRect = .zero) {
        self.info = info
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didLoad() {
        setContentCompressionResistancePriority(.required, for: .vertical)
        let squareView = SquareView()
        squareView.translatesAutoresizingMaskIntoConstraints = false
        squareView.path = info.piece.path
        squareView.tintColor = GameView.Constants.playerColor
        let titleLabel = UILabel()
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .defaultTintColor
        titleLabel.text = info.name
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textColor = .defaultTintColor
        infoLabel.text = info.info
        infoLabel.font = UIFont.preferredFont(forTextStyle: .body)
        infoLabel.numberOfLines = 0
        infoLabel.adjustsFontSizeToFitWidth = true
        
        addSubview(squareView)
        addSubview(titleLabel)
        addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            squareView.widthAnchor.constraint(equalTo: squareView.heightAnchor),
            squareView.topAnchor.constraint(equalTo: topAnchor),
            squareView.leftAnchor.constraint(equalTo: leftAnchor),
            squareView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: squareView.rightAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            infoLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            infoLabel.rightAnchor.constraint(equalTo: rightAnchor),
            infoLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
        ])
    }
}

class TicTacChecViewController: UIViewController, TicTacChecViewDelegate, PlaygroundLiveViewSafeAreaContainer {
    let gameView = TicTacChecView()
    var game = Game()
    var state: GameState {
        return game.state
    }
    let neuralNetwork: NeuralNetwork = {
        guard let fileUrl = Bundle.main.path(forResource: "llc0_64x3_3", ofType: nil),
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
    let piecesInfoView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            PieceInfoView(info: PieceInfo(piece: .pawn, name: "Pawn", info: "Moves 1 space forward per turn except when it captures an opponent's piece by moving one space diagonally forward. Changes direction when reaching the end of the board.")),
            PieceInfoView(info: PieceInfo(piece: .knight, name: "Knight", info: "Moves forming an L, either 1 space forward or backward and 2 spaces either left or right or 2 spaces forward or backward and 1 space either left or right. A Knight is the only piece that can move over another piece on the board.")),
            PieceInfoView(info: PieceInfo(piece: .rook, name: "Rook", info: "Moves vertically or horizontally as long as it does not pass another piece.")),
            PieceInfoView(info: PieceInfo(piece: .bishop, name: "Bishop", info: "Moves diagonally any number of spaces as long as it does not pass another piece."))
        ])
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    var infoView: UIView! = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor.defaultBackgroundColor.withAlphaComponent(0.9)
        return view
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
        
        
        let startButton = Button()
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.titleLabel.text = "Start"
        startButton.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        infoView.addSubview(piecesInfoView)
        infoView.addSubview(startButton)
        view.addSubview(infoView)
        
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
            gameView.bottomAnchor.constraint(lessThanOrEqualTo: liveViewSafeAreaGuide.bottomAnchor, constant: -padding),
            gameView.rightAnchor.constraint(lessThanOrEqualTo: liveViewSafeAreaGuide.rightAnchor, constant: -padding),
            topConstraint, leftConstraint,
            
            messageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: padding),
            messageLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: padding),
            messageLabel.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: -padding),
            restartButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            restartButton.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
            restartButton.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -padding),
            
            
            piecesInfoView.topAnchor.constraint(equalTo: infoView.topAnchor, constant: padding),
            piecesInfoView.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: padding),
            piecesInfoView.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -padding),
            startButton.topAnchor.constraint(equalTo: piecesInfoView.bottomAnchor, constant: 24),
            startButton.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -padding),
            infoView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: padding),
            infoView.leftAnchor.constraint(equalTo: liveViewSafeAreaGuide.leftAnchor, constant: padding),
            infoView.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor, constant: -padding),
            infoView.rightAnchor.constraint(equalTo: liveViewSafeAreaGuide.rightAnchor, constant: -padding)
        ])
        
        gameView.delegate = self
    }
    
    @objc func startAction() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: {
                self.infoView?.alpha = 0
        }, completion: { _ in
            self.infoView?.removeFromSuperview()
            self.infoView = nil
        })
    }
    
    @objc func restart() {
        game = Game()
        playingAsWhite = !playingAsWhite
        if !playingAsWhite {
            autoMove()
            gameView.viewPlayer = .black
        } else {
            gameView.viewPlayer = .white
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
    
    func ticTacChecView(_ ticTacChecView: TicTacChecView, stateForSquareAt coordinate: Int) -> SquareState {
        return game.board[coordinate]
    }
    
    func ticTacChecView(_ ticTacChecView: TicTacChecView, pawnDirectionForPlayer player: Player) -> Direction? {
        switch player {
        case .white:
            return game.whitePawnDirection
        case .black:
            return game.blackPawnDirection
        }
    }
    
    func ticTacChecView(_ ticTacChecView: TicTacChecView, pocketPiecesForPlayer player: Player) -> Set<Piece> {
        switch player {
        case .white:
            return Set(Piece.allCases.filter({ game.board.whitePieces[$0] == nil }))
        case .black:
            return Set(Piece.allCases.filter({ game.board.blackPieces[$0] == nil }))
        }
    }
    
    func lastMoveForTicTacChecView(_ ticTacChecView: TicTacChecView) -> (from: Coordinate?, to: Coordinate?) {
        guard let lastMove = game.history.first else {
            return (nil, nil)
        }
        return (from: lastMove.previousCoordinate, to: lastMove.move.coordinate)
    }
    
    func currentPlayerForTicTacChecView(_ ticTacChecView: TicTacChecView) -> Player {
        return game.turn
    }
    
    func ticTacChecView(_ ticTacChecView: TicTacChecView, legalMovesForPiece piece: Piece) -> [Coordinate] {
        return game.calculateLegalMoves().filter({ $0.piece == piece }).map({ $0.coordinate })
    }
    
    func ticTacChecView(_ ticTacChecView: TicTacChecView, didMovePiece piece: Piece, toCoordinate coordinate: Int) {
        guard state == .ongoing else {
            restart()
            return
        }
        
        do {
            let move = Move(piece: piece, coordinate: coordinate)
            try game.performMove(move)
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
        let maxLegalMove = sortedOutputs.first { (offset, _) -> Bool in
            let piece = offset / 16
            let cell = offset - piece * 16
            return moves.contains(Move(piece: Piece(rawValue: piece)!, coordinate: cell))
        }
        let piece = Piece(rawValue: maxLegalMove!.offset / 16)!
        let cell = maxLegalMove!.offset - piece.rawValue * 16
        let move = Move(piece: piece, coordinate: cell)
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
PlaygroundPage.current.liveView = TicTacChecViewController()
