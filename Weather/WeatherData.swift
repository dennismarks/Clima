//
//  WeatherData.swift
//  Weather
//
//  Created by Dennis M on 2019-05-15.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import Foundation

//
//  WeatherDataModel.swift
//  Weather
//
//  Created by Dennis M on 2019-05-15.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: WeatherContidons
    let condition: Int
    let weather: [Weather]
    let sys: Sys
    let wind: Wind
    let coord: Coordinates
    
    enum CodingKeys : String, CodingKey {
        case name
        case main
        case condition = "cod"
        case weather
        case sys
        case wind
        case coord
    }
}

struct WeatherContidons: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let weatherDescription: String
    
    enum CodingKeys : String, CodingKey {
        case id
        case weatherDescription = "main"
    }
}

struct Sys: Decodable {
    let sunrise: Int
    let sunset: Int
}

struct Wind: Decodable {
    let speed: Double
}

struct Coordinates: Decodable {
    let lon: Double
    let lat: Double
}

func updateWeatherIcon(condition: Int) -> String {
    switch (condition) {
        case 0...300 :
            return "lightning_night"
        case 301...500 :
            return "rain_day"
        case 501...600 :
            return "heavy_rain_day"
        case 601...700 :
            return "snow_day"
        case 701...771 :
            return "fog_day"
        case 772...799 :
            return "lightning_day"
        case 800 :
            return "sun_night"
        case 801...804 :
            return "cloud_night"
//            return "cloudy_day"
        case 900...903, 905...1000  :
            return "lightning_night"
        case 903 :
            return "snow_day"
        case 904 :
            return "sun_day"
        default :
            return "error"
    }
    
}
