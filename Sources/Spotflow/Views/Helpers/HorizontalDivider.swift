//
//  HorizontalDivider.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 28/07/2024.
//

import SwiftUI

struct HorizontalDivider: View {
    
    let color: Color
    let height: CGFloat
    
    init(color: Color, height: CGFloat = 0.5) {
        self.color = color
        self.height = height
    }
    
    var body: some View {
        color
            .frame(height: height)
    }
}

#Preview {
    HorizontalDivider(color: .green,height: 10)
}
