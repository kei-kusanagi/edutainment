//
//  ContentView.swift
//  edutainment
//
//  Created by Juan Carlos Robledo Morales on 13/09/24.
//

import SwiftUI

struct ContentView: View {
    @State private var gameIsActive = false
    @State private var questions: [Question] = []
    @State private var selectedNumberOfQuestions = 5

    var body: some View {
        if gameIsActive {
            GameView(questions: questions, onGameEnd: {
                gameIsActive = false
            })
        } else {
            SettingsView(selectedNumberOfQuestions: $selectedNumberOfQuestions) {
                startGame()
            }
        }
    }
    
    func startGame() {
        var newQuestions = [Question]()
        
        for _ in 1...selectedNumberOfQuestions {
            let multiplicand = Int.random(in: 2...12)
            let multiplier = Int.random(in: 2...12)
            let text = "¿Cuánto es \(multiplicand) x \(multiplier)?"
            let answer = multiplicand * multiplier
            newQuestions.append(Question(text: text, answer: answer))
        }
        
        questions = newQuestions
        gameIsActive = true
    }
}



struct SettingsView: View {
    @Binding var selectedNumberOfQuestions: Int
    @State private var animateGradient = false
    let startGame: () -> Void

    var body: some View {
        VStack{
            Spacer()
            Text("Edutainment")
                .font(.system(size: 55, weight: .heavy))
                            .overlay(
                                LinearGradient(gradient:
                                                Gradient(colors: [
                                                    .blue,
                                                    .green,
                                                    .green,
                                                    .red,
                                      ]),
                                               startPoint: animateGradient ? .topLeading : .bottomTrailing,
                                               endPoint: animateGradient ? .topTrailing : .bottomLeading)
                                    .mask(
                                        Text("Edutainment")
                                            .font(.system(size: 55, weight: .heavy))
                                    )
                            )
                            .frame(height: 200)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 2).repeatForever()) {
                                    animateGradient=true
                                }
                            }

            Section(header: Text("Número de Preguntas")) {
                Picker("Preguntas", selection: $selectedNumberOfQuestions) {
                    Text("5").tag(5)
                    Text("10").tag(10)
                    Text("20").tag(20)
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(colorForSelection())
                            .cornerRadius(5)
            }.padding(5)
            Spacer()
            
            Button("Comenzar Juego") {
                startGame()
            }
            .padding()
            .frame(width: 200, height: 50)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 50)
            
            Spacer()
        }.navigationBarTitle("Ajustes del Juego")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGray6))
            .edgesIgnoringSafeArea(.all)
    }
        
    func colorForSelection() -> Color {
        let colorMap: [Int: Color] = [5: .green, 10: .yellow, 20: .red]
        return colorMap[selectedNumberOfQuestions] ?? .gray
    }

    }




struct GameView: View {
    let questions: [Question]
    var onGameEnd: () -> Void
    
    @State private var currentQuestionIndex = 0
    @State private var userAnswer = ""
    @State private var score = 0
    @State private var gameOver = false
    @State private var answerWasCorrect: Bool? = nil
    
    var body: some View {
        VStack {
            if gameOver {
                Text("¡Juego Terminado!")
                    .font(.largeTitle)
                Text("Tu puntuación: \(score)/\(questions.count)")
                Button("Volver a la pantalla principal") {
                    onGameEnd()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            } else {
                Text(questions[currentQuestionIndex].text)
                    .font(.title)
                    .padding()
                
                TextField("Respuesta", text: $userAnswer)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Enviar respuesta") {
                    checkAnswer()
                }
                .padding()
                .background(answerWasCorrect == true ? Color.green : answerWasCorrect == false ? Color.red : Color.blue)
                .animation(.easeInOut, value: answerWasCorrect)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
    
    func checkAnswer() {
        if let userAnswerInt = Int(userAnswer), userAnswerInt == questions[currentQuestionIndex].answer {
            score += 1
            answerWasCorrect = true
        } else {
            answerWasCorrect = false
        }
        
         userAnswer = ""
        
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if currentQuestionIndex < questions.count - 1 {
                currentQuestionIndex += 1
                answerWasCorrect = nil
            } else {
                gameOver = true
            }
        }
    }
}

    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Question {
    let text: String
    let answer: Int
}


#Preview {
    ContentView()
}
