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
    var conditionId : Int = 0
    var conditionDescription : String = ""
    var minTemperature : Int = 0        // Degrees
    var maxTemperature : Int = 0        // Degrees
    var pressure : Int = 0              // hPa
    var humidity : Int = 0              // %
    var wind : Float = 0.0              // m/s
    var windDirection : String = "N"    // N/S/W/E…
    
    var sunriseTime : String = "00:00 AM"
    var sunsetTime : String = "00:00 AM"
    var sunTimes : String = ""          // Sunrise + sunset
    
    var weatherIconName : String = ""
    var weatherBackgroundName : String = ""
    
    
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
    
    // Update the weather background name given a condition code
    func updateWeatherBackgroundName(condition: Int) -> String {
        switch condition {
        case 0...300:
            return "bg_rain"
            
        case 301...500:
            return "bg_rain"
            
        case 501...600:
            return "bg_rain"
            
        case 601...700:
            return "bg_snow"
            
        case 701...771:
            return "bg_cloudy"
            
        case 772...779:
            return "bg_rain"
            
        case 800:
            return "bg_sunny"
            
        case 801...804:
            return "bg_cloudy"
            
        case 900...903, 905...1000:
            return "bg_rain"
            
        case 903:
            return "bg_snow"
            
        case 904:
            return "bg_sunny"
            
        default:
            return "bg_sunny"
        }
    }
    
    // Update the sun times string according to sunrise and sunset times
    func updateSunTimes() {
        sunTimes = "↑ \(sunriseTime) / ↓ \(sunsetTime)"
    }
    
}
