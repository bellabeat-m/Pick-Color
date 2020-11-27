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
    private var backgroundController: SecondViewController?
    private var textController: SecondViewController?
    
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

// MARK: - UIViewController Dependency Injection

extension FirstViewController {
    
    @objc func handleButtonPressed(_ sender: UIButton) {
        let backgroundPressed = sender == secondButton
        let textPressed = sender == oneButton
        backgroundController = SecondViewController(colors: apiService.backgroundColors)
        textController = SecondViewController(colors: apiService.textColors)
        if textPressed {
            textController?.configure(with: apiService.pickedColors(for: .textColor, excludeColor: self.view.backgroundColor ?? UIColor()), mode: .textColor, completion: { (color) in
                switch self.textController?.mode {
                    case .backgroundColor: break
                    case .textColor:
                        self.titleLabel.textColor = color
                        self.oneButton.setTitleColor(color, for: .normal)
                        self.secondButton.setTitleColor(color, for: .normal)
                    case .none: break
                }
            })
            textController?.modalPresentationStyle = .fullScreen
            navigationController?.present(textController ?? UIViewController(), animated: true)
            
        } else if backgroundPressed {
            backgroundController?.configure(with: apiService.pickedColors(for: .backgroundColor, excludeColor: self.titleLabel.textColor), mode: .backgroundColor, completion: { (color) in
                switch self.backgroundController?.mode {
                    case .backgroundColor:
                        self.view.backgroundColor = color
                    case .textColor: break
                    case .none: break
                }
            })
            backgroundController?.modalPresentationStyle = .fullScreen
            navigationController?.present(backgroundController ?? UIViewController(), animated: true)
        }
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
