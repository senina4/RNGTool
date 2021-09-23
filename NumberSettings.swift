//
//  NumberSettings.swift
//  RNGTool
//
//  Created by Campbell Bagley on 9/23/21.
//

import SwiftUI

struct NumberSettings: View {
    @AppStorage("maxNumberDefault") private var maxNumberDefault = 100
    @AppStorage("minNumberDefault") private var minNumberDefault = 0
    @State private var maxNumberInput = ""
    @State private var minNumberInput = ""
    @State private var showInputError = false
    @State private var showResetPrompt = false
    
    var body: some View {
        Form {
            Text("Change Default Numbers")
                .font(.title2)
            Text("Default Maximum Number")
                .padding(.top, 10)
            TextField("Enter a number, current number: \(maxNumberDefault)", text: $maxNumberInput)
                .frame(width: 300)
            Text("Default Minimum Number")
                .padding(.top, 10)
            TextField("Enter a number, current number: \(minNumberDefault)", text: $minNumberInput)
                .frame(width: 300)
            HStack() {
                Button(action:{
                    showResetPrompt = true
                }) {
                    Text("Reset")
                }
                .sheet(isPresented: $showResetPrompt) {
                    VStack(alignment: .center) {
                        Image("sheeticon")
                            .resizable()
                            .frame(width: 72, height: 72)
                        Text("Confirm Reset")
                            .font(.title2)
                        Text("Are you sure you want to reset the minimum and maximum numbers to their defaults?")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 4)
                        Button(action:{
                            minNumberInput = ""
                            maxNumberInput = ""
                            maxNumberDefault = 100
                            minNumberDefault = 0
                            showResetPrompt = false
                        }) {
                            Text("Confirm")
                        }
                        .controlSize(.large)
                        Button(action:{
                            showResetPrompt = false
                        }) {
                            Text("Cancel")
                        }
                        .controlSize(.large)
                    }
                    .frame(width: 250, height: 275)
                }
                Button(action:{
                    if(maxNumberInput != "" && minNumberInput != ""){
                        maxNumberDefault = Int(maxNumberInput)!
                        minNumberDefault = Int(minNumberInput)!
                    }
                    else {
                        showInputError = true
                    }
                }) {
                    Text("Save")
                }
                .sheet(isPresented: $showInputError) {
                    VStack(alignment: .center) {
                        Image("sheeticon")
                            .resizable()
                            .frame(width: 72, height: 72)
                        Text("Missing numbers!")
                            .font(.title2)
                        Text("You must specify a minimum and maximum number!")
                            .multilineTextAlignment(.center)
                        Button(action:{
                            showInputError = false
                        }) {
                            Text("Ok")
                        }
                        .controlSize(.large)
                    }
                    .frame(width: 250, height: 200)
                }
            }
            .padding(.top, 5)
        }
        .padding(20)
        .frame(width: 350, height: 300)
    }
}

struct NumberSettings_Previews: PreviewProvider {
    static var previews: some View {
        NumberSettings()
    }
}
