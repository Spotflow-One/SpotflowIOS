//
//  ApiClient.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 30/07/2024.
//

//import Alamofire

import Foundation

class ApiClient {
    let authToken: String?
    
    init(authToken: String?) {
        self.authToken = authToken
    }
    
    private var session: URLSession {
        let config = URLSessionConfiguration.default
        if let token = authToken {
            config.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
        }
        return URLSession(configuration: config)
    }
    
    func post(_ path: String, data: Encodable) async throws -> (Data,URLResponse){
        let url = URL(string: path)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let jsonData = try JSONEncoder().encode(data)
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
        return try await session.data(for: request)

    }
    
    func get(_ path: String, queryParameters: [String: String]) async throws  -> (Data, URLResponse) {
        var components = URLComponents(string: path)
        components?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components?.url else { throw ApiClientError.invalidUrl }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return try await session.data(for: request)
        
    }
}

enum ApiClientError: Error {
    case invalidUrl
    case networkError
  
}



