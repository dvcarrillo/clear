//
//  FirstViewController.swift
//  Clear
//
//  Created by David Vargas Carrillo on 10/05/2019.
//  Copyright © 2019 David Vargas Carrillo. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class NowViewController: UIViewController, CLLocationManagerDelegate {
    
    // Weather services constants
    let API_KEY = "fcd47afc48625799d8f94e94495690f0"
    let WEATHER_NOW_URL = "http://api.openweathermap.org/data/2.5/weather"
    let WEATHER_FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()   // Stores the data for the current weather state
    let weatherForecast = WeatherForecast()     // Stores a set of weatherDataModel to represent the forecast
    
    // IB Outlets for displaying data
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var weatherConditionBackground: UIImageView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var minMaxTemperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var sunLabel: UILabel!
    
    @IBOutlet weak var forecastDay1Label: UILabel!
    @IBOutlet weak var forecastDay1Condition: UIImageView!
    @IBOutlet weak var forecastDay1MinTemperature: UILabel!
    @IBOutlet weak var forecastDay1MaxTemperature: UILabel!
    
    @IBOutlet weak var forecastDay2Label: UILabel!
    @IBOutlet weak var forecastDay2Condition: UIImageView!
    @IBOutlet weak var forecastDay2MinTemperature: UILabel!
    @IBOutlet weak var forecastDay2MaxTemperature: UILabel!
    
    @IBOutlet weak var forecastDay3Label: UILabel!
    @IBOutlet weak var forecastDay3Condition: UIImageView!
    @IBOutlet weak var forecastDay3MinTemperature: UILabel!
    @IBOutlet weak var forecastDay3MaxTemperature: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Selected unit: \(UserDefaults.value(forKey: "temperatureUnit"))")
        
        // Location manager set up
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // MARK: - Networking
    /************************************************************************/
    
    // Makes a request to the given URL
    func getData(from url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Alamofire - Response form server successful")

                let responseJSON : JSON = JSON(response.result.value!)
                
                if (url == self.WEATHER_NOW_URL) {
                    self.updateCurrentWeatherData(json: responseJSON)
                }
                else {
                    self.updateForecastData(json: responseJSON)
                }
            }
            else {
                print("Alamofire - Error: \(String(describing: response.result.error))")
                self.cityLabel.text = "No connection"
            }
        }
    }
    
    // MARK: - JSON parsing methods
    /************************************************************************/
    
    // Process the data for the current weather
    func updateCurrentWeatherData(json : JSON) {
        if let currentTempResult = json["main"]["temp"].double {
            weatherDataModel.currentTemperature = Int(currentTempResult - 273.15)
            weatherDataModel.cityName = json["name"].stringValue
            
            weatherDataModel.minTemperature = Int(json["main"]["temp_min"].doubleValue - 273.15)
            weatherDataModel.maxTemperature = Int(json["main"]["temp_max"].doubleValue - 273.15)
            
            weatherDataModel.humidity = json["main"]["humidity"].intValue
            weatherDataModel.pressure = json["main"]["pressure"].intValue
            
            weatherDataModel.conditionId = json["weather"][0]["id"].intValue
            weatherDataModel.conditionDescription = json["weather"][0]["main"].stringValue
           
            // Wind calculation
            weatherDataModel.wind = json["wind"]["speed"].floatValue
            weatherDataModel.windDirection = calculateWindDirection(degrees: json["wind"]["deg"].intValue)
            
            // Sunrise and sunset time
            let sunriseTime = json["sys"]["sunrise"].doubleValue
            let sunsetTime = json["sys"]["sunset"].doubleValue
            
            weatherDataModel.sunriseTime = convertToHoursAndMinutes(from: sunriseTime)
            weatherDataModel.sunsetTime = convertToHoursAndMinutes(from: sunsetTime)
            
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIconName(condition: weatherDataModel.conditionId)
            weatherDataModel.weatherBackgroundName = weatherDataModel.updateWeatherBackgroundName(condition: weatherDataModel.conditionId)
            weatherDataModel.updateSunTimes()
            
            updateCurrentWeatherView()
        }
        else {
            cityLabel.text = "Weather unavailable"
        }
    }
    
    // Process the data for the current weather
    func updateForecastData(json : JSON) {
        print("Updating weather forecast")
    }
    
    // Calculate direction of the wind from the degrees
    func calculateWindDirection(degrees : Int) -> String {
        switch degrees {
        case 0...22:
            return "N"
        case 23...67:
            return "NE"
        case 68...112:
            return "E"
        case 113...157:
            return "SE"
        case 158...202:
            return "S"
        case 203...247:
            return "SW"
        case 248...292:
            return "W"
        case 293...337:
            return "NW"
        case 338...360:
            return "N"
        default:
            return "N/A"
        }
    }
    
    // Receives a UNIX Timestamp and returns only the time in a human readable format (HH:MM AM/PM)
    func convertToHoursAndMinutes(from unixTimestamp: Double) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"   // Remove "a" to avoid printing AM/PM
        
        let dateFromTimestamp = Date(timeIntervalSince1970: unixTimestamp)
        
        return dateFormatter.string(from: dateFromTimestamp)
    }
    
    // MARK: - UI management methods
    /************************************************************************/
    
    // Update the current weather view
    func updateCurrentWeatherView() {
        weatherConditionBackground.image = UIImage(named: weatherDataModel.weatherBackgroundName)
        
        cityLabel.text = weatherDataModel.cityName
        currentTemperatureLabel.text = "\(weatherDataModel.currentTemperature)º"
        minMaxTemperatureLabel.text = "\(weatherDataModel.minTemperature)º / \(weatherDataModel.maxTemperature)º"
        weatherConditionLabel.text = "\(weatherDataModel.conditionDescription)"
        
        pressureLabel.text = "\(weatherDataModel.pressure) hPa"
        humidityLabel.text = "\(weatherDataModel.humidity) %"
        windLabel.text = "\(weatherDataModel.wind) m/s \(weatherDataModel.windDirection)"
        sunLabel.text = weatherDataModel.sunTimes
        
    }
        
    // MARK: - Location Manager delegate methods
    /************************************************************************/
    
    // Executed after location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]    // Get the latest location
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            
            let params_now : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : API_KEY]
            let params_forecast : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : API_KEY]
            
            getData(from: WEATHER_NOW_URL, parameters: params_now)
            getData(from: WEATHER_FORECAST_URL, parameters: params_forecast)
            
            // TODO: Update UI here?
        }
    }
    
    // Executed if the location manager fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location unavailable"
    }

}

