//
//  HomeView.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 28/07/2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject  var spotflowVm: SpotflowViewModel
    
    @EnvironmentObject var navigationVm: NavigationViewModel

    
    @State private var loading: Bool = false;
    
    
    var spotflowUiState: SpotFlowUIState  {
         spotflowVm.spotflowUiState
    }
    
    var body: some View {
       
        VStack {
            if loading || spotflowUiState.merchantConfig == nil {
                 ProgressView()
            } else  {
                ScrollView{
                    VStack(alignment:.leading) {
                        PaymentCard()
                        Text("Use one of the payment methods below to pay \(spotflowVm.formattedAmount) to Spotflow")
                            .padding([.top,.bottom],27)
                            .font(.system(size: 12,weight: .regular))
                            .foregroundStyle(Color(hex: "9E9BA1"))
                            .padding([.leading,.trailing],12)
                        
                        Text("PAYMENT OPTIONS")
                            .padding(.top,33)
                            .font(.system(size: 16,weight: .medium))
                            .foregroundStyle(Color(hex: "6D6A73"))
                            .padding(.leading,41)
                        
                        HorizontalDivider(color: Color(hex: "E6E6E7"),height:0.5)
                            .padding(.top,10.5)
                            .padding([.leading,.trailing],17.0)
                        
                        VStack {
                            PaymentOptionTile(title: "Pay with Card",
                                              image: Image("pay-with-card-icon"),
                            onTap: {
                                spotflowVm.setPaymentOptionsEnum(paymentOptionsEnum: PaymentOptionsEnum.card )
                                navigationVm.goToEnterCardDetails()
                            })
                                .padding(.bottom,16)
                                .padding(.top,16)
                            
                            PaymentOptionTile(title: "Pay with Transfer",image: Image("pay-with-transfer-icon",bundle: Bundle.module),onTap: {
                                spotflowVm.setPaymentOptionsEnum(paymentOptionsEnum: PaymentOptionsEnum.transfer )

                                navigationVm.goToTransferHome()
                            })
                                .padding(.bottom,16)
                
                         
                            PaymentOptionTile(title: "Pay with USSD",image: Image("pay-with-ussd-icon"),onTap: {
                                
                                spotflowVm.setPaymentOptionsEnum(paymentOptionsEnum: PaymentOptionsEnum.ussd)
                                navigationVm.goToViewBanksUssdView()

                            })
                                .padding(.bottom,16)
                        }.padding(.leading,16)
                        
                        HStack{
                            Spacer()
                            CancelButton()
                            Spacer()
                        }.padding(.top,60)

                    }
                 
                }
            }
           
        }.task {
            if spotflowVm.spotflowUiState.merchantConfig == nil {
                await fetchMerchantConfig()
            }
         
        }
    }

    private func fetchMerchantConfig() async  {
        let paymentManager = spotflowUiState.paymentManager
        loading = true;
        let paymentService = PaymentService(authToken: paymentManager.key)
        let config = await paymentService
            .getMerchantConfig(planId: paymentManager.planId)
        spotflowVm.setMerchantConfig(merchantConfig: config)
        loading = false

        
    }
}

#Preview {
    HomeView()
}
