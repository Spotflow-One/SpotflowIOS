//
//  BankAccountCard.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 29/07/2024.
//

import SwiftUI

struct BankAccountCard: View {
    
    @EnvironmentObject var spotflowVm: SpotflowViewModel

    var bank: BankDetails {
        spotflowVm.spotflowUiState.paymentResponseBody!.bankDetails!;
    }
    var body: some View {
        VStack(content: {
            HStack(content: {
                VStack(alignment:.leading, content: {
                    Text("BANK NAME")
                        .font(.system(size: 10,weight: .regular))
                        .foregroundStyle(Color(hex: "6D6A73"))
                        .padding(.bottom,0.2)
                    
                    Text(bank.name)
                        .font(.system(size: 14,weight: .regular))
                        .foregroundStyle(Color(hex: "3D3844"))
                })
                Spacer()

            })
            .padding(.bottom,16)
            
            HStack(content: {
                VStack(alignment:.leading, content: {
                    Text("ACCOUNT NUMBER")
                        .font(.system(size: 10,weight: .regular))
                        .foregroundStyle(Color(hex: "6D6A73"))
                        .padding(.bottom,0.2)
                    
                    Text(bank.accountNumber)
                        .font(.system(size: 14,weight: .regular))
                        .foregroundStyle(Color(hex: "3D3844"))
                })
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image("copy-icon").frame(width: 15,height: 15)
                })
            })
            .padding(.bottom,16)
            
            HStack(content: {
                VStack(alignment:.leading, content: {
                    Text("AMOUNT")
                        .font(.system(size: 10,weight: .regular))
                        .foregroundStyle(Color(hex: "6D6A73"))
                        .padding(.bottom,0.2)
                    
                    Text(spotflowVm.formattedAmount)
                        .font(.system(size: 14,weight: .regular))
                        .foregroundStyle(Color(hex: "3D3844"))
                })
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image("copy-icon").frame(width: 15,height: 15)                    })
            })
            
        })
        .padding([.leading,.trailing],25)
        .padding([.top,.bottom],27)
        .background(Color(hex:"F4F4FF"))
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.leading,11)
        .padding(.trailing,23)
    }
}

