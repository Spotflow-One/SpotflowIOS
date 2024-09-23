//
//  SpotflowViewModel.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 19/08/2024.
//

import Foundation


class SpotflowViewModel: ObservableObject {
    
    @Published var spotflowUiState: SpotFlowUIState;
    
      init(paymentManager: SpotFlowPaymentManager) {
          spotflowUiState = SpotFlowUIState(paymentManager: paymentManager)
      }
    
    
    func setMerchantConfig(merchantConfig:MerchantConfig?) {
        spotflowUiState = spotflowUiState.copy(merchantConfig: merchantConfig)
    }
    
    func setPaymentResponseBody(paymentResponseBody:PaymentResponseBody?) {
        spotflowUiState = spotflowUiState.copy(paymentResponseBody: paymentResponseBody)
    }
    
    func setPaymentOptionsEnum(paymentOptionsEnum:PaymentOptionsEnum) {
        spotflowUiState = spotflowUiState.copy(paymentOptionsEnum: paymentOptionsEnum)
    }
    
    var formattedAmount: String {
        var numberFormatter: NumberFormatter {
           let f = NumberFormatter()
            f.numberStyle = .decimal
            f.maximumFractionDigits = 2
            f.minimumFractionDigits = 2
            return f
        }
        if(spotflowUiState.merchantConfig != nil) {
            let amount: Double = spotflowUiState.merchantConfig!.rate.rate * spotflowUiState.merchantConfig!.plan.amount
            let formattedAmount: String = numberFormatter.string(from: NSNumber(value:amount)) ?? String(amount)
            return "\(spotflowUiState.merchantConfig!.rate.from) \(formattedAmount)"
        }
        return ""
    }
}
