//
//  SecondViewController.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/24/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import UIKit
import SnapKit

class PickerViewController: UIViewController {
    
    // MARK: - Properties exposed for view controller
    private let colors: [UIColor]
    private var selectionColorHandler: ((_ color: UIColor) -> Void)?

    // MARK: - Outlets
    private var tableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: - Initializers
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
        self.tableView.rowHeight  = UITableView.automaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate   = self
        self.tableView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        self.setConstraints()
    }
    
    func registerColorHandler(completion: @escaping (_ color: UIColor) -> ()) {
        self.selectionColorHandler = completion
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension PickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Cell else { return UITableViewCell() }
        cell.backgroundColor = self.colors[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let colorRow = self.colors[indexPath.row]
        self.dismiss(animated: true, completion: nil)
        self.selectionColorHandler?(colorRow)
    }
}

// MARK: - Constraints
extension PickerViewController {
    func setConstraints()  {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
