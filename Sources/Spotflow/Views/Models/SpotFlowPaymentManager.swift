//
//  SpotFlowPaymentManager.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 29/07/2024.
//

import Foundation

import SwiftUI

struct CustomerInfo:Codable {
    var email: String
    var phoneNumber: String?
    var name: String?
    var id: String?

}

struct SpotFlowPaymentManager {
    var customerId: String?

    var appLogo: Image?

    var appName: String?

    var customerName: String?

    var customerEmail: String

    var customerPhoneNumber: String?

    var merchantId: String

    var key: String
    
    var encryptionKey : String
    
    var planId: String

    var paymentDescription: String?

    var customer: CustomerInfo {
        return CustomerInfo(
            email: customerEmail,
            phoneNumber: customerPhoneNumber,
            name: customerName,
            id: customerId
        )
    }

    init(
        merchantId: String,
        key: String,
        customerEmail: String,
        customerName: String? = nil,
        customerPhoneNumber: String? = nil,
        customerId: String? = nil,
        paymentDescription: String? = nil,
        appLogo: Image? = nil,
        appName: String? = nil,
        planId: String,
        encryptionKey:String
    ) {
        self.merchantId = merchantId
        self.key = key
        self.customerEmail = customerEmail
        self.customerName = customerName
        self.customerPhoneNumber = customerPhoneNumber
        self.customerId = customerId
        self.paymentDescription = paymentDescription
        self.appLogo = appLogo
        self.appName = appName
        self.planId = planId
        self.encryptionKey = encryptionKey
    }
    
    
}

let examplePaymentManager = SpotFlowPaymentManager(
    merchantId: "2f020a56-fbd3-40a3-ac90-d77d38399b6d",
    key: "sk_test_d96889a82e9743bfb274c5f684ad5b69",
    customerEmail: "nkwachi@spotflow.one",
    paymentDescription: "League Pass",
    appLogo: Image("nba-logo"),
    planId: "3c902af2-6bec-4cc1-a2a3-f74fc35e88d4",
    encryptionKey: "g4ryTjP3VAGwl8Bk9r0foFtgoY64Ba4gZQ701OAAbB4="
)
