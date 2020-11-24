//
//  FirstViewController.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/24/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    private let client = Service()

    override func viewDidLoad() {
        super.viewDidLoad()
        client.request(model: ColorsModel.self) { result in
            switch result {
                case .success(let colors):
                print("json \(colors)")
                
                case .failure(let error):
                print(error)
            }
        }
    }

}
