//
//  WeatherDataModel.swift
//  Clear
//
//  Created by David Vargas Carrillo on 23/05/2019.
//  Copyright © 2019 David Vargas Carrillo. All rights reserved.
//

import Foundation

class WeatherDataModel {
    
    var cityName : String = ""
    
    var currentTemperature : Int = 0    // Degrees
    var condition : String = ""
    var minTemperature : Int = 0        // Degrees
    var maxTemperature : Int = 0        // Degrees
    var pressure : Int = 0              // hPa
    var wind : Float = 0.0              // m/s
    var windDirection : String = "N"    // N/S/W/E…
    var rainOneHour : Int = 0           // mm during last hour
    var rainThreeHours : Int = 0        // mm during last 3 hours
    
    var weatherIconName : String = ""
    
    
    // Designated initializer
    init() {}
    
    // Update the weather icon name given a condition code
    func updateWeatherIconName(condition: Int) -> String {
        switch condition {
        case 0...300:
            return "tstorm1"
        
        case 301...500:
            return "light_rain"
            
        case 501...600:
            return "shower3"
            
        case 601...700:
            return "snow4"
            
        case 701...771:
            return "fog"
        
        case 772...779:
            return "tstorm3"
            
        case 800:
            return "sunny"
            
        case 801...804:
            return "cloudy2"
            
        case 900...903, 905...1000:
            return "tstorm3"
            
        case 903:
            return "snow5"
            
        case 904:
            return "sunny"
            
        default:
            return "dunno"
        }
    }
    
}
