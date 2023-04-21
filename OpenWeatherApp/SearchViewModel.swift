//
//  SearchViewModel.swift
//  OpenWeatherApp
//
//  Created by Luat on 4/21/23.
//

import Foundation

final class SearchViewModel {
    private(set) var cityCoordinates: [CityCoordinate] = []
    private let client = OWClient()
    private var weatherStore = WeatherStore()
    
    private(set) var weatherInfo: WeatherInfo? {
        didSet {
            updateWeatherInfo()
        }
    }
    private(set) var iconData: Data? = nil {
        didSet {
            updateIcon()
        }
    }
    
    var errorText: String? {
        didSet {
            updateErrorMessage(errorText)
        }
    }
    
    var updateWeatherInfo: () -> Void = {}
    var updateIcon: () -> () = {}
    var updateErrorMessage: (String?) -> () = {_ in}
    
    var weatherDescription: String {
        if let weatherInfo = weatherInfo {
            return  "City: \(weatherInfo.city) \n\(weatherInfo.temperatureData.temp) \nFeels like: \(weatherInfo.temperatureData.feelsLike.str) \nMax: \(weatherInfo.temperatureData.tempMax.str) \nMin: \(weatherInfo.temperatureData.tempMin.str) \n\(weatherInfo.skyCondition.first?.main ?? "")"
        }
        return "Search a city for weather"
    }
    
    func fetchCoordinates(city: String) async {
        do {
            let coordinates = try await client.fetchCoordinates(city: city)
            if let firstCoordinate = coordinates.first {
                await fetchWeatherData(lat: firstCoordinate.latitude, lon: firstCoordinate.longitude)
            }
        } catch {
            errorText = (error as? APIError)?.customDescription
        }
    }

    func fetchWeatherData(lat: Double, lon: Double) async {
        do {
            weatherInfo = try await client.fetchWeatherInfo(lat: lat, lon: lon)
            await fetchWeatherIcon(named: weatherInfo?.skyCondition.first?.icon ?? "")
            if let weatherInfo = weatherInfo {
                try await weatherStore.save(weatherInfo: weatherInfo)
                errorText = nil
            }
        } catch {
            errorText = (error as? APIError)?.customDescription
        }
    }

    func fetchWeatherIcon(named icon: String?) async {
        guard let icon = icon, icon.isEmpty == false else {
            errorText = "Icon type is empty"
            return
        }

        do {
            iconData = try await client.fetchWeatherIcon(named: icon)
        } catch {
            errorText = (error as? APIError)?.customDescription
        }
    }
    
    func clearWeatherInfoAndIcon() {
        weatherInfo = nil
        iconData = nil
    }

    func loadStore() {
        Task {
            do {
                try await weatherStore.load()
                self.weatherInfo = weatherStore.weatherInfo
                await fetchWeatherIcon(named: weatherInfo?.skyCondition.first?.icon)
            } catch {
                errorText = error.localizedDescription
            }
        }
    }
    
}
