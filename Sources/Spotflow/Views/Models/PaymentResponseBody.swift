//
//  PaymentResponseBody.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 30/07/2024.
//

import Foundation

import Foundation

struct PaymentResponseBody: Decodable {
    let id: String
    let reference: String
    let spotflowReference: String
    let amount: Double
    let currency: String
    let channel: String
    let status: String
    let customer: CustomerInfo
    let provider: String
    let rate: Double?
    let authorization: Authorization?
    let providerMessage: String?
    let bankDetails: BankDetails?

}

struct Rate: Codable {
    let from: String
    let to: String
    let rate: Double
}

struct Authorization: Codable {
    let mode: String
    let redirectUrl: String?

}

struct BankDetails: Codable {
    let accountNumber: String
    let name: String

    init(accountNumber: String, name: String) {
        self.accountNumber = accountNumber
        self.name = name
    }

    enum CodingKeys: String, CodingKey {
        case accountNumber
        case name = "bankName"
    }
    
    static func expiresAt() -> Date {
        Date().addingTimeInterval(30 * 60)
    }
}
