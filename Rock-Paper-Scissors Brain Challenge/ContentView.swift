//
//  ContentView.swift
//  Rock-Paper-Scissors Brain Challenge
//
//  Created by Logan Toms on 11/17/23.
//

// Each turn of the game the app will randomly pick either rock, paper, or scissors.
// Each turn the app will alternate between prompting the player to win or lose.
// The player must then tap the correct move to win or lose the game.
// If they are correct they score a point; otherwise they lose a point.
// The game ends after 10 questions, at which point their score is shown.

import SwiftUI

struct ContentView: View {
    @State private var possibleMoves = ["rock", "paper", "scissors"]
    @State private var appsChoice: String = ""
    @State private var shouldWin: Bool = false
    @State private var playerScore: Int = 0
    @State private var showInstructions = false
    @State private var showGameOverAlert = false
    @State private var round: Int = 0
    
    var body: some View {
        VStack {
            Text("Round: \(round)")
                .font(.headline)
                .padding(.top, 20)

            Text("Select the correct choice to \(shouldWin ? "WIN" : "LOSE") the game!")
                .font(.title2)
                .padding(.vertical, 10)

            Text("App's Choice: \(appsChoice.capitalized)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.bottom, 20)

            VStack(spacing: 30) {
                ButtonView(choice: "rock", emoji: "🪨", action: check)
                ButtonView(choice: "paper", emoji: "📄", action: check)
                ButtonView(choice: "scissors", emoji: "✂️", action: check)
            }
            .padding(.horizontal)

            Spacer()

            Text("Player's Score: \(playerScore)")
                .font(.title3)
                .padding(.bottom, 20)
        }
        .padding()
        .onAppear(perform: newGame)
        .alert(isPresented: $showInstructions, content: instructionsAlert)
        .alert(isPresented: $showGameOverAlert, content: gameOverAlert)
    }

    
    func check(_ usersChoice: String) {
        // Checks for a correct choice and awards/deducts a point accordingly
        if isCorrectChoice(usersChoice) {
            playerScore += 1
        } else {
            // Only deduct a point if the score is greater than 0
            if playerScore > 0 {
                playerScore -= 1
            }
        }
        newMove()
    }
    
    func isCorrectChoice(_ usersChoice: String) -> Bool {
        // Implementing game logic for correct choice
        if shouldWin {
            return (appsChoice == "rock" && usersChoice == "paper") ||
                   (appsChoice == "paper" && usersChoice == "scissors") ||
                   (appsChoice == "scissors" && usersChoice == "rock")
        } else {
            return (appsChoice == "rock" && usersChoice == "scissors") ||
                   (appsChoice == "paper" && usersChoice == "rock") ||
                   (appsChoice == "scissors" && usersChoice == "paper")
        }
    }

    func newMove() {
        // Initiates a new round
        if round < 10 {
            round += 1
            appsChoice = getRandomMove() // Selects a choice for the app
            shouldWin.toggle() // Selects a game outcome
        } else {
            showGameOverAlert = true
        }
    }

    func getRandomMove() -> String {
        possibleMoves.randomElement() ?? "rock"
    }

    func newGame() {
        showInstructions = true
        playerScore = 0
        round = 0
        showGameOverAlert = false
        newMove()
    }

    func instructionsAlert() -> Alert {
        Alert(
            title: Text("Welcome!"),
            message: Text("Rock-Paper-Scissors brain challenge. Try to win or lose based on what the app chooses. Tap the correct move to score a point."),
            dismissButton: .default(Text("Got it!"))
        )
    }

    func gameOverAlert() -> Alert {
        Alert(
            title: Text("Game Over!"),
            message: Text("Your final score is \(playerScore)"),
            dismissButton: .default(Text("Play Again"), action: newGame)
        )
    }
}

struct ButtonView: View {
    let choice: String
    let emoji: String
    let action: (String) -> Void

    var body: some View {
        Button(action: { action(choice) }) {
            Text(emoji)
                .font(.system(size: 100))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
