//
//  CancelButton.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 28/07/2024.
//

import SwiftUI

struct CancelButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            Text("x Cancel Payment")
                .tint(Color(hex:"55515B"))
                .font(.system(size: 12,weight: .medium))
                .padding([.top,.bottom],10)
                .padding([.leading,.trailing],16)
        }
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "E6E6E7"),lineWidth: 1))

    }
}

#Preview {
    CancelButton()
}
