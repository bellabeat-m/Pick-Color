//
//  Service.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/24/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import UIKit

struct Service {
    
     public var backgroundColors: [UIColor] = []
     public var textColors: [UIColor] = []

     public init() {}
    
     func pickedColors(for mode: ColorPickerType, excludeColor: UIColor) -> [UIColor] {
        let colors: [UIColor]
        switch mode {
        case .backgroundColor:
            colors = backgroundColors.filter{ !$0.isEqual(excludeColor) }
        case .textColor:
            colors = textColors.filter{ !$0.isEqual(excludeColor) }
        }
        return colors
    }
    
    mutating func configure(_ data: ColorsModel) {
        backgroundColors = data.colors.backgroundColors.map{ UIColor(hexString: $0)}
        textColors = data.colors.textColors.map{ UIColor(hexString: $0)}
    }

    
    func request<T: Decodable>( model: T.Type, completion: @escaping (Result<T?, ServiceError>) -> ()) {
        
        let url = URL(string: "https://d2t41j3b4bctaz.cloudfront.net/interview.json")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            
            if let _ = error {
                completion(.failure(.responseError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.responseError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.responseError))
                return
            }
            do {
                let decoder                     = JSONDecoder()
                decoder.keyDecodingStrategy     = .convertFromSnakeCase
                decoder.dateDecodingStrategy    = .iso8601
                let model                       = try decoder.decode(T.self, from: data)
                
                completion(.success(model))
            } catch {
                completion(.failure(.parseError(error)))
            }
        }
        task.resume()
    }
    
}
