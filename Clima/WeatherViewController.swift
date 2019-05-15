//
//  ViewController.swift
//  WeatherApp
//


import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "6be27ba9cc250490f7b3cfecfd088343"
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the location manager here; helps us to get GPS location
        locationManager.delegate = self
        
        // choose the range of the GPS location
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // ask for a permission; Xcode will go and look for a description in info.plist
        locationManager.requestWhenInUseAuthorization()
        
        // run in a background
        locationManager.startUpdatingLocation()
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWheatherData(url : String, parameters : [String:String]) {
        /*
         use Alarmofire to make an HTTP request;
         url - the address of the data server that we want to access;
         method - what type of request we want to make;
         parameters - parameters for Weather url;
         request method is asynchronous - it happens in the background; once the request is complete it tiggers a responseJSON and that response contains data that is held inside the variable "response"
         */
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            
            // got the response from the server at this point
            // when you see "in" it means you're inside a closure; a function inside the function
            response in
            
            // check if the response was successful
            if response.result.isSuccess {
                print("Success! Got the weather data")
                
                // JSON - JavaScrip Object Notation; a way of formating large pieces of data that gets passed around on the internet
                let wheather : JSON = JSON(response.result.value!)
                
                // when you're inside a closure, specify a self in front of your method calls
                self.updateWheatherData(json: wheather)
            } else {
                print("Error: " + String(describing: response.result.error))
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    //Write the updateWeatherData method here:
    
    func updateWheatherData(json : JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            weatherDataModel.weatherDescription = json["weather"][0]["main"].stringValue
            updateUIWithWeatherData()
        } else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData() {
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = String(weatherDataModel.temperature) + "°"
        weatherDescription.text = weatherDataModel.weatherDescription
    }
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    //Write the didUpdateLocations method here; activated once the location manager has found the location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // startUpdatingLocation() will be updating CLLocation array with the device's location; last value in CLLocation array will be the most accurate
        let location = locations[locations.count - 1]
        
        // horizontalAccuracy is the radious of the circle where there user is; if the value is negative that the result is invalid
        if location.horizontalAccuracy > 0 {
            // stop updating user location as soon as you got the result; to avoid draining th ebattery
            locationManager.stopUpdatingLocation()
            
            // stopUpdatingLocation() takes time to stop; removes curent class of receiving messeges while it's in the proccess to stop
            locationManager.delegate = nil
        }
        
        print("latitude: \(location.coordinate.latitude), longtitude: \(location.coordinate.longitude)")
        let latitude = String(location.coordinate.latitude)
        let longtitude = String(location.coordinate.longitude)
        let params : [String:String] = ["lat" : latitude, "lon" : longtitude, "appid" : APP_ID]
        
        getWheatherData(url : WEATHER_URL, parameters : params)
    }
    
    
    
    //Write the didFailWithError method here; if there was an error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredNewCityName(city: String) {
        let params : [String:String] = ["q" : city, "appid" : APP_ID]
        getWheatherData(url: WEATHER_URL, parameters: params)
    }
    
    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delagate = self
        }
    }
}
