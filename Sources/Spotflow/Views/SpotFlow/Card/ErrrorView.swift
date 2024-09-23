//
//  ErrrorView.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 06/08/2024.
//

import SwiftUI

struct ErrorPage: View {

    
    @EnvironmentObject  var spotflowVm: SpotflowViewModel
    @EnvironmentObject  var navigationVm: NavigationViewModel
    
    var spotflowUiState: SpotFlowUIState  {
         spotflowVm.spotflowUiState
    }
    
    var paymentManager: SpotFlowPaymentManager {
        spotflowUiState.paymentManager
    }
    
    var rate: Rate? {
        spotflowUiState.rate
    }
    
    var message: String {
        spotflowUiState.paymentResponseBody?.providerMessage ?? "Payment failed"
    }
    
    var paymentOptionsEnum:PaymentOptionsEnum {
        spotflowUiState.paymentOptionsEnum!
    }

    var tone70 = "55515B"
    
    var body: some View {
        VStack(alignment: .center) {
            PaymentOptionTile(
                title: paymentOptionsEnum.title,
                image: paymentOptionsEnum.icon
            )
            PaymentCard()
            Spacer().frame(height: 49)
            Image("error-icon") // Replace with actual image asset
            Spacer().frame(height: 6)
            Text(message)
                .multilineTextAlignment(.center)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex:tone70)) // Replace with actual color
            Spacer().frame(height: 60)
            Button(action: {
                navigationVm.goToEnterCardDetails()
                spotflowVm.setPaymentOptionsEnum(paymentOptionsEnum: PaymentOptionsEnum.card)

            }) {
                Text("Try again with your card")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex:tone70))
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }.padding(.horizontal,16)
            Button(action: {
                // Handle button action
                navigationVm.goToTransferHome()
                spotflowVm.setPaymentOptionsEnum(paymentOptionsEnum: PaymentOptionsEnum.transfer)

            }) {
                Text("Try again with transfer")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex:tone70))
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }.padding(.horizontal,16)
            Button(action: {
                // Handle button action
                spotflowVm.setPaymentOptionsEnum(paymentOptionsEnum: PaymentOptionsEnum.ussd)

            }) {
                Text("Try again with USSD")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: tone70))
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }.padding(.horizontal,16)
            Spacer()
            PciDssIcon()
            Spacer().frame(height: 32)
        }
        .background(Color.white)
 
    }
}





//struct ErrorPage_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorPage(
//            paymentManager: SpotFlowPaymentManager(),
//            message: "Error Message",
//            paymentOptionsEnum: PaymentOptionsEnum.card,
//            rate: nil
//        )
//    }
//}
