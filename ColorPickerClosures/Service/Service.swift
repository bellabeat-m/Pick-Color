//
//  Service.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/24/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import UIKit

struct Service {
    // MARK: - Properties
     static let apiUrl = "https://d2t41j3b4bctaz.cloudfront.net/interview.json"
    
    // MARK: - Initializer
     public init() {}
    
    // MARK: - Requests
    func request<T: Decodable>(model: T.Type, completion: @escaping (Result<T?, ServiceError>) -> ()) {
        
        guard let urlFinal = URL(string: Service.apiUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: urlFinal) { data, response, error in
            
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
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let model = try decoder.decode(T.self, from: data)
                
                completion(.success(model))
            } catch {
                completion(.failure(.parseError(error)))
            }
        }
        task.resume()
    }
    
}
