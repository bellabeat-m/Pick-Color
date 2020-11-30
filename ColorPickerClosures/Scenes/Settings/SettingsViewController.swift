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
    private var apiService = Service()
    private lazy var settingsViewModel = SettingsViewModel(apiService: apiService)
    
    // MARK: - Outlets
    private lazy var titleLabel: UILabel = {
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
    
    private lazy var oneButton: UIButton = {
        let btn = UIButton.colorsSelectionButton()
        btn.setTitle("Promijeni boju teksta", for: .normal)
        btn.addTarget(self, action: #selector(changeTitleColor), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var secondButton: UIButton = {
        let btn = UIButton.colorsSelectionButton()
        btn.setTitle("Promijeni boju pozadine", for: .normal)
        btn.addTarget(self, action: #selector(changeBackgroundColor), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var buttonsStack: UIStackView = {
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
        settingsViewModel.fetchColors { [weak self] in
            DispatchQueue.main.async {
                self?.randomiseUI()
            }
        }
        setupConstraints()
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
