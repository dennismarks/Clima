//
//  WeatherInfoContainers.swift
//  Weather
//
//  Created by Dennis M on 2019-05-16.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

class WeatherInfoContainers: UIView {
    
    var apply : Bool = false
    
    func name() {
        print("Hello")
    }

    func applyPlainShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.4
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        applyPlainShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if apply {
            applyPlainShadow()
        }
//        layer.backgroundColor = .none
//        applyPlainShadow()
    }
    
}
