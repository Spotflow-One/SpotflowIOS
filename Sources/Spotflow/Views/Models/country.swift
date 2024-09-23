//
//  country.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 06/09/2024.
//

import Foundation

// Base class
class BaseModel: Codable {
    var name: String

    init(name: String) {
        self.name = name
    }
}

// Country class
class Country: BaseModel {
    var states: [CountryState]

    init(name: String, states: [CountryState]) {
        self.states = states
        super.init(name: name)
    }

    // Required for decoding from JSON
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let states = try container.decode([CountryState].self, forKey: .states)
        self.states = states
        super.init(name: name)
    }

    // Encoding back to JSON
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(states, forKey: .states)
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case states
    }
}

// CountryState class
class CountryState: BaseModel {
    var cities: [City]

    init(name: String, cities: [City]) {
        self.cities = cities
        super.init(name: name)
    }

    // Required for decoding from JSON
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let cities = try container.decode([City].self, forKey: .cities)
        self.cities = cities
        super.init(name: name)
    }

    // Encoding back to JSON
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(cities, forKey: .cities)
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case cities
    }
}

// City class
class City: BaseModel {
    
  
    // Required for decoding from JSON
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        super.init(name: name)
    }

    // Encoding back to JSON
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }

    private enum CodingKeys: String, CodingKey {
        case name
    }
}
