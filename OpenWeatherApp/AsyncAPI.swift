//
//  AsyncAPI.swift
//  OpenWeatherApp
//
//  Created by Luat on 4/21/23.
//

import Foundation


protocol AsyncAPI {
    var session: URLSession { get }
    func fetch<T: Decodable>(type: T.Type, with request: URLRequest) async throws -> T
}

extension AsyncAPI {
    func fetch<T: Decodable>(type: T.Type, with request: URLRequest) async throws -> T {
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed(description: "Invalid response")
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.responseUnsuccessful(description: "status code \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            throw APIError.jsonParsingFailure(description: error.localizedDescription)
        }
    }
}
