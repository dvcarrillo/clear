//
//  WeatherForecast.swift
//  Clear
//
//  Created by David Vargas Carrillo on 24/05/2019.
//  Copyright © 2019 David Vargas Carrillo. All rights reserved.
//

import Foundation

class WeatherForecast {
    
    var weekDays : [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var currentDay : Int = 0    // Position of the current day of the week in the array
    
    var day1Forecast = WeatherDataModel()
    var day2Forecast = WeatherDataModel()
    var day3Forecast = WeatherDataModel()
    
    
    // Sets the current day according to the system values
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        currentDay = weekDays.firstIndex(of: dateFormatter.string(from: Date()))!
    }
    
    func printInfo() {
        print("Current day: " + weekDays[currentDay])
        print("Following days: " +
            weekDays[(currentDay + 1) % weekDays.count] + ", " +
            weekDays[(currentDay + 2) % weekDays.count] + ", " +
            weekDays[(currentDay + 3) % weekDays.count])
    }
}
