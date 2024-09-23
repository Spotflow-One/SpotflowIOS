//
//  TransferInfoView.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna
//

import SwiftUI

struct TransferInfoView: View {
    
    @State private var currentIndex = 0

    private let copyTexts = [
        "We’ll complete this transaction automatically once we confirm your transfer.",
        "If you have any issues with this transfer, please contact us via support@spotflow.com"
    ]
    
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
    
    var body: some View {
        ScrollView(content: {
            PaymentOptionTile(
                title: "Pay with Transfer",
                image: Image("pay-with-transfer-icon")
            ).padding([.leading,.bottom],19)
            PaymentCard()
            Spacer().frame(height: 70)
            
            Text(copyTexts[currentIndex])
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color(hex:"55515B"))
            
            Spacer().frame(height: 24)
            
            HStack(spacing: 8) {
                Indicator(index: 0, currentIndex: currentIndex)
                Indicator(index: 1, currentIndex: currentIndex)
            }
            Spacer().frame(height: 60)
            if currentIndex == 0 {
                Button(action: {
                    currentIndex = 1
                }) {
                    Text("Next")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "55515B"))
                        .padding(.vertical, 16.5)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(UIColor(red: 0.753, green: 0.710, blue: 0.811, alpha: 1)), lineWidth: 1)
                            
                        )
                }
                .padding(.horizontal, 60)
                .padding(.bottom,70)
            } else {
                VStack {
                    Button(action: {
                        // Navigate to home page
                    }) {
                        Text("Close Checkout")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.white)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex:"32BB78"))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 60)
                    Spacer().frame(height: 8)
                    Button(action: {
                        // Navigate to TransferStatusCheckPage
                        navigationVm.goToTransferStatusCheck()

                    }) {
                        Text("Keep waiting")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(hex:"55515B"))
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.clear)
                            )
                    }
                    .padding(.horizontal, 60)
                    .padding(.bottom,70)
                }
            }
            Spacer()
            HStack(spacing: 18) {
                ChangePaymentButton()
                CancelButton()
            }
            Spacer().frame(height: 64)
            PciDssIcon()
            Spacer()
            
        })
    }
}

#Preview {
    TransferInfoView()
}



struct Indicator: View {
    let index: Int
    let currentIndex: Int

    var body: some View {
        Circle()
            .fill(currentIndex == index ? Color(hex: "01008E") : Color.clear)
            .overlay(Circle().stroke(currentIndex == index ? Color.clear : Color(UIColor(red: 0.753, green: 0.710, blue: 0.811, alpha: 1)), lineWidth: 1))
            .frame(width: 12, height: 12)
    }
}





