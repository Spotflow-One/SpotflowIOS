//
//  EnterCardDetail.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna
//

import SwiftUI
import Foundation
import CryptoKit
import Security


struct EnterCardDetail: View {
    @State private var cardNumber: String = ""
    @State private var cardExpiry: String = ""
    @State private var cardCvv: String = ""
    
    @State private var loading:Bool = false
    
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
    
    var amount: Double? {
        spotflowUiState.merchantConfig?.plan.amount
    }
    
    var currency: String? {
        spotflowUiState.merchantConfig?.plan.currency
    }
        
    
    var buttonEnabled: Bool {
        cardCvv.isEmpty == false && cardExpiry.isEmpty == false && cardNumber.isEmpty == false
    }
    
    var body: some View {
      
        ScrollView(content: {
            PaymentOptionTile(
                title: "Pay with Card", image: Image("pay-with-card-icon")
            ).padding([.leading,.bottom],19)
            PaymentCard()
            if loading {
                ProgressView()
                    .padding(.top,50)
            } else {
                Text("Enter you card details to pay")
                    .font(.system(size: 16,weight: .medium))
                    .foregroundStyle(Color(hex:"55515B"))
                    .padding(.top,34)
                    .padding(.bottom,24)
                
                CardTextField(
                    username: $cardNumber,
                    label: "CARD NUMBER",
                    hintText: "0000 0000 0000 0000"
                )
                
                HStack(spacing: -12, content: {
                    CardTextField(
                        username: $cardExpiry,
                        label: "CARD EXPIRY",
                        hintText: "MM/YY"
                    )
                    CardTextField(
                        username: $cardCvv,
                        label: "CVV",
                        hintText: "123"
                    )
                }).padding(.top,14)
                
                
                Button(action: {
                    Task {
                        await submitCardDetails()
                    }
                          }) {
                              Text("Pay \(spotflowVm.formattedAmount)")
                                  .padding()
                                  .frame(maxWidth:.infinity)
                                  .background(!buttonEnabled ? Color(hex:"F4F4FF") : Color(hex: "01008E"))
                                  .foregroundStyle(!buttonEnabled ? Color(hex:"AAAAD9") : .white)
                                  .cornerRadius(4)
                                  .font(.system(size: 14,weight: .medium))
                          }
                          .disabled(cardNumber.isEmpty)
                          .padding()
                
                HStack(spacing:12,content: {
                    CancelButton()
                    ChangePaymentButton()
                    
                })
                .padding([.leading,.trailing],16)
                .padding(.top,60)
            }
           
                
                
        })

    }
    
    
    func submitCardDetails() async {
        
        if(amount == nil || currency == nil) {
            return
        }
        loading = true;
        
        do {
            if let expiryDate = extractExpiryDate(from: cardExpiry) {
                let paymentService = PaymentService(authToken: paymentManager.key)
                let card = SpotFlowCard(
                    pan: cardNumber,
                    cvv: cardCvv,
                    expiryYear: expiryDate.year,
                    expiryMonth: expiryDate.month
                )
                let encryptedCard = try encrypt(card: card, base64Key: paymentManager.encryptionKey)
                let paymentRequest = PaymentRequestBody(customer: paymentManager.customer,
                    encryptedCard: encryptedCard,
                    currency: currency!,
                    amount: amount!,
                    channel: "card"
                )
                let paymentResponseBody = await paymentService
                    .createPayment(paymentRequestBody: paymentRequest)
                
                if paymentResponseBody != nil {
                    spotflowVm.setPaymentResponseBody(paymentResponseBody: paymentResponseBody);
                    navigationVm.handleCardSuccessNavigation(paymentResponseBody: paymentResponseBody!)
                }
                loading = false
            } else {
                print("Invalid date format")
            }
        } catch {
            print("Failed")
        }
      
        
       
    }
    
    func extractExpiryDate(from dateString: String) -> (month: String, year: String)? {
        let components = dateString.split(separator: "/")
        guard components.count == 2 else {
            return nil
        }

        let month = String(components[0])
        let year = String(components[1])

        return (month, year)
    }
    
    


     
        func encrypt(card: SpotFlowCard, base64Key: String) throws -> String {
            // Decode the Base64 key into Data (must be 32 bytes for AES-256)
            let json = try JSONEncoder().encode(card)
            let plainText = String(data:json,encoding: .utf8)!
            guard let keyData = Data(base64Encoded: base64Key), keyData.count == 32 else {
                throw NSError(domain: "EncryptionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Base64 Key"])
            }

            // Convert plainText to Data
            guard let plainTextData = plainText.data(using: .utf8) else {
                throw NSError(domain: "EncryptionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode plain text"])
            }

            // Generate a symmetric key from the decoded Base64 key
            let symmetricKey = SymmetricKey(data: keyData)

            // Encrypt the data using AES-GCM
            let sealedBox = try AES.GCM.seal(plainTextData, using: symmetricKey)

            // Combine the IV, ciphertext, and tag into a single Data object
            let combinedData = sealedBox.nonce + sealedBox.ciphertext + sealedBox.tag

            // Return the Base64 encoded string of the combined data
            return combinedData.base64EncodedString()
        }

}

#Preview {
    EnterCardDetail()
}
