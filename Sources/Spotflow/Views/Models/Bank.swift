//
//  Bank.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 08/09/2024.
//

import Foundation


import Foundation

class Bank: BaseModel, @unchecked Sendable {
    var code: String

    init(name: String, code: String) {
        self.code = code
        super.init(name: name )
     
    }

    // Decode from JSON
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let code = try container.decode(String.self, forKey: .code)
        self.init(name: name, code: code)
    }

    // Encode to JSON
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
        try container.encode(code, forKey: .code)
    }

    // Custom keys for encoding/decoding
    enum CodingKeys: String, CodingKey {
        case name
        case code
    }
}
