//
//  UIColor+Hex.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/24/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import UIKit

// MARK: - Conversion to UIColor
extension UIColor {
    convenience public init(hexString: String) {
        let scanner      = Scanner(string: hexString)
        var color:UInt64 = 0;
        scanner.scanHexInt64(&color)

        let mask         = 0x000000FF
        let red          = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let green        = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let blue         = CGFloat(Float(Int(color) & mask)/255.0)

        self.init(red: red, green: green, blue: blue, alpha: CGFloat(1.0))
    }
}
