//
//  WeatherModel.swift
//  Clima
//
//  Created by Abduqodir's MacPro on 2021/10/11.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double  //these three constants are stored properties
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500, 501, 520...531:
            return "cloud.rain"
        case 502...504:
            return "cloud.heavyrain"
        case 511:
            return "cloud.sleet"
        case 600...622:
            return "cloud.snow"
        case 701, 741:
            return "cloud.fog"
        case 711:
            return "smoke"
        case 721:
            return "sun.haze"
        case 731, 751...762:
            return "sun.dust"
        case 771:
            return "wind"
        case 781:
            return "tornado"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "sun.min"
        }
        //this one is a computed property. It works out its value based on the passed conditionId property. Computed properties should always be var - variable because its value changes based on the computing that happens between {}. The syntax is 'var aProperty: Int { return 2 + 5 }'. In this case, the variable is equal to 7.
    }
    
}
