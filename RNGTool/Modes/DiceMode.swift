//
//  DiceMode.swift
//  RNGTool
//
//  Created by Campbell on 8/30/21.
//

import SwiftUI

struct DiceMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var numOfDice = 1
    @State private var confirmReset = false
    @State private var randomNumbers = [0]
    @State private var randomNumberStr = ""
    @State private var numsInArray = 0
    @State private var showDice = false
    @State private var removeCharacters: Set<Character> = ["[", "]"]
    @State private var diceImages = [String]()
    
    func resetGen() {
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
            randomNumberStr = ""
            showDice = false
        }
        numOfDice = 1
        randomNumbers.removeAll()
        confirmReset = false
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                Group {
                    Text("Generate multiple numbers using dice")
                        .font(.title3)
                    Divider()
                    if(showDice && settingsData.allowDiceImages){
                        HStack(){
                            ForEach(0..<numOfDice, id: \.self) { index in
                              Image(diceImages[index])
                                .resizable()
                                .frame(width: 64, height: 64)
                            }
                        }
                    }
                    Text(randomNumberStr)
                        .font(.title2)
                        .padding(.bottom, 5)
                    if(showDice){
                        Button(action:{
                            copyToClipboard(item: "\(randomNumbers)")
                        }) {
                            Image(systemName: "doc.on.doc.fill")
                        }
                        .padding(.bottom, 10)
                        Divider()
                    }
                }
                Text("Number of dice")
                    .font(.title3)
                // The seemingly unrelated code below is together because they must have the same max value
                Picker("", selection: $numOfDice){
                    ForEach(1...6, id: \.self) { index in
                        Text("\(index)").tag(index)
                    }
                }
                .frame(width: 250)
                .onAppear{
                    for _ in 1...6{
                        diceImages.append("d1")
                    }
                }
                Divider()
                HStack() {
                    Button(action: {
                        randomNumbers.removeAll()
                        for _ in 1...numOfDice{
                            randomNumbers.append(Int.random(in: 1...6))
                        }
                        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
                            self.randomNumberStr = "Your random number(s): \(randomNumbers)"
                            randomNumberStr.removeAll(where: { removeCharacters.contains($0) } )
                        }
                        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
                            showDice = true
                        }
                        for n in 0..<randomNumbers.count{
                            if(numOfDice>n) {diceImages[n]="d\(randomNumbers[n])"}
                        }
                        if(settingsData.historyTable.count != 50) {
                            self.settingsData.historyTable.append(HistoryTable(modeUsed: "Dice Mode", numbers: "\(randomNumbers)"))
                        }
                        else {
                            settingsData.historyTable.remove(at: 0)
                            self.settingsData.historyTable.append(HistoryTable(modeUsed: "Dice Mode", numbers: "\(randomNumbers)"))
                        }
                    }) {
                        Image(systemName: "play.fill")
                    }
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
                    .help("Reset custom values and output")
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
            .padding(.leading, 12)
        }
        .navigationTitle("Dice")
    }
}

struct DiceMode_Previews: PreviewProvider {
    static var previews: some View {
        DiceMode().environmentObject(SettingsData())
    }
}
