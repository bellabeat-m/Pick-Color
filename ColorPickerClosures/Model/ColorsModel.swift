//
//  ColorsModel.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/24/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import Foundation

// MARK: - ColorsModel
struct ColorsModel: Decodable {
    let title: String
    let colors: Colors
}

// MARK: - Colors
struct Colors: Decodable {
    let backgroundColors, textColors: [String]
}
