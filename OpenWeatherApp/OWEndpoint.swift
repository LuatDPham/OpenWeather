//
//  OWEndpoint.swift
//  OpenWeatherApp
//
//  Created by Luat on 4/21/23.
//

import Foundation


/// API Calls
/// 1. lat/lon: http://api.openweathermap.org/geo/1.0/direct?q={city name},{state code},{country code}&limit={limit}&appid={API key}
/// 2. Weather: https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
/// 3. Icon: https://openweathermap.org/img/wn/01n@2x.png
let apiKey = "51c39d17da5ad222f5774554e487a785"

enum OWEndpoint {
    case coordinate(city: String?)
    case weatherInfo(lat: Double, lon: Double)
    case icon(type: String)
}


extension OWEndpoint: Endpoint {
    
    var base: String {
        switch self {
        case .coordinate, .weatherInfo:
            return "https://api.openweathermap.org"
        case .icon:
            return "https://openweathermap.org"
        }
    }
    
    var path: String {
        switch self {
        case .coordinate:
            return "/geo/1.0/direct"
        case .weatherInfo:
            return "/data/2.5/weather"
        case .icon(let iconType):
            return "/img/wn/\(iconType)@2x.png"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .coordinate(let city):
            return [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "limit", value: "5"),
                URLQueryItem(name: "appid", value: apiKey),
            ]
        case .weatherInfo(let lat, let lon):
            return [
                URLQueryItem(name: "lat", value: String(lat)),
                URLQueryItem(name: "lon", value: String(lon)),
                URLQueryItem(name: "appid", value: apiKey),
            ]
        case .icon(_): return []
        }
    }
}

