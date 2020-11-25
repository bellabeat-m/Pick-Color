//
//  FirstViewController.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/24/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import UIKit
import SnapKit

enum ColorTheme {
    case background
    case text
}

class FirstViewController: UIViewController {
    
    // MARK: - Properties
    private let apiService = Service()
    private var backgrounColors = [UIColor]()
    private var textColors = [UIColor]()
    
    // MARK: - Outlets
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
      btn.setTitle("Promijeni boju teksta", for: .normal)
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
      btn.setTitle("Promijeni boju pozadine", for: .normal)
      btn.setTitleColor(.black, for: .normal)
      btn.titleLabel?.font = .systemFont(ofSize: 21, weight: .semibold)
      btn.showsTouchWhenHighlighted = true
      btn.addTarget(self, action: #selector(handleButton(_:)), for: .touchUpInside)
      
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
        setupConstraints()
        apiService.request(model: ColorsModel.self) { [weak self] result in
            switch result {
                case .success(let colors):
                guard let colors = colors else { return }
                self?.getResponseData(colors)
                self?.randomiseUI()
                
                case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getResponseData(_ response: ColorsModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = response.title
            self.backgrounColors = response.colors.backgroundColors.map{ UIColor(hexString: $0)}
            self.textColors = response.colors.textColors.map{ UIColor(hexString: $0)}
        }
    }

    private func randomiseUI() {
        DispatchQueue.main.async {
            self.view.backgroundColor = self.backgrounColors.randomElement()
            self.titleLabel.textColor = self.textColors.randomElement()
        }
    }

}

extension FirstViewController {
    @objc func handleButton(_ sender: Any) {
        guard let colorMode = sender as? ColorTheme else {fatalError()}
        let controller = SecondViewController()
        controller.colorMode = colorMode
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func pickableColors(for mode: ColorTheme) -> [UIColor] {
        let colors: [UIColor]
        switch mode {
        case .background:
            colors = backgrounColors.filter{ $0 != titleLabel.textColor}
        case .text:
            colors = textColors.filter{ $0 != view.backgroundColor}
        }
        return colors
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
