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
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!

    // Labels
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    // Images
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var sunriseImage: UIImageView!
    @IBOutlet weak var sunsetImage: UIImageView!
    @IBOutlet weak var windImage: UIImageView!
    @IBOutlet weak var maxTempImage: UIImageView!
    @IBOutlet weak var minTempImage: UIImageView!
    @IBOutlet weak var humidityImage: UIImageView!
    
    // Weather info stacks
    @IBOutlet weak var bottomFirstStack: UIStackView!
    @IBOutlet weak var bottomSecondStack: UIStackView!
    
    let locationManager = CLLocationManager()
    let gradientLayer = CAGradientLayer()
    var weatherCond : Int = 0
    static var dayTime : Bool = true

    
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
        
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.minimumScaleFactor = 0.2
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.minimumScaleFactor = 0.2
    }
    
    
    
    fileprivate func updateTheme() {
        if ViewController.dayTime {
            dayTimeBackground()
        } else {
            nightTimeBackground()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {


        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        view.layer.isHidden = true
//        updateTheme()
        

    }
    
    
    @IBAction func changeThemeTapped(_ sender: UIBarButtonItem) {
        updateTheme()
    }
    
    
    func applyPlainShadow(image: UIImageView) {
        image.layer.shadowColor = UIColor(red: 165/255.0, green: 208/255.0, blue: 224/255.0, alpha: 1.0).cgColor
        image.layer.shadowOffset = CGSize.zero
        image.layer.shadowRadius = 3.0
        image.layer.shadowOpacity = 0.3
    }
    
    fileprivate func animateView() {
        // animate top view
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
            UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.cityLabel.isHidden = false
            })
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600), execute: {
            UIView.transition(with: self.view, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.descriptionLabel.isHidden = false
            })
        })
        
        // animate mid view
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(800), execute: {
            UIView.transition(with: self.view, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.weatherIcon.isHidden = false
            })
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
            UIView.transition(with: self.view, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.tempLabel.isHidden = false
            })
        })
        
        // animate bottom view
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200), execute: {
            UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.bottomFirstStack.layer.opacity = 1.0
            })
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1400), execute: {
            UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.bottomSecondStack.layer.opacity = 1.0
            })
        })
    }
    
    func dayTimeBackground() {
        
        ViewController.dayTime = true
        
        searchBar.keyboardAppearance = .default
        searchBar.searchBarStyle = .minimal
        // cancel button colour
        searchBar.barTintColor = UIColor(red: 128/255.0, green: 160/255.0, blue: 186/255.0, alpha: 1.0)
        
        // hide all elemetns
        cityLabel.isHidden = true
        descriptionLabel.isHidden = true
        weatherIcon.isHidden = true
        tempLabel.isHidden = true
        bottomFirstStack.layer.opacity = 0.0
        bottomSecondStack.layer.opacity = 0.0
        
        // change the colour background
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            let topColour = UIColor(red: 242/255.0, green: 252/255.0, blue: 263/255.0, alpha: 1.0).cgColor
            let bottomColour = UIColor.white.cgColor
            self.gradientLayer.frame = self.view.bounds
            self.gradientLayer.colors = [topColour, bottomColour]
            self.backgroundView.layer.insertSublayer(self.gradientLayer, at: 0)
            
            // animate navigation bar
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(120), execute: {
                UIView.transition(with: self.view, duration: 1.5, options: .transitionCrossDissolve, animations: {
                    self.navigationController?.navigationBar.barTintColor = UIColor(red: 242/255.0, green: 252/255.0, blue: 263/255.0, alpha: 1.0)
                    self.navigationController?.navigationBar.shadowImage = UIImage()
                })
            })
        })
        
        animateView()
        
        weatherIcon.image = UIImage(named: updateWeatherIcon(condition: weatherCond))
        
        // search bar text colour
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(red: 118/255.0, green: 160/255.0, blue: 176/255.0, alpha: 1.0)
        // navigation bar title colour
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 118/255.0, green: 160/255.0, blue: 176/255.0, alpha: 1.0)]
        // bar buttons colour
        navigationController?.navigationBar.tintColor = UIColor(red: 118/255.0, green: 160/255.0, blue: 176/255.0, alpha: 1.0);
        // update labels
        cityLabel.textColor = UIColor(red: 138/255.0, green: 180/255.0, blue: 196/255.0, alpha: 1.0)
        descriptionLabel.textColor = UIColor(red: 148/255.0, green: 190/255.0, blue: 206/255.0, alpha: 1.0)
        tempLabel.textColor = UIColor(red: 158/255.0, green: 200/255.0, blue: 216/255.0, alpha: 0.8)
        // update weather info images
        sunriseImage.image = UIImage(named: "sunrise_day")
        sunsetImage.image = UIImage(named: "sunset_day")
        windImage.image = UIImage(named: "wind_day")
        maxTempImage.image = UIImage(named: "high_temp_day")
        minTempImage.image = UIImage(named: "low_temp_day")
        humidityImage.image = UIImage(named: "humidity_day")
        
        applyPlainShadow(image: sunriseImage)
        applyPlainShadow(image: sunsetImage)
        applyPlainShadow(image: windImage)
        applyPlainShadow(image: maxTempImage)
        applyPlainShadow(image: minTempImage)
        applyPlainShadow(image: humidityImage)
        
    }
    
    
    func nightTimeBackground() {
        
        ViewController.dayTime = false
        
        searchBar.keyboardAppearance = .dark
        searchBar.searchBarStyle = .minimal
        // cancel button colour
        searchBar.barTintColor = UIColor(red: 146/255.0, green: 211/255.0, blue: 240/255.0, alpha: 1.0)

        // hide all elemetns
        cityLabel.isHidden = true
        descriptionLabel.isHidden = true
        weatherIcon.isHidden = true
        tempLabel.isHidden = true
        bottomFirstStack.layer.opacity = 0.0
        bottomSecondStack.layer.opacity = 0.0
        
        // change the colour background
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            let topColour = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
            let bottomColour = UIColor(red: 32/255.0, green: 48/255.0, blue: 62/255.0, alpha: 1.0).cgColor
            self.gradientLayer.frame = self.view.bounds
            self.gradientLayer.colors = [topColour, bottomColour]
            self.backgroundView.layer.insertSublayer(self.gradientLayer, at: 0)
            
            // animate navigation bar
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(120), execute: {
                UIView.transition(with: self.view, duration: 1.5, options: .transitionCrossDissolve, animations: {
                    self.navigationController?.navigationBar.barTintColor = UIColor.black
                    self.navigationController?.navigationBar.shadowImage = UIImage()
                })
            })
        })
        
        animateView()
        
        weatherIcon.image = UIImage(named: updateWeatherIcon(condition: weatherCond))
        
        // search bar text colour
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(red: 146/255.0, green: 211/255.0, blue: 240/255.0, alpha: 1.0)
        // navigation bar title colour
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 146/255.0, green: 211/255.0, blue: 240/255.0, alpha: 1.0)]
        // bar buttons colour
        navigationController?.navigationBar.tintColor = UIColor(red: 146/255.0, green: 211/255.0, blue: 240/255.0, alpha: 1.0);
        // update labels
        cityLabel.textColor = UIColor(red: 165/255.0, green: 208/255.0, blue: 224/255.0, alpha: 1.0)
        descriptionLabel.textColor = UIColor(red: 165/255.0, green: 208/255.0, blue: 224/255.0, alpha: 1.0)
        tempLabel.textColor = UIColor(red: 146/255.0, green: 211/255.0, blue: 240/255.0, alpha: 1.0)
        // update weather info images
        sunriseImage.image = UIImage(named: "sunrise_night")
        sunsetImage.image = UIImage(named: "sunset_night")
        windImage.image = UIImage(named: "wind_night")
        maxTempImage.image = UIImage(named: "high_temp_night")
        minTempImage.image = UIImage(named: "low_temp_night")
        humidityImage.image = UIImage(named: "humidity_night")
        
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
        
        cityLabel.isHidden = true
        descriptionLabel.isHidden = true
        weatherIcon.isHidden = true
        tempLabel.isHidden = true
        bottomFirstStack.layer.opacity = 0.0
        bottomSecondStack.layer.opacity = 0.0
        
        let main = weather.main
        let weatherDes = weather.weather[0]
        let coord = weather.coord
        weatherCond = weatherDes.id
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
                let sunrise = self.formatTime(time: Double(weather.sys.sunrise), timeZone: timeZoneToUse)
                let sunset = self.formatTime(time: Double(weather.sys.sunset), timeZone: timeZoneToUse)
                self.sunriseLabel.text = sunrise
                self.sunsetLabel.text = sunset
                
                // time label
                let timezone = TimeZone.init(identifier: timeZoneToUse.identifier)
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .none
                dateFormatter.timeStyle = .short
                dateFormatter.timeZone = timezone
                let curTime = dateFormatter.string(from: Date())
                self.navigationItem.title = curTime
                
                if (sunrise < curTime && curTime < sunset) {
                    ViewController.dayTime = true
                } else {
                    ViewController.dayTime = false
                }
                
                // wind label
                let wind = weather.wind
                self.windSpeedLabel.text = "\(wind.speed) m/s"
                
                
                self.updateTheme()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self.navigationController?.navigationBar.isHidden = false
                })
//
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
                    self.view.layer.isHidden = false
                })
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
        
        searchBar.resignFirstResponder()
        searchBar.text! = ""
        searchBarCancelButtonClicked(searchBar)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.getWeatherData(for: url)
        })
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.searchBar.isHidden = true
            self.searchBar.resignFirstResponder()
        })
    }
    
    @IBAction func searchTapped(_ sender: UIBarButtonItem) {
        self.searchBar.isHidden = false
        self.searchBar.becomeFirstResponder()
    }
    
}

extension ViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
