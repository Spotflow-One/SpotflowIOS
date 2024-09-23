//
//  PciDssIcon.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 30/07/2024.
//

import SwiftUI

struct PciDssIcon: View {
    var body: some View {
        HStack(spacing: 2) {
            Image("shield-icon") // Replace with your custom asset
            Text("PCI DSS Certified")
                .font(.system(size: 10))
                .foregroundColor(Color(hex:"9E9BA1"))
                .padding(.leading,2)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    PciDssIcon()
}
