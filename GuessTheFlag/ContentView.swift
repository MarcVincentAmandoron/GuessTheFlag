//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Marc Vincent on 11/11/23.
//

import SwiftUI


struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var userScore = 0
    @State private var userChoice = 0
    @State private var numAttempts = 0
    @State private var gameOver = false
    @State private var showingScore = false
    @State private var scoreTitle = ""
    var gameOverTitle = "GAME OVER"
    
    var body: some View {
        ZStack {
            //LinearGradient(colors: [.purple, .blue], startPoint: .top, endPoint: .bottom)
            RadialGradient(stops: [
                .init(color: Color(red: 0.3, green: 0.2, blue: 0.9), location: 0.9),
                .init(color: Color(red: 0.3, green: 0.8, blue: 0.8), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.black.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.black)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button{
                            flagTapped(number)
                            userChoice = number
                        } label: {
                            FlagImage(flag: countries[number])
                        }
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 30)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()

                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
            }
        }
        .alert(gameOverTitle, isPresented: $gameOver) {
            Button("New Game", action: resetGame)
        } message: {
            Text("You got \(userScore)/8 flags Correct.")
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if(scoreTitle == "Correct"){
                Text("Gain 1 point")
            } else {
                Text("Wrong! That's the flag of \(countries[userChoice])")
            }
            
        }

    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore+=1
        } else {
            scoreTitle = "Wrong"
        }
        
        numAttempts+=1
        if(numAttempts == 8){
            gameOver = true
            showingScore = false
        } else {
            showingScore = true
            gameOver = false
        }

    }
    
    func resetGame() {
        userScore = 0
        numAttempts = 0
        askQuestion()
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct FlagImage: View {
    var flag: String
    
    var body: some View {
        Image(flag)
            .clipShape(.rect(cornerRadius: 15))
            .shadow(radius: 10)
    }
}

#Preview {
    ContentView()
}
