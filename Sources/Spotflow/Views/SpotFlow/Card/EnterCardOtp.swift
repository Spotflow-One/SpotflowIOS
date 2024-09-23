//
//  EnterCardOtp.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna
//

import SwiftUI

struct EnterCardOtp: View {
    @State private var otp:String = ""
    
    @EnvironmentObject  var spotflowVm: SpotflowViewModel
    @EnvironmentObject  var navigationVm: NavigationViewModel
    
    @State private var loading:Bool = false

    
    var spotflowUiState: SpotFlowUIState  {
         spotflowVm.spotflowUiState
    }
    
    var paymentManager: SpotFlowPaymentManager {
        spotflowUiState.paymentManager
    }
    
    var rate: Rate? {
        spotflowUiState.rate
    }
    
    var otpMessage: String {
        spotflowUiState.paymentResponseBody?.providerMessage ?? ""
    }
    
    @FocusState private var focused: Bool
        
    var body: some View {
        ScrollView(content: {
            VStack {
                PaymentOptionTile(
                    title: "Pay with Card", image: Image("pay-with-card-icon")
                ).padding([.leading,.bottom],19)
                PaymentCard()
                if loading {
                    VStack(content: {
                        ProgressView()
                            .padding(.top,50)
                        Spacer()
                    })
                } else {
                    Text(otpMessage)
                        .font(.system(size: 14,weight: .medium))
                        .foregroundStyle(Color(hex: "55515B"))
                        .padding(.top,57)
                        .padding(.bottom,54)
                    
                    TextField("",text: $otp)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.black)
                        .font(.system(size: 16,weight: .regular))
                        .foregroundStyle(Color(hex:"6D6A73"))
                        .keyboardType(.numbersAndPunctuation)
                        .frame(height: 56)
                        .focused($focused)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex:"CECDD0"),lineWidth:1))
                        .padding([.leading,.trailing],30)
                    
                    Button(action: {
                        Task {
                           await submitOtp()
                        }
                              }) {
                                  Text("Authorize")
                                      .padding(18)
                                      .frame(maxWidth:.infinity)
                                      .background(Color(hex:"32BB78"))
                                      .cornerRadius(8)
                                      .font(.system(size: 14,weight: .medium))
                                      .foregroundStyle(.white)
                              }
                              .disabled(otp.isEmpty)
                              .padding([.leading,.trailing],90)
                              .padding(.top,31)
                    
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
               
           
            
        })
    }
    
    
    func submitOtp() async {
   
            let paymentService = PaymentService(authToken: paymentManager.key)
            let reference = spotflowUiState.paymentResponseBody?.reference
            let merchantId = paymentManager.merchantId
        
            if (reference == nil) {
                return
            }
            loading = true;
            let requestBody = ValidatePaymentRequestBody( merchantId: merchantId, reference: reference!,otp: otp)
            let paymentResponseBody = await paymentService.validatePayment(validatePaymentRequstBody: requestBody)
                            if paymentResponseBody != nil {
                                spotflowVm.setPaymentResponseBody(paymentResponseBody: paymentResponseBody);
                                navigationVm.handleCardSuccessNavigation(paymentResponseBody: paymentResponseBody!)
                            }
       
        loading = false
   

    }
}

#Preview {
    return EnterCardOtp().environmentObject(SpotflowViewModel(paymentManager: examplePaymentManager))
        
}
