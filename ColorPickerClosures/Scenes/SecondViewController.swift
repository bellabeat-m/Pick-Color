//
//  SecondViewController.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/24/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    // MARK: - Properties
    var colors: [UIColor] = []
    var mode: ColorPickerType?    
    var selectionColorHandler: ((_ color: UIColor) -> Void)?

    // MARK: - Outlets
    var tableView = UITableView()
    
    init(colors: [UIColor]) {
        self.colors = colors
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        setConstraints()
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
    // MARK: - UITableViewDataSource & UITableViewDelegate
extension SecondViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Cell else { return UITableViewCell() }
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let colorRow = self.colors[indexPath.row]
        self.dismiss()
        if let handler = selectionColorHandler {
              handler(colorRow)
          }
    }
}
    // MARK: - Helper navigation

extension SecondViewController {
    
    func configure(with colors: [UIColor], mode: ColorPickerType, completion: @escaping (_ color: UIColor) -> ()) {
        self.colors = colors
        self.mode = mode
        selectionColorHandler = completion
    }
}

extension SecondViewController {
    
    func setConstraints()  {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
