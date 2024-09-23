//
//  PaymentService.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 30/07/2024.
//


import Foundation
import SwiftUI

class PaymentService {
    private var apiClient: ApiClient
    
    private let baseUrl: String = "https://dev-api.spotflow.one"
    
    init(authToken: String) {
        self.apiClient = ApiClient(authToken: authToken)
    }
    
    
    func createPayment(paymentRequestBody: PaymentRequestBody) async -> PaymentResponseBody? {
        do  {
            let (data, response) = try await apiClient.post("\(baseUrl)/api/v1/payments",data: paymentRequestBody)
        
            print(response)
            if let responseString = String(data: data, encoding: .utf8) {
                      print("Response Data: \(responseString)")
                  } else {
                      print("Failed to get response data")
                  }
    
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return nil
            }
            let decoder = JSONDecoder()
            return try decoder.decode(PaymentResponseBody.self, from: data)

        } catch let error as DecodingError {
            switch error {
            case .dataCorrupted(let context):
                print("Data corrupted:", context.debugDescription)
                print("Coding Path:", context.codingPath)

            case .keyNotFound(let key, let context):
                print("Key '\(key)' not found:", context.debugDescription)
                print("Coding Path:", context.codingPath)

            case .typeMismatch(let type, let context):
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("Coding Path:", context.codingPath)

            case .valueNotFound(let value, let context):
                print("Value '\(value)' not found:", context.debugDescription)
                print("Coding Path:", context.codingPath)

            @unknown default:
                print("Unknown decoding error")
            }
        
        } catch {
            print("Other error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func authorizePayment(authorizePaymentRequestBody: AuthorizePaymentRequestBody) async -> PaymentResponseBody? {
        
        do  {
            let (data, response) = try await apiClient.post("\(baseUrl)/api/v1/payments/authorize",data: authorizePaymentRequestBody)
         
            print(response)
            if let responseString = String(data: data, encoding: .utf8) {
                      print("Response Data: \(responseString)")
                  } else {
                      print("Failed to get response data")
                  }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return nil
            }
            let decoder = JSONDecoder()
            return try decoder.decode(PaymentResponseBody.self, from: data)

        } catch let error as DecodingError {
            switch error {
            case .dataCorrupted(let context):
                print("Data corrupted:", context.debugDescription)
                print("Coding Path:", context.codingPath)

            case .keyNotFound(let key, let context):
                print("Key '\(key)' not found:", context.debugDescription)
                print("Coding Path:", context.codingPath)

            case .typeMismatch(let type, let context):
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("Coding Path:", context.codingPath)

            case .valueNotFound(let value, let context):
                print("Value '\(value)' not found:", context.debugDescription)
                print("Coding Path:", context.codingPath)

            @unknown default:
                print("Unknown decoding error")
            }
        
        } catch {
            print("Other error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func validatePayment(validatePaymentRequstBody: ValidatePaymentRequestBody) async -> PaymentResponseBody? {
        do  {
            let (data, response) = try await apiClient.post("\(baseUrl)/api/v1/payments/authorize",data: validatePaymentRequstBody)
         
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return nil
            }
            let decoder = JSONDecoder()
            return try decoder.decode(PaymentResponseBody.self, from: data)

        } catch {
            return nil
        }
    }
    
    func verifyPayment(reference: String, merchantId: String) async -> PaymentResponseBody? {
        do  {
            let (data, response) = try await apiClient.get("\(baseUrl)/api/v1/payments/verify", queryParameters: ["reference": reference, "merchantId": merchantId])
         
            print(response)
            if let responseString = String(data: data, encoding: .utf8) {
                      print("Response Data: \(responseString)")
                  } else {
                      print("Failed to get response data")
                  }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return nil
            }
            let decoder = JSONDecoder()
            return try decoder.decode(PaymentResponseBody.self, from: data)

        } catch let error as DecodingError {
            switch error {
            case .dataCorrupted(let context):
                print("Data corrupted:", context.debugDescription)
                print("Coding Path:", context.codingPath)

            case .keyNotFound(let key, let context):
                print("Key '\(key)' not found:", context.debugDescription)
                print("Coding Path:", context.codingPath)

            case .typeMismatch(let type, let context):
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("Coding Path:", context.codingPath)

            case .valueNotFound(let value, let context):
                print("Value '\(value)' not found:", context.debugDescription)
                print("Coding Path:", context.codingPath)

            @unknown default:
                print("Unknown decoding error")
            }
        
        } catch {
            print("Other error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func getMerchantConfig(planId: String) async  -> MerchantConfig? {
        do  {
            let (data, response) = try await apiClient.get("\(baseUrl)/api/v1/checkout-configurations", queryParameters: ["planId": planId])
         
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return nil
            }
            let decoder = JSONDecoder()
            return try decoder.decode(MerchantConfig.self, from: data)

        } catch {
            return nil
        }
    }
    
    
    func getUssdBanks() async  -> [Bank]? {
        do  {
            let (data, response) = try await apiClient.get("\(baseUrl)/api/v1/banks", queryParameters: ["ussd": "true"])
         
            print(response)
            if let responseString = String(data: data, encoding: .utf8) {
                      print("Response Data: \(responseString)")
                  } else {
                      print("Failed to get response data")
                  }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return nil
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode([Bank].self, from: data)

        } catch {
            return nil
        }
    }
    

}

