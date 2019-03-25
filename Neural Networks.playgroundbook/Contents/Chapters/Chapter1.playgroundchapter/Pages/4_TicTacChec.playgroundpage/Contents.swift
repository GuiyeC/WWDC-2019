//#-hidden-code
//
//  Contents.swift
//
//  Created by Guillermo Cique on 23/03/2019.
//
//#-end-hidden-code
/*:
 We've seen how to make a neural network, how to calculate outputs from inputs and how to improve those outputs by calibrating the neural network.
 
 We've also played Tic Tac Toe against a neural network and even trained a really simple one on the spot.
 
 Now let's play a more complex game: **Tic Tac Chec**.
 
 This game is a mix between **Chess** and **Tic Tac Toe**, the aim of the game is to align your 4 pieces horizontally, vertically or diagonally.
 
 Play starts on an empty board, players take turns placing a piece on **any** empty square. After placing your first 3 pieces you may move and capture as in regular chess, except a pawn reverses direction upon reaching the opposite side of the board. Capture pieces are returned to their owner and can immediately be played again on any open square.
 
 As you can see this is a **far more complex** game than Tic Tac Toe, and as such this neural network is far from perfect. As stated before training a neural network can be more art than science and it can take lots and lots of time to get right. Try playing some quick games and you will be able to see that the neural network can sometimes play the very best move and right after shoot itself on the foot.
 */

/*:
 This network has 3 layers, one input layer of 118 neurons and two hidden layers of 90 and 64 neurons each.
 
 It takes 146 inputs, 9 per square, having the first input active (a value of 1) when the square is empty, the others will activate depending on the piece and owner occupiying the square. Only one will be active at a time, the rest will have a value of 0. There are two other inputs, one per each player, indicating the direction of their pawn, -1 when it's going down, 0 when it's not on the board and 1 when it's going up.
 
 In the end it produces 64 outputs, 64 values between 0 and 1, the index of the max value is taken and it's considered the move the neural network wants to make, being the outputs all the possible moves at any time, one per piece and square.
 */
//#-hidden-code
//#-editable-code
//#-end-editable-code
//#-end-hidden-code
