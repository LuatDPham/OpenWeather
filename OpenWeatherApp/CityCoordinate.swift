//
//  CityCoordinate.swift
//  OpenWeatherApp
//
//  Created by Luat on 4/21/23.
//

import Foundation

struct CityCoordinate: Decodable {
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let state: String
    
    enum CodingKeys: String, CodingKey {
        case name, country, state
        case latitude = "lat"
        case longitude = "lon"
    }
}
