//
//  WeatherStore.swift
//  OpenWeatherApp
//
//  Created by Luat on 4/21/23.
//

import Foundation


class WeatherStore {
    var weatherInfo: WeatherInfo?
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("weather.info")
    }
    
    func load() async throws {
        let task = Task<WeatherInfo?, Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return nil
            }
            let weatherItem = try JSONDecoder().decode(WeatherInfo.self, from: data)
            return weatherItem
        }
        let weatherInfo = try await task.value
        self.weatherInfo = weatherInfo
    }
    
    func save(weatherInfo: WeatherInfo) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(weatherInfo)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
