//
//  SpotflowUiState.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 18/08/2024.
//


import Foundation

struct SpotFlowUIState {
    let paymentManager: SpotFlowPaymentManager
    let paymentResponseBody: PaymentResponseBody?
    let merchantConfig: MerchantConfig?
    let paymentOptionsEnum: PaymentOptionsEnum?

    init(
         paymentManager: SpotFlowPaymentManager,
         paymentResponseBody: PaymentResponseBody? = nil,
         merchantConfig: MerchantConfig? = nil,
         paymentOptionsEnum: PaymentOptionsEnum? = nil
     ) {
         self.paymentManager = paymentManager
         self.paymentResponseBody = paymentResponseBody
         self.merchantConfig = merchantConfig
         self.paymentOptionsEnum = paymentOptionsEnum
     }
    
    var rate: Rate? {
        return merchantConfig?.rate
    }
    
    func copy(
          paymentManager: SpotFlowPaymentManager? = nil,
          paymentResponseBody: PaymentResponseBody? = nil,
          merchantConfig: MerchantConfig? = nil,
          paymentOptionsEnum: PaymentOptionsEnum? = nil
      ) -> SpotFlowUIState {
          return SpotFlowUIState(
              paymentManager: paymentManager ?? self.paymentManager,
              paymentResponseBody: paymentResponseBody ?? self.paymentResponseBody,
              merchantConfig: merchantConfig ?? self.merchantConfig,
              paymentOptionsEnum: paymentOptionsEnum ?? self.paymentOptionsEnum
          )
      }
    


}
