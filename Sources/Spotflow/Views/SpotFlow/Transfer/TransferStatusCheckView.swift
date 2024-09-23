//
//  TransferStatusCheckView.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna
//

import SwiftUI
import Combine

struct TransferStatusCheckPage: View {
    @State private var currentIndex: Int = 0
    @State private var timerCancellable: Timer?
    @State private var countdownTimer: Timer?
    
    @State private var remainingTimeMillis: Int64  = 10 * 60 * 1000
    @State private var progress: CGFloat = 1.0
    @State private var timer: Timer?
    
    var timeString : String {
        let remainingSeconds = remainingTimeMillis / 1000
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        return timeString
    }
 
    
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
        ScrollView {
            VStack {
                    PaymentOptionTile(
                        title: "Pay with Transfer",
                        image: Image("pay-with-transfer-icon")
                    ).padding([.leading,.bottom],19)
                    PaymentCard()
                    Spacer().frame(height: 50)
                    Text("We’re waiting to confirm your transfer. This can take a few minutes")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .font(.system(size: 14,weight: .regular))
                        .foregroundStyle(Color(hex: "55515B"))
                    Spacer().frame(height: 30)
                    HStack(alignment: .center,spacing: 5) {
                            VStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color(hex:"32BB78"))
                                Spacer().frame(height: 3)
                                Text("Sent")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "9E9BA1"))
                            }
                            
                        IndeterminateProgressView()
                            .padding(.bottom,16)
                
                               
                            VStack {
                                Image(systemName: "circle.dotted")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color(hex:"B6B4B9"))
                                Spacer().frame(height: 3)
                                Text("Received")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex:"9E9BA1"))
                            }
                    }.padding(.horizontal,40)
                
                    Spacer().frame(height: 30)
                
                    Button(action: {}) {
                        Text("Please wait for \(timeString) minutes")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex:"55515B"))
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(UIColor(red: 0.753, green: 0.710, blue: 0.811, alpha: 1)), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 33)
                    Spacer().frame(height: 16)
                    Button(action: {
                        navigationVm.pop()
                        navigationVm.pop()
                    }) {
                        Text("Show account number")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex:"55515B"))
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(Color.clear)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 8)
                Spacer().frame(height: 50)
                    HStack(spacing: 18) {
                        ChangePaymentButton()
                        CancelButton()
                    }
                    Spacer().frame(height: 42)
                    PciDssIcon()
                    Spacer().frame(height: 64)
                }
            .onAppear {
                startCountdown()
                startPolling()
            }
            .onDisappear {
                timerCancellable?.invalidate()
                countdownTimer?.invalidate()
        }
        }
    }
    
    private func startCountdown()  {
        updateTimer()
//        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//         
//        }
    }
    
    func updateTimer() {
        if remainingTimeMillis > 0 {
            remainingTimeMillis = max(remainingTimeMillis - 1000, 0)
            progress = CGFloat(remainingTimeMillis) / CGFloat(30 * 60 * 1000)
        } else {
            stopTimer()
        }
    }
    
    func stopTimer() {
        countdownTimer?.invalidate()
    }
    
    
    private func startPolling() {
        Task{
            await verifyPayment()
        }
        timerCancellable = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            Task{
                await verifyPayment()
            }
        }
    }
    
    private func verifyPayment() async {
        let paymentService = PaymentService(authToken: paymentManager.key)
        if let paymentReference = spotflowUiState.paymentResponseBody?.reference {
            if let paymentResponse = await paymentService.verifyPayment(reference: paymentReference, merchantId: paymentManager.merchantId) {
                spotflowVm.setPaymentResponseBody(paymentResponseBody: paymentResponse)
                if(paymentResponse.status == "successful") {
                    navigationVm.goToSuccess()
                } else if(paymentResponse.status == "failed") {
                    navigationVm.goToError()
                }
            }
        }
       
    }
}








enum PaymentOptionsEnum {
    case transfer
    case ussd
    case card
    
    var title: String {
            switch self {
            case .transfer:
                return "Pay with Transfer"
            case .ussd:
                return "Pay with USSD"
            case .card:
                return "Pay with Card"
            }
        }

        var icon: Image {
            switch self {
            case .transfer:
                return Image("pay-with-transfer-icon")
            case .ussd:
                return Image("pay-with-ussd-icon")
            case .card:
                return Image("pay-with-card-icon")
            }
        }
}





#Preview {
    TransferStatusCheckPage()
}
