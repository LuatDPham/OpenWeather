//
//  OWClient.swift
//  OpenWeatherApp
//
//  Created by Luat on 4/21/23.
//

import Foundation

final class OWClient: AsyncAPI {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func fetchWeatherInfo(lat: Double, lon: Double) async throws -> WeatherInfo {
        guard let request = OWEndpoint.weatherInfo(lat: lat, lon: lon).request else {
            throw APIError.urlInvalid
        }
        let weatherInfo = try await fetch(type: WeatherInfo.self, with: request)
        return weatherInfo
    }
    
    func fetchCoordinates(city: String) async throws -> [CityCoordinate] {
        guard let request = OWEndpoint.coordinate(city: city).request else {
            throw APIError.urlInvalid
        }
        let coordinates = try await fetch(type: [CityCoordinate ].self, with: request)
        if coordinates.isEmpty {
            throw APIError.emptyData
        }
        return coordinates

    }
    
    func fetchWeatherIcon(named icon: String) async throws -> Data {
        guard let request = OWEndpoint.icon(type: icon).request else {
            throw APIError.urlInvalid
        }
        let (imageData, _) = try await session.data(for: request)
        return imageData

    }
    
}
