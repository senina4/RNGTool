//
//  MarbleMode.swift
//  RNGToolWrist WatchKit Extension
//
//  Created by Campbell on 1/31/22.
//

import SwiftUI

struct MarbleMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var numOfMarbles = 1
    @State private var randomNumbers = [0]
    @State private var randomLetters = [String]()
    @State private var showMarbles = false
    @State private var confirmReset = false
    @State private var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    func resetGen() {
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
            showMarbles = false
        }
        numOfMarbles = 1
        randomNumbers.removeAll()
        randomLetters.removeAll()
        confirmReset = false
    }
    
    var body: some View {
        GeometryReader { geometry in
        ScrollView {
            if(showMarbles){
                HStack(){
                    ForEach(0..<numOfMarbles, id: \.self) { index in
                        ZStack() {
                            Text("\(letters[randomNumbers[index]])")
                                .font(.title3)
                            Circle()
                                .stroke(Color.primary, lineWidth: 3)
                        }
                        .frame(width: (geometry.size.width / 5) - 10, height: (geometry.size.width / 5) - 10)
                    }
                }
                .padding(.top, 4)
            }
            HStack(alignment: .center) {
                Picker("", selection: $numOfMarbles){
                    ForEach(1...5, id: \.self) { index in
                        Text("\(index)").tag(index)
                    }
                }
                .frame(width: geometry.size.width / 4, height: geometry.size.height / 2.5)
                Text("Number of Marbles")
            }
            Button(action: {
                randomNumbers.removeAll()
                randomLetters.removeAll()
                for _ in 1...5{
                    randomNumbers.append(Int.random(in: 0...25))
                }
                for i in 0..<numOfMarbles {
                    randomLetters.append(letters[randomNumbers[i]])
                }
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)){
                    showMarbles = true
                }
            }) {
                Image(systemName: "play.fill")
            }
            .font(.system(size: 20, weight:.bold, design: .rounded))
            .foregroundColor(.primary)
            Button(action:{
                if(settingsData.confirmGenResets){
                    confirmReset = true
                }
                else {
                    resetGen()
                }
            }) {
                Image(systemName: "clear.fill")
            }
            .font(.system(size: 20, weight:.bold, design: .rounded))
            .foregroundColor(.red)
            .alert(isPresented: $confirmReset){
                Alert(
                    title: Text("Confirm Reset"),
                    message: Text("Are you sure you want to reset the generator? This cannot be undone."),
                    primaryButton: .default(Text("Confirm")){
                        resetGen()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        }
        .navigationTitle("Marbles")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MarbleMode_Previews: PreviewProvider {
    static var previews: some View {
        MarbleMode().environmentObject(SettingsData())
    }
}
