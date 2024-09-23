//
//  PaymentRrequestBody.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 29/07/2024.
//

import Foundation

import SwiftUI


struct SpotFlowCard: Encodable {
    var pan: String
     var cvv: String
     var expiryYear: String
     var expiryMonth: String
}



struct ValidatePaymentRequestBody: Encodable {
  let otp: String
  let reference: String
  let merchantId: String

  init(merchantId: String, reference: String, otp: String) {
    self.merchantId = merchantId
    self.reference = reference
    self.otp = otp
  }

  // Encodable conformance
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try
 container.encode(reference, forKey: .reference)
    try container.encode(["otp": otp], forKey: .authorization)
    try container.encode(merchantId, forKey: .merchantId)
  }
}

// CodingKeys for encoding
extension ValidatePaymentRequestBody {
  enum CodingKeys: String, CodingKey {
    case reference
    case authorization
    case merchantId
  }
}

struct AuthorizePaymentRequestBody: Encodable {
  let pin: String
  let reference: String
  let merchantId: String

  init(merchantId: String, reference: String, pin: String) {
    self.merchantId = merchantId
    self.reference = reference
    self.pin = pin
  }

  // Encodable conformance
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try
 container.encode(reference, forKey: .reference)
    try container.encode(["pin":
 pin], forKey: .authorization)
    try container.encode(merchantId, forKey: .merchantId)
  }
}

// CodingKeys for encoding
extension AuthorizePaymentRequestBody {
  enum CodingKeys: String, CodingKey {
    case reference
    case authorization
    case merchantId
  }
}

struct PaymentRequestBody: Encodable {
    var reference: String
    var amount: Double
    var currency: String
    var channel: String
    var encryptedCard: String?
    var planId: String?
    var customer: CustomerInfo

    init(
        customer: CustomerInfo,
        encryptedCard: String? = nil,
        currency: String,
        amount: Double,
        channel: String,
        planId: String? = nil
    ) {
        self.reference = PaymentRequestBody.generateReference()
        self.amount = amount
        self.currency = currency
        self.channel = channel
        self.encryptedCard = encryptedCard
        self.planId = planId
        self.customer = customer
    }


    static func generateReference() -> String {
        return "ref-\(UUID().uuidString)"
    }
}
