//
//  Enums.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/25/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case responseError
    case parseError(Error)
}

// MARK: - Types
enum ColorPickerType {
    case textColor
    case backgroundColor
}

