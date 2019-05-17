//
//  WeatherInfoContainers.swift
//  Weather
//
//  Created by Dennis M on 2019-05-16.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

class WeatherInfoContainers: UIView {

    func applyPlainShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8
        layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyPlainShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyPlainShadow()
    }
    
}
