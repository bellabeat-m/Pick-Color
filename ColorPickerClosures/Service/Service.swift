//
//  Service.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/24/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import Foundation

struct Service {
    
     private (set) var config: ColorsModel? {
         didSet {
             if selectedTextColor == nil {
                 self.selectedTextColor = self.config?.colors.textColors.randomElement()
             }
             if selectedBackgroundColor == nil {
                 self.selectedBackgroundColor = self.config?.colors.backgroundColors.filter({ $0 != selectedTextColor }).randomElement()
             }
         }
     }
     
     public var selectedBackgroundColor: String?
     public var selectedTextColor: String?
     
     public var backgroundColors: [String] {
         return self.config?.colors.backgroundColors.filter({ $0 != selectedTextColor }) ?? [String]()
     }
     
     public var textColors: [String] {
         return self.config?.colors.textColors.filter({ $0 != selectedBackgroundColor }) ?? [String]()
     }

     public init() {}
    
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
