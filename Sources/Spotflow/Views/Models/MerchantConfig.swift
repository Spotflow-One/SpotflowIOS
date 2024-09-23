//
//  MerchantConfig.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 18/08/2024.
//

import Foundation

import Foundation

struct MerchantConfig : Codable {
    let merchantLogo: String
    let merchantName: String
    let paymentMethods: [String]
    let plan: SpotFlowPlan
    let rate: Rate
    
}

struct SpotFlowPlan : Codable{
    let id: String
    let title: String
    let frequency: String
    let amount: Double // Using Double for numbers in Swift
    let currency: String
    let status: String
}
