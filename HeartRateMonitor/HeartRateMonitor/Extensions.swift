//
//  Extensions.swift
//  HeartRateMonitor
//
//  Created by Final Year Project Account on 2020/3/16.
//  Copyright © 2020 Final Year Project Account. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb (r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let yellowColor = UIColor.rgb(r: 235, g: 235, b: 0)
    
    static let redColorTest = UIColor.rgb(r: 235, g: 100, b: 100)
    static let blueColorTest = UIColor.rgb(r: 60, g: 160, b: 255)
    
    static let pulseColorGreen = UIColor.rgb(r: 37, g: 174, b: 84)
    static let pulseColorRed = UIColor.rgb(r: 130, g: 54, b: 43)
    
    static let redColor = UIColor.rgb(r: 235, g: 15, b: 0)
    static let greenColor = UIColor.rgb(r: 0, g: 235, b: 15)
    
    static let myGrey = UIColor.rgb(r: 142, g: 142, b: 147)
    
    static let btnRestart = UIColor.rgb(r: 229, g: 24, b: 50)
    static let btnContinue = UIColor.rgb(r: 85, g: 247, b: 88)
}
