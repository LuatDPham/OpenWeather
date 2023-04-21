//
//  SearchViewController.swift
//  OpenWeatherApp
//
//  Created by Luat on 4/21/23.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var errorMessage: UILabel!
    
    private let viewModel = SearchViewModel()
    private let store = WeatherStore()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        setUpLocationManager()
        
        viewModel.loadStore()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.updateWeatherInfo = { [weak self] in
            DispatchQueue.main.async {
                self?.weatherInfoLabel.text = self?.viewModel.weatherDescription
            }
        }
        
        viewModel.updateIcon = { [weak self] in
            DispatchQueue.main.async {
                if let data = self?.viewModel.iconData {
                    self?.iconView.image = UIImage(data: data)
                } else {
                    self?.iconView.image = nil
                }
            }
        }
        
        viewModel.updateErrorMessage = { [weak self] error in
            DispatchQueue.main.async {
                if let errorText = error {
                    self?.errorMessage.isHidden = false
                    self?.errorMessage.text = errorText
                    self?.viewModel.clearWeatherInfoAndIcon()
                } else {
                    self?.errorMessage.isHidden = true
                }
            }
        }
    }
    
    private func performFetch(city: String?) {
        guard let city = city, city.isEmpty == false else {
            viewModel.errorText = "Please enter a city"
            return
        }
        
        Task {
            await viewModel.fetchCoordinates(city: city)
        }
    }

    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performFetch(city: searchBar.text)
    }
    
}

extension SearchViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("No location services")
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            if let coordinates = manager.location?.coordinate {
                Task {
                    await viewModel.fetchWeatherData(lat: coordinates.latitude, lon: coordinates.longitude)
                }
            }
        default:
            break
        }
        
    }
    
}
