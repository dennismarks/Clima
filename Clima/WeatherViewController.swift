//
//  ViewController.swift
//  Weather
//
//  Created by Dennis M on 2019-05-15.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    // Set up the HTTP request with URLSession
    let session = URLSession.shared
    let apiKey = "6be27ba9cc250490f7b3cfecfd088343"
    let urlString = "https://api.openweathermap.org/data/2.5/weather/"
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            let weather = try JSONDecoder().decode(Weather.self, from: data)
            DispatchQueue.main.async {
                self.updateUI(weather: weather)
            }
        } catch let err {
            print("Error reading JSON:", err)
        }
    }
    
    
    func updateUI(weather: Weather) {
        self.label.text = weather.name
    }
    
}
