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
    private var dataSource: SecondDataSource?
    private var colors: [UIColor] = []
    var mode: ColorPickerType?    
    var selectionColorHandler: SelectionColorHandler?

    // MARK: - Outlets
    var tableView = UITableView()

    // MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.addSubview(tableView)
       // tableView.rowHeight = UITableView.automaticDimension
       // tableView.dataSource = self
        tableView.delegate = self
        //tableView.register(SecondCell.self, forCellReuseIdentifier: SecondCell.identifier)
        setConstraints()
    }
    private func setDateSource(with colors: [UIColor]) {
        self.dataSource = SecondDataSource(with: colors, tableView: self.tableView, selectionHandler: selectionColorHandler)
        self.view.addSubview(tableView)
    }
    
    // MARK: - Helper navigation
    func configure(with colors: [UIColor]) {
        self.colors = colors
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SecondCell else { return UITableViewCell() }
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let colorRow = self.colors[indexPath.row]
        self.dismiss()
        if let handler = selectionColorHandler {
            guard let handler = handler else { return }
            handler(colorRow)
          }
    }
}

extension SecondViewController {
    
    func handleColor(completion: @escaping (_ color: UIColor) -> ()) {
        selectionColorHandler = completion
    }
}
