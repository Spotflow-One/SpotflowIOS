//
//  SwiftUIView.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 28/07/2024.
//

import SwiftUI

struct PaymentOptionTile: View {
    var title:String
    var image:Image
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack (alignment: VerticalAlignment.top){
            image.padding([.leading,.trailing],5)
            Text(title)
                .font(.system(size: 14,weight: .medium))
                .foregroundStyle(Color(hex: "3D3844")).padding(.top,4)
            Spacer()
        } .contentShape(Rectangle())
            .onTapGesture {
                onTap?()
            }
    }
}

#Preview {
    PaymentOptionTile(title: "Pay with Card",image: Image("pay-with-card-icon"))
}
