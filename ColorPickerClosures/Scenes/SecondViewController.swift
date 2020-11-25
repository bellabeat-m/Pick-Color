//
//  SecondViewController.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/24/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var tableView = UITableView()
    var colorMode: ColorTheme!
    var colors: [UIColor] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        setConstraints()
    }
}

extension SecondViewController {
    
    func setConstraints()  {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension SecondViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Cell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let color = colors[indexPath.row]
        navigationController?.popViewController(animated: true)
        //delegate?.colorPickerViewController(self, didSelectColor: color)
    }
}
