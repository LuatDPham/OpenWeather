//
//  Endpoint.swift
//  OpenWeatherApp
//
//  Created by Luat on 4/21/23.
//

import Foundation

protocol Endpoint {
    var base:  String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        return components
    }
    
    var request: URLRequest? {
        if let url = urlComponents.url {
            return URLRequest(url: url)
        } else {
            print("Could not create url from \(urlComponents)")
            return nil
        }
    }
}

