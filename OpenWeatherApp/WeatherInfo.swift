//
//  WeatherInfo.swift
//  OpenWeatherApp
//
//  Created by Luat on 4/21/23.
//

import Foundation

struct WeatherInfo: Codable {
    let skyCondition: [SkyCondition]
    let temperatureData: TempuratureData
    let city: String
    
    enum CodingKeys: String, CodingKey {
        case skyCondition = "weather"
        case temperatureData = "main"
        case city = "name"
    }
    struct SkyCondition: Codable {
        let main: String
        let description: String
        let icon: String
    }
    
    struct TempuratureData: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp, humidity
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }
}
