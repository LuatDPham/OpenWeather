//
//  APIError.swift
//  OpenWeatherApp
//
//  Created by Luat on 4/21/23.
//

import Foundation


enum APIError: Error {
    case requestFailed(description: String)
    case invalidData
    case responseUnsuccessful(description: String)
    case jsonParsingFailure(description: String)
    case urlInvalid
    case emptyData
    
    var customDescription: String {
        switch self {
        case .requestFailed(let description): return "Request Failed Error -> \(description)"
        case .invalidData: return "Invalid Data Error"
        case let .responseUnsuccessful(description): return "Response Unsuccessful Error: \(description)"
        case let .jsonParsingFailure(description): return "JSON Parsing Failure: \(description)"
        case .urlInvalid: return "Could not create url request"
        case .emptyData: return "Data returned was empty []"
        }
    }
}
