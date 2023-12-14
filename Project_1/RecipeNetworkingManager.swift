//
//  NetworkingManager.swift
//  Project_1
//
//  Created by Raj-Renil on 2023-12-06.
//

import Foundation

protocol NetworkingDelegate: AnyObject {
    func networkingDidFinishWithCities(cities: [String])
    func networkingDidFinishWithError()
}

class NetworkingManager {
    static let shared = NetworkingManager()
    weak var delegate: NetworkingDelegate?

    func getCities(searchText: String) {
        guard let url = URL(string: "http://gd.geobytes.com/AutoCompleteCity?&q=\(searchText)") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data else { return }

            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.delegate?.networkingDidFinishWithError()
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.delegate?.networkingDidFinishWithError()
                return
            }

            do {
                let decoder = JSONDecoder()
                let cities = try decoder.decode([String].self, from: data)
                self.delegate?.networkingDidFinishWithCities(cities: cities)
            } catch {
                print("Error decoding cities: \(error.localizedDescription)")
                self.delegate?.networkingDidFinishWithError()
            }
        }.resume()
    }

    func getWeatherForCity(cityInfo: City, completionHandler: @escaping (Result<WeatherObject, Error>) -> Void) {
        let cityInfoString = "\(cityInfo.cityName),\(cityInfo.stateName),\(cityInfo.countryName)"
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityInfoString)&appid=YOUR_API_KEY&units=metric") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else { return }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let weatherObj = try decoder.decode(WeatherObject.self, from: data)
                    completionHandler(.success(weatherObj))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }.resume()
    }
}
