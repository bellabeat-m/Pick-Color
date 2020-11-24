//
//  FirstViewController.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/24/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import UIKit
import SnapKit

class FirstViewController: UIViewController {
    
    private let client = Service()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        lbl.textColor = .black
        lbl.text = "Title default"
        
        view.addSubview(lbl)
        
        return lbl
    }()
    
    lazy var oneButton: UIButton = {
      let btn = UIButton(type: .custom)
      btn.layer.cornerRadius = 12
      btn.backgroundColor = .white
      btn.setTitle("change background", for: .normal)
      btn.setTitleColor(.black, for: .normal)
      btn.titleLabel?.font = .systemFont(ofSize: 21, weight: .semibold)
      btn.showsTouchWhenHighlighted = true
      btn.addTarget(self, action: #selector(handleButton(_:)), for: .touchUpInside)
      
      return btn
    }()
    
    lazy var secondButton: UIButton = {
      let btn = UIButton(type: .custom)
      btn.layer.cornerRadius = 12
      btn.backgroundColor = .white
      btn.setTitle("set color", for: .normal)
      btn.setTitleColor(.black, for: .normal)
      btn.titleLabel?.font = .systemFont(ofSize: 21, weight: .semibold)
      btn.showsTouchWhenHighlighted = true
      btn.addTarget(self, action: #selector(handleButton(_:)), for: .touchUpInside)
      
      return btn
    }()
    
    lazy var buttonsStack: UIStackView = {
      let stackView = UIStackView(arrangedSubviews: [oneButton, secondButton])
      stackView.alignment = .center
      stackView.spacing = 20
      stackView.axis = .vertical
      stackView.distribution = .fillEqually
      
      view.addSubview(stackView)
      
      return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray4
        setupConstraints()
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

extension FirstViewController {
    @objc func handleButton(_ sender: UIButton) {
    }
}

extension FirstViewController {
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.65)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(10)
            }
            
            buttonsStack.snp.makeConstraints { make in
                make.left.right.equalTo(view.safeAreaLayoutGuide).inset(10)
                make.top.equalTo(titleLabel.snp.bottom).offset(80)
                make.height.equalTo(100)
        }
    }
}
