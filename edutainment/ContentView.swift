//
//  ContentView.swift
//  edutainment
//
//  Created by Juan Carlos Robledo Morales on 13/09/24.
//

import SwiftUI

struct ContentView: View {
    // con esto vemos si estamos jugando o estamos escogiendo el tipo de jeugo
    @State private var gameActive = false
    
    var body: some View {
        VStack {
            if gameActive {
                GameView()
            } else {
                SettingsView(startGame: startGame)
            }
        }
    }
    
    // Cone sta cosa iniciaremos el juego
    func startGame() {
        gameActive = true
    }
}

struct SettingsView: View {

    @State private var selectedTable = 2
    @State private var numberOfQuestions = 5

    let startGame: () -> Void

    var body: some View {
        VStack {
            Text("Selecciona tus opciones")
                .font(.largeTitle)
                .padding()

            Stepper("Tablas hasta: \(selectedTable)", value: $selectedTable, in: 2...12)
                .padding()

            Picker("Número de preguntas", selection: $numberOfQuestions) {
                Text("5 preguntas").tag(5)
                Text("10 preguntas").tag(10)
                Text("20 preguntas").tag(20)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button("Iniciar Juego") {
                startGame()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

struct GameView: View {
    var body: some View {
        Text("Aquí es donde irán las preguntas del juego.")
            .font(.largeTitle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
// los view son como la classes stateleswidget de flutter para crear otras paginas y acceder a ellas
