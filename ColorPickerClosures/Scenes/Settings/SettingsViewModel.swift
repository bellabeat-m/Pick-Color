//
//  ColorPickerModel.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/30/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import UIKit

class SettingsViewModel {
   
    // MARK: - Dependencies
    private let apiService: Service
    
    // MARK: - Initializers
    init(apiService: Service) {
        self.apiService = apiService
    }
    // MARK: - Properties exposed for view controllers
    public var backgroundColors: [UIColor] = []
    public var textColors: [UIColor] = []
    
    // MARK: - Actions
    public func fetchColors(completion: @escaping () -> ()) {
        apiService.request(model: ColorsModel.self) { [weak self] result in
            switch result {
                case .success(let modelColors):
                    guard let colors = modelColors else { return }
                    self?.backgroundColors = colors.colors.backgroundColors.map{ UIColor(hexString: $0)}
                    self?.textColors = colors.colors.textColors.map{ UIColor(hexString: $0)}
                    completion()
                case .failure(let error):
                    print(error)
            }
        }
    
    }
    
    public func mapColors(for mode: ColorPickerType, excludeColor: UIColor) -> [UIColor] {
        let colors: [UIColor]
        switch mode {
            case .backgroundColor:
                colors = backgroundColors.filter{ !$0.isEqual(excludeColor) }
            case .textColor:
                colors = textColors.filter{ !$0.isEqual(excludeColor) }
        }
        return colors
    }
    
    
}


