//
//  ColorsModel.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/24/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import Foundation

// MARK: - ColorsModel
/// Response for list of items.
/// For example for people when T = ColorsModel
/// Example url: ""
struct ColorsModel: Decodable {
    struct Colors: Decodable {
        let backgroundColors, textColors: [String]
    }
    let title: String
    let colors: Colors
}

extension ColorsModel {
    enum CodingKeys: CodingKey {
        case title
        case colors
    }
}
