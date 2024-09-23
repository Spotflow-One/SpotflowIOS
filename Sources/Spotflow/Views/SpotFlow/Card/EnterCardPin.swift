//
//  EnterCardPin.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna
//

import SwiftUI

struct EnterCardPin: View {
    
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
    
    @State private var loading:Bool = false

    
    var body: some View {
        ScrollView {
            PaymentOptionTile(
                title: "Pay with Card", image: Image("pay-with-card-icon")
            ).padding([.leading,.bottom],19)
            PaymentCard()
            if loading {
                VStack {
                    ProgressView()
                        .padding(.top,50)
                    Spacer()
                }
            } else {
                Text("Please enter your 4-digit card pin to authorize this payment")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14,weight: .medium))
                    .foregroundStyle(Color(hex:"55515B"))
                    .padding([.top,.bottom],34)
                PinInputView(onComplete:onPinComplete)
                Button(action: {
                              print("Button tapped!")
                          }) {
                              Text("Cancel")
                                  .padding(18)
                                  .frame(maxWidth:.infinity)
                                  .font(.system(size: 14,weight: .medium))
                                  .foregroundStyle(Color(hex:"3D3844"))
                          }
                          .padding([.leading,.trailing],16)
                          .padding(.top,121)
            }
        
        }

    }
    
    func onPinComplete(pin:String) {
        Task {
            await submitPin(pin:pin)
        }
    }
    
    func submitPin(pin:String) async {
   
            let paymentService = PaymentService(authToken: paymentManager.key)
            let reference = spotflowUiState.paymentResponseBody?.reference
            let merchantId = paymentManager.merchantId
            
            if (reference == nil) {
                return
            }
            loading = true;
            let authorizeBody = AuthorizePaymentRequestBody( merchantId: merchantId, reference: reference!,pin: pin)
            let paymentResponseBody = await paymentService.authorizePayment(authorizePaymentRequestBody: authorizeBody)
                            if paymentResponseBody != nil {
                                spotflowVm.setPaymentResponseBody(paymentResponseBody: paymentResponseBody);
                                navigationVm.handleCardSuccessNavigation(paymentResponseBody: paymentResponseBody!)
                            }
       
        loading = false
   

    }
    
    
}

#Preview {
    EnterCardPin()
}
