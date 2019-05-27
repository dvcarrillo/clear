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
    let weatherDataModel = WeatherDataModel()
    let weatherForecast = WeatherForecast()
    
    // IB Outlets for displaying data
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var weatherConditionBackground: UIImageView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var minMaxTemperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    
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
                // TODO: Call functions to process the response
            }
            else {
                print("Alamofire - Error: \(String(describing: response.result.error))")
                self.cityLabel.text = "No connection"
            }
        }
    }
        
    // MARK: - Location Manager delegate methods
    /************************************************************************/
    
    // Executed after location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]    // Get the latest location
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            // TODO: Remove prints
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            
            let params_now : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : API_KEY]
            let params_forecast : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : API_KEY]
            
            getData(from: WEATHER_NOW_URL, parameters: params_now)
            getData(from: WEATHER_FORECAST_URL, parameters: params_forecast)
            
            // TODO: Update UI here?
        }
    }

}

