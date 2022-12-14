//
//  WeatherManager.swift
//  Clima
//
//  Created by Abduqodir's MacPro on 2021/10/09.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

func getAPI() -> String {
  var key: NSDictionary?
  var weatherApi = ""
  if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
        key = NSDictionary(contentsOf: URL(fileURLWithPath: path))
    }
    
  if let dict = key {
    weatherApi = dict["WeatherAPI"] as? String ?? ""
    }
  return weatherApi
}

struct WeatherManager {
  
  let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(getAPI())&units=metric"
    // if the url is 'http', then the URLSession won't work because the connection is insecure
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather (cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    // In Swift, we can have two identical functions as long as parameter names (input) are different
    func fetchWeather (latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return // this 'empty' return command quits parseJSON function if there is an error and so stops running the code below.
                }
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON (_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    }
    
    
    
}
