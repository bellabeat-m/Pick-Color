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
    
    // MARK: - Properties
    private var apiService = Service()
    
    // MARK: - Outlets
    lazy var titleLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        lbl.textColor = .systemGray4
        lbl.text = "Title default"
        
        view.addSubview(lbl)
        
        return lbl
    }()
    
    lazy var oneButton: UIButton = {
      let btn = UIButton(type: .custom)
      btn.layer.cornerRadius = 12
      btn.backgroundColor = .systemGray4
      btn.setTitle("Promijeni boju teksta", for: .normal)
      btn.setTitleColor(.black, for: .normal)
      btn.titleLabel?.font = .systemFont(ofSize: 21, weight: .semibold)
      btn.showsTouchWhenHighlighted = true
      btn.addTarget(self, action: #selector(handleButtonPressed(_:)), for: .touchUpInside)
      
      return btn
    }()
    
    lazy var secondButton: UIButton = {
      let btn = UIButton(type: .custom)
      btn.layer.cornerRadius = 12
      btn.backgroundColor = .systemGray4
      btn.setTitle("Promijeni boju pozadine", for: .normal)
      btn.setTitleColor(.black, for: .normal)
      btn.titleLabel?.font = .systemFont(ofSize: 21, weight: .semibold)
      btn.showsTouchWhenHighlighted = true
        btn.addTarget(self, action: #selector(handleButtonPressed(_:)), for: .touchUpInside)
      
      return btn
    }()
    
    lazy var buttonsStack: UIStackView = {
      let stackView = UIStackView(arrangedSubviews: [oneButton, secondButton])
      stackView.alignment = .fill
      stackView.spacing = 20
      stackView.axis = .vertical
      stackView.distribution = .fillEqually
      
      view.addSubview(stackView)
      
      return stackView
    }()
    
    // MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray4
        getData()
        setupConstraints()
    }
    
    private func getData() {
        apiService.request(model: ColorsModel.self) { [weak self] result in
            switch result {
                case .success(let colors):
                    guard let colors = colors else { return }
                    
                    self?.apiService.configure(colors)
                    DispatchQueue.main.async {
                        self?.randomiseUI()
                }
                case .failure(let error):
                    print(error)
            }
        }
    }

    private func randomiseUI() {
        self.view.backgroundColor = apiService.backgroundColors.randomElement()
        self.titleLabel.textColor = apiService.textColors.randomElement()
        self.oneButton.titleLabel?.textColor = apiService.textColors.randomElement()
        self.secondButton.titleLabel?.textColor = apiService.textColors.randomElement()
    }
}

extension FirstViewController {
    
    @objc func handleButtonPressed(_ sender: UIButton) {
        let backgroundPressed = sender == secondButton
        let textPressed = sender == oneButton
        let controller = SecondViewController()
        controller.handleColor { (color) in
            switch controller.mode {
                case .backgroundColor:
                    self.view.backgroundColor = color
                case .textColor:
                    self.titleLabel.textColor = color
                    self.oneButton.titleLabel?.textColor = color
                    self.secondButton.titleLabel?.textColor = color
                case .none: break    
            }
        }
        if textPressed {
            controller.colors = apiService.pickedColors(for: .textColor, color: self.titleLabel.textColor)
            controller.mode = .textColor
            
        } else if backgroundPressed {
            controller.colors = apiService.pickedColors(for: .backgroundColor, color: self.view.backgroundColor ?? UIColor())
            controller.mode = .backgroundColor
            
        }
        controller.modalPresentationStyle = .fullScreen
        navigationController?.present(controller, animated: true)
        
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
    }
}
