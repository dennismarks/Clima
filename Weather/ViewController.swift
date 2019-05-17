//
//  ViewController.swift
//  Weather
//
//  Created by Dennis M on 2019-05-15.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal

        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        guard var urlComponents = URLComponents(string: urlString) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "Toronto"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        // Make the request with URLSessionDataTask
        guard let url = urlComponents.url else { return }
        
        getWeatherData(for: url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let topColour = UIColor(red: 22/255.0, green: 38/255.0, blue: 52/255.0, alpha: 1.0).cgColor
        let bottomColour = UIColor(red: 9/255.0, green: 16/255.0, blue: 21/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColour, bottomColour]
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
                    print("HTTP code error.)")
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

}
