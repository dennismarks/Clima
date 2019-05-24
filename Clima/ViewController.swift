//
//  ViewController.swift
//  Weather
//
//  Created by Dennis M on 2019-05-15.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // Set up the HTTP request with URLSession
    let session = URLSession.shared
    let apiKey = "6be27ba9cc250490f7b3cfecfd088343"
    let urlString = "https://api.openweathermap.org/data/2.5/weather/"
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let locationManager = CLLocationManager()
    let gradientLayer = CAGradientLayer()
//    let containersView = WeatherInfoContainers()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        // choose the range of the GPS location
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // ask for a permission; Xcode will go and look for a description in info.plist
        locationManager.requestWhenInUseAuthorization()
        // run in a background
        locationManager.startUpdatingLocation()
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.minimumScaleFactor = 0.2
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.minimumScaleFactor = 0.2
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        nightTimeBackground()
//        dayTimeBackground()
        super.viewWillAppear(animated)
        self.navigationItem.title = "99:99 PM"

//        UINavigationBar.appearance().shadowImage = UIImage()

    }
    
    func dayTimeBackground() {
        
//        let topColour = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        let topColour = UIColor(red: 232/255.0, green: 242/255.0, blue: 253/255.0, alpha: 1.0).cgColor
        
        let bottomColour = UIColor.white.cgColor

//        let bottomColour = UIColor(red: 235/255.0, green: 248/255.0, blue: 255/255.0, alpha: 1.0).cgColor
//        let bottomColour = UIColor(red: 62/255.0, green: 78/255.0, blue: 92/255.0, alpha: 1.0).cgColor

        
//        let topColour = UIColor(red: 165/255.0, green: 208/255.0, blue: 224/255.0, alpha: 1.0).cgColor
//        let bottomColour = UIColor(red: 135/255.0, green: 178/255.0, blue: 194/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColour, bottomColour]
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 232/255.0, green: 242/255.0, blue: 253/255.0, alpha: 1.0)
//        navigationController?.navigationBar.barTintColor = UIColor(red: 165/255.0, green: 208/255.0, blue: 224/255.0, alpha: 1.0)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 118/255.0, green: 160/255.0, blue: 176/255.0, alpha: 1.0)]
        navigationController?.navigationBar.tintColor = UIColor(red: 118/255.0, green: 160/255.0, blue: 176/255.0, alpha: 1.0);
        
        cityLabel.textColor = UIColor(red: 138/255.0, green: 180/255.0, blue: 196/255.0, alpha: 1.0)
        descriptionLabel.textColor = UIColor(red: 148/255.0, green: 190/255.0, blue: 206/255.0, alpha: 1.0)
        tempLabel.textColor = UIColor(red: 158/255.0, green: 200/255.0, blue: 216/255.0, alpha: 1.0)
//        sunriseLabel.textColor = UIColor(red: 158/255.0, green: 200/255.0, blue: 216/255.0, alpha: 1.0)
//        sunsetLabel.textColor = UIColor(red: 158/255.0, green: 200/255.0, blue: 216/255.0, alpha: 1.0)
//        windSpeedLabel.textColor = UIColor(red: 158/255.0, green: 200/255.0, blue: 216/255.0, alpha: 1.0)
//        maxTempLabel.textColor = UIColor(red: 158/255.0, green: 200/255.0, blue: 216/255.0, alpha: 1.0)
//        minTempLabel.textColor = UIColor(red: 158/255.0, green: 200/255.0, blue: 216/255.0, alpha: 1.0)
//        humidityLabel.textColor = UIColor(red: 158/255.0, green: 200/255.0, blue: 216/255.0, alpha: 1.0)
        

        
    }
    
    
    func nightTimeBackground() {
        
//        let topColour = UIColor(red: 22/255.0, green: 38/255.0, blue: 52/255.0, alpha: 1.0).cgColor
//        let bottomColour = UIColor(red: 9/255.0, green: 16/255.0, blue: 21/255.0, alpha: 1.0).cgColor
        
        let topColour = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        let bottomColour = UIColor(red: 32/255.0, green: 48/255.0, blue: 62/255.0, alpha: 1.0).cgColor
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColour, bottomColour]
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.shadowImage = UIImage()
        
        cityLabel.layer.shadowColor = UIColor.black.cgColor
        cityLabel.layer.shadowOffset = CGSize.zero
        cityLabel.layer.shadowRadius = 1.5
        cityLabel.layer.shadowOpacity = 0.4
        
        tempLabel.layer.shadowColor = UIColor.black.cgColor
        tempLabel.layer.shadowOffset = CGSize.zero
        tempLabel.layer.shadowRadius = 1.0
        tempLabel.layer.shadowOpacity = 0.4

        

    }
    
    
    func getWeatherData(for url: URL) {
        session.dataTask(with: url) { (data, response, error) in
            // check if error is nil
            if error != nil {
                print("Error: \(String(describing: error))")
                return
            }
            // check if the HTTP status code is OK
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    // TODO: - give user feedback
                    print("HTTP code error)")
                    return
            }
            // check the MIME type of the response
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type.")
                return
            }
            // parse JSON
            guard let data = data else { return }
            self.parseJsonData(with: data)
            
            }.resume()
    }
    
    
    func parseJsonData(with data: Data) {
        do {
            let weather = try JSONDecoder().decode(WeatherData.self, from: data)
            DispatchQueue.main.async {
                self.updateUI(weather: weather)
            }
        } catch let err {
            print("Error reading JSON:", err)
        }
    }
    
    
    func formatTime(time: Double, timeZone: TimeZone) -> String {
        let unixTime = NSDate(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        let dateString = formatter.string(from: unixTime as Date)
        return dateString
    }
    
    
    func updateUI(weather: WeatherData) {
        let main = weather.main
        let weatherDes = weather.weather[0]
        let coord = weather.coord
        tempLabel.text = "\(Int(main.temp))°"
        cityLabel.text = weather.name.uppercased()
        weatherIcon.image = UIImage(named: updateWeatherIcon(condition: weatherDes.id))
        descriptionLabel.text = String(weatherDes.weatherDescription)
        maxTempLabel.text = "\(Int(floor(main.temp_max)))°C"
        minTempLabel.text = "\(Int(floor(main.temp_min)))°C"
        humidityLabel.text = "\(Int(floor(main.humidity)))%"
        updateLocationBasedUI(weather: weather, coordinates: coord)
    }
    
    
    func updateLocationBasedUI(weather: WeatherData, coordinates: Coordinates) {
        
        let locationForTimeZone = CLLocation(latitude: coordinates.lat, longitude: coordinates.lon)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locationForTimeZone) { (placemarks, err) in
            guard let placemark = placemarks?[0] else { return }
            if let timeZoneToUse = placemark.timeZone {
                
                // sunrise and sunset labels
                self.sunriseLabel.text = self.formatTime(time: Double(weather.sys.sunrise), timeZone: timeZoneToUse)
                self.sunsetLabel.text = self.formatTime(time: Double(weather.sys.sunset), timeZone: timeZoneToUse)
                
                // time label
                let timezone = TimeZone.init(identifier: timeZoneToUse.identifier)
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .none
                dateFormatter.timeStyle = .short
                dateFormatter.timeZone = timezone
                self.navigationItem.title = dateFormatter.string(from: Date())
                
                // wind label
                let wind = weather.wind
                self.windSpeedLabel.text = "\(wind.speed) m/s"
            }
        }
    }
    
}


extension ViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        }

        let latitude = String(location.coordinate.latitude)
        let longtitude = String(location.coordinate.longitude)
        
        guard var urlComponents = URLComponents(string: urlString) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: latitude),
            URLQueryItem(name: "lon", value: longtitude),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        guard let url = urlComponents.url else { return }
        getWeatherData(for: url)
    }
    
}


extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard var urlComponents = URLComponents(string: urlString) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchBar.text!),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        guard let url = urlComponents.url else { return }
        getWeatherData(for: url)
        searchBar.resignFirstResponder()
        searchBar.text! = ""
        searchBarCancelButtonClicked(searchBar)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.searchBar.isHidden = true
            self.searchBar.resignFirstResponder()
//            self.searchButton.isHidden = false
//            self.timeLabel.isHidden = false
//            self.cityLabel.isHidden = false
//            self.descriptionLabel.isHidden = false
        })
    }
    
    @IBAction func searchTapped(_ sender: UIBarButtonItem) {
        self.searchBar.isHidden = false
        self.searchBar.becomeFirstResponder()
        //        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
        ////            self.searchButton.isHidden = true
        ////            self.timeLabel.isHidden = true
        ////            self.cityLabel.isHidden = true
        ////            self.descriptionLabel.isHidden = true
        //            self.searchBar.isHidden = false
        //            self.searchBar.becomeFirstResponder()
        //        })
    }
    
}

extension ViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
