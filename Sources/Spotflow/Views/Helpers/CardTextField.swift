//
//  CardTextField.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 29/07/2024.
//

import SwiftUI

struct CardTextField: View {
    @Binding var username:String
    var label:String
    var hintText:String
    
    var body: some View {
        VStack {
            VStack (alignment:.leading , content: {
                Text(label)
                    .foregroundStyle(Color(hex: "9E9BA1"))
                    .font(.system(size: 12,weight: .regular))
                TextField("",text: $username,prompt: Text(hintText)
                    .foregroundColor(Color(hex:"B6B4B9"))
                    .font(.system(size: 14,weight: .regular)))
                    .font(.system(size: 14,weight: .regular))
                    .foregroundStyle(Color(hex:"6D6A73"))
                    .keyboardType(.numbersAndPunctuation)
                    
            })
                .padding([.leading,.trailing], 16)
            .padding([.top,.bottom],4.5)
        }.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "E6E6E7"),lineWidth: 2))
            .padding([.leading,.trailing], 16)
    }
}

#Preview {
     return CardTextField(username: .constant(""),label: "Card number",hintText: "0000 0000 0000 0000")
}
