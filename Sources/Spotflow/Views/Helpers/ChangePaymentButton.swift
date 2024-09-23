//
//  ChangePaymentButton.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 28/07/2024.
//

import SwiftUI

struct ChangePaymentButton: View {
    
    @EnvironmentObject  var navigationVm: NavigationViewModel

    var body: some View {
        Button(action: {
            navigationVm.goToHome()
        }) {
            Text("x Change Payment Method")
                .tint(Color(hex:"55515B"))
                .font(.system(size: 12,weight: .medium))
                .padding([.top,.bottom],10)
                .padding([.leading,.trailing],16)
        }
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "E6E6E7"),lineWidth: 1))

    }
}

#Preview {
    ChangePaymentButton()
}
