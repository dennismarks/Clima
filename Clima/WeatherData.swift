import Foundation

//
//  WeatherDataModel.swift
//  Weather
//
//  Created by Dennis M on 2019-05-15.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    let name: String
    let main: weatherContidons
    let condition: Int
    
    enum CodingKeys : String, CodingKey {
        case name
        case main
        case condition = "cod"
    }
    
    init() {
        self.name = ""
        self.main = weatherContidons(temp: 0.0)
        self.condition = 0
    }
}

struct weatherContidons: Decodable {
    let temp: Double
    
    init(temp: Double) {
        self.temp = temp
    }
}
