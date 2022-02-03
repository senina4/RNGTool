//
//  DiceMode.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/19/21.
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
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)){
            randomNumberStr = ""
            showDice = false
        }
        numOfDice = 1
        randomNumbers.removeAll()
        confirmReset = false
    }
    
    var body: some View {
        GeometryReader { geometry in
        ScrollView{
            Group {
                Text("Generate multiple numbers using dice")
                    .font(.title3)
                Divider()
                if(showDice && settingsData.allowDiceImages){
                    HStack(){
                        ForEach(0..<numOfDice, id: \.self) { index in
                          Image(diceImages[index])
                            .resizable()
                            .frame(width: (geometry.size.width / 6) - 10, height: (geometry.size.width / 6) - 10)
                        }
                    }
                }
                Text(randomNumberStr)
                    .padding(.bottom, 5)
                if(showDice){
                    Button(action:{
                        copyToClipboard(item: "\(randomNumbers)")
                    }) {
                        Image(systemName: "doc.on.doc.fill")
                    }
                    .font(.system(size: 12, weight:.bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(5)
                    .background(Color.accentColor)
                    .cornerRadius(20)
                    .padding(.bottom, 10)
                    Divider()
                }
            }
            Text("Number of dice")
                .font(.title3)
            // The seemingly unrelated code below is together because they must have the same max value
            Picker("Number of dice", selection: $numOfDice){
                ForEach(1...6, id: \.self) { index in
                    Text("\(index)").tag(index)
                }
            }
            .pickerStyle(.segmented)
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
                    withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)){
                        showDice = true
                    }
                    for n in 0..<randomNumbers.count{
                        if(numOfDice>n) {diceImages[n]="d\(randomNumbers[n])"}
                    }
                    if !(settingsData.historyTable.count > 49) {
                        settingsData.historyTable.append(HistoryTable(modeUsed: "Dice Mode", numbers: "\(randomNumbers)"))
                    }
                    else {
                        settingsData.historyTable.remove(at: 0)
                        settingsData.historyTable.append(HistoryTable(modeUsed: "Dice Mode", numbers: "\(randomNumbers)"))
                    }
                }) {
                    Image(systemName: "play.fill")
                }
                .font(.system(size: 20, weight:.bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(5)
                .background(Color.accentColor)
                .cornerRadius(20)
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
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(5)
                .background(Color.accentColor)
                .cornerRadius(20)
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
        }
        .padding(.horizontal, 3)
        .navigationTitle("Dice")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DiceMode_Previews: PreviewProvider {
    static var previews: some View {
        DiceMode().environmentObject(SettingsData())
    }
}
