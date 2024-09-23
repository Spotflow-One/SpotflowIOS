
//  PaymentCard.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 28/07/2024.
//

import SwiftUI

struct PaymentCard: View {
 
    
    @EnvironmentObject  var spotflowVm: SpotflowViewModel
    
    var spotflowUiState: SpotFlowUIState {
        spotflowVm.spotflowUiState
    }
    
    var paymentManager: SpotFlowPaymentManager {
        spotflowUiState.paymentManager
    }
    
    var rate: Rate? {
        spotflowUiState.rate
    }
    
    var amount: Double {
        spotflowUiState.merchantConfig!.plan.amount
    }

    var numberFormatter: NumberFormatter {
       let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        return f
    }

    
    var body: some View {
        VStack {
            VStack(alignment: .trailing) {
                    
                        
        HStack {
            Text(paymentManager.customerEmail)
                        .font(.system(size: 14,weight: Font.Weight.regular)).tint(.white)
                        .foregroundStyle(.white)
                    Spacer()
            Text(paymentManager.paymentDescription ?? "")
                        .font(.system(size: 14,weight: Font.Weight.regular)).foregroundStyle(.white)
        }.padding(.top,48)
                
                HorizontalDivider(color: .white,height: 1.0).padding(.top,8)
                
                
                HStack(content: {
                   
                    if let rate  {
                        Text("\(rate.from) 1 = \(rate.to) \(numberFormatter.string(from: NSNumber(value:rate.rate)) ?? "\(rate.rate)")")
                            .foregroundStyle(.white).font(.system(size: 14,weight: .regular))
                        Image("info-icon")
                        Spacer()
                        Text("Pay").foregroundStyle(.white).font(.system(size: 14,weight: .regular))
                        if let formattedValue = numberFormatter.string(from: NSNumber(value:amount)) {
                            Text("\(rate.to) \(formattedValue)")
                                .foregroundStyle(.white)
                                .font(.system(size: 14,weight: .regular))// "1,234.57"
                        } else {
                            Text("\(rate.to) \(amount)")
                                .foregroundStyle(.white)
                                .font(.system(size: 14,weight: .regular))
                        }
                    }
                
    
                    
                }).padding(.top,16.0)
                    .padding(.bottom,6)
                
                if let rate {
                    let amount: Double = rate.rate * amount
                    let formattedAmount: String = numberFormatter.string(from: NSNumber(value:amount)) ?? String(amount)
                    HStack {
                        Text("\(rate.from) \(formattedAmount)")
                            .foregroundStyle(.white)
                        .font(.system(size: 12.0,weight: .regular)).padding(5)
                    }.background(Color(hex: "32BB78")).clipShape(RoundedRectangle(cornerRadius: 4.0))
                        .padding(.bottom,32)
                } else {
                    Spacer()
                        .frame(height: 50)
                }
                
                
            
            }.padding([.leading,.trailing],15)
        }.background(Color(hex: "01008E")).clipShape(RoundedRectangle(cornerRadius: 10)).padding([.leading,.trailing],14)

    }
}



