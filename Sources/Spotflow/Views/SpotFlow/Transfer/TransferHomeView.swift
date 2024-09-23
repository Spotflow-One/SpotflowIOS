//
//  TransferHomeView.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna
//

import SwiftUI

struct TransferHomeView: View {
    @EnvironmentObject  var spotflowVm: SpotflowViewModel
    @EnvironmentObject  var navigationVm: NavigationViewModel
    
    @State private var loading:Bool = false
    
  

    @State private var remainingTimeMillis: Int64  = 30 * 60 * 1000
    @State private var progress: CGFloat = 1.0
    @State private var timer: Timer?
    
    var timeString : String {
        let remainingSeconds = remainingTimeMillis / 1000
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        return timeString
    }
 


    
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
        VStack (alignment:.center) {
            PaymentOptionTile(
                title: "Pay with Transfer", 
                image: Image("pay-with-transfer-icon")
            ).padding([.leading,.bottom],19)
                .padding(.top,15)
        
            PaymentCard()
            
            if loading {
                VStack {
                    ProgressView()
                        .padding(.top,50)
                    Spacer()
                }
           
            } else if(spotflowVm.spotflowUiState.paymentResponseBody != nil) {
                Text("Transfer \(spotflowVm.formattedAmount) to the details below")
                    .font(.system(size: 16,weight: .medium))
                    .foregroundStyle(Color(hex:"55515B"))
                    .padding(.top,18)
                    .padding(.bottom,24)
                BankAccountCard()
                ZStack {
                    CircularProgressView(progress: progress)
                                    
                    VStack(content: {
                        Image("pay-with-transfer-icon")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(Color(hex: "32BB78"))
                            .frame(width: 15,height: 15)
                    })
                }.frame(width: 45,height: 45)
                    .padding(.top,10)
                
                HStack (spacing: 0) {
                    Text("Expires in ")
                        .font(.system(size: 10,weight: .regular))
                        .foregroundStyle(Color(hex: "#B6B4B9"))
                    Text(timeString)
                        .font(.system(size: 10,weight: .regular))
                        .foregroundStyle(Color(hex:"32BB78"))

                }.padding(.top,10)
                    .padding(.bottom,15)
                
                Button(action: {
                    navigationVm.goToTransferInfo()
                }) {
                    Text("I've sent the money")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex:"55515B"))
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(UIColor(red: 0.753, green: 0.710, blue: 0.811, alpha: 1)), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 30)
                HStack(spacing:12,content: {
                    CancelButton()
                    ChangePaymentButton()
                    
                }).padding(.top,24)
                    .padding(.bottom,50)
            }
        
         
            
         
        }.task {
                await createPayment()
        }
       
    }
    
    
    
    private func createPayment() async  {
        let paymentManager = spotflowUiState.paymentManager
        loading = true;
        let paymentService = PaymentService(authToken: paymentManager.key)
        let paymentRequestBody = PaymentRequestBody(customer: paymentManager.customer, currency: spotflowUiState.merchantConfig!.plan.currency, amount: spotflowUiState.merchantConfig!.plan.amount, channel: "bank_transfer")
        let paymentResponse = await paymentService
            .createPayment(paymentRequestBody: paymentRequestBody)
        startTimer()
        spotflowVm.setPaymentResponseBody(paymentResponseBody: paymentResponse)
        loading = false
        
    }
    
    func startTimer() {
        stopTimer() // Stop any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task {
                await updateTimer()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

   func updateTimer() {
        if remainingTimeMillis > 0 {
            remainingTimeMillis = max(remainingTimeMillis - 1000, 0)
            progress = CGFloat(remainingTimeMillis) / CGFloat(30 * 60 * 1000)
        } else {
            stopTimer()
        }
    }

}


#Preview {
    TransferHomeView().environmentObject(SpotflowViewModel(paymentManager: examplePaymentManager)).environmentObject(NavigationViewModel())
}


struct CircularProgressView: View {
  let progress: CGFloat

    let lineWidth = 4.0
  var body: some View {
    ZStack {
      // Background for the progress bar
      Circle()
        .stroke(lineWidth: lineWidth)
        .opacity(0.1)
        .foregroundColor(Color(hex: "01008E"))

      // Foreground or the actual progress bar
      Circle()
        .trim(from: 0.0, to: min(progress, 1.0))
        .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
        .foregroundColor(Color(hex: "01008E"))
        .rotationEffect(Angle(degrees: 270.0))
        .animation(.linear, value: progress)
    }
  }
}


