//
//  SettingsViewController.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/24/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    // MARK: - Dependencies
    private lazy var settingsViewModel = SettingsViewModel()
    
    // MARK: - Outlets
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = .systemGray4
        label.text = "Title default"
        
        return label
    }()
    
    private lazy var oneButton: UIButton = {
        let button = UIButton.colorsSelectionButton()
        button.setTitle("Promijeni boju teksta", for: .normal)
        button.addTarget(self, action: #selector(changeTitleColor), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var secondButton: UIButton = {
        let button = UIButton.colorsSelectionButton()
        button.setTitle("Promijeni boju pozadine", for: .normal)
        button.addTarget(self, action: #selector(changeBackgroundColor), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [oneButton, secondButton])
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    // MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(titleLabel)
        self.view.addSubview(buttonsStack)
        self.view.backgroundColor = .systemGray4
        self.settingsViewModel.fetchColors { [weak self] in
            DispatchQueue.main.async {
                self?.randomiseUI()
            }
        }
        self.setupConstraints()
    }
    
    // MARK: - Actions (from view controller)
    private func randomiseUI() {
        self.view.backgroundColor = settingsViewModel.backgroundColors.randomElement()
        self.titleLabel.textColor = settingsViewModel.textColors.randomElement()
        self.oneButton.titleLabel?.textColor = settingsViewModel.textColors.randomElement()
        self.secondButton.titleLabel?.textColor = settingsViewModel.textColors.randomElement()
    }
}

extension SettingsViewController {
    @objc func changeBackgroundColor() {
        let availableColors = settingsViewModel.mapColors(for: .backgroundColor, excludeColor: self.titleLabel.textColor)
        let backgroundController = PickerViewController(colors: availableColors)
        backgroundController.registerColorHandler { [weak self] (color) in
            self?.view.backgroundColor = color
        }
        backgroundController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(backgroundController , animated: true)
    }
    
    @objc func changeTitleColor() {
        let availableColors = settingsViewModel.mapColors(for: .backgroundColor, excludeColor: self.view.backgroundColor ?? UIColor())
        let textController = PickerViewController(colors: availableColors)
        textController.registerColorHandler { [weak self] (color) in
            self?.titleLabel.textColor = color
            self?.oneButton.setTitleColor(color, for: .normal)
            self?.secondButton.setTitleColor(color, for: .normal)
        }
        textController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(textController , animated: true)
    }
}

// MARK: - Constraints
extension SettingsViewController {
    private func setupConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.65)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        self.buttonsStack.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(10)
        }
    }
}

// MARK: - Custom UIButton
fileprivate extension UIButton {
    static func colorsSelectionButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 12
        btn.backgroundColor = .systemGray2
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 21, weight: .semibold)
        btn.showsTouchWhenHighlighted = true
        
        return btn
    }
}
