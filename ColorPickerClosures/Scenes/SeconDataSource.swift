//
//  SeconDataSource.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/27/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import UIKit

class SecondDataSource: NSObject {
    
    // MARK: - Properties
    private var colors: [UIColor?] = []
    private var mode: ColorPickerType?
    private var selectionColorHandler: SelectionColorHandler?
    
    // MARK: - Init for dependency injection
    init(with colors: [UIColor], tableView: UITableView, selectionHandler: SelectionColorHandler?) {
        super.init()
        self.colors = colors
        self.selectionColorHandler = selectionHandler
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SecondCell.self, forCellReuseIdentifier: SecondCell.identifier)

    }

}

// MARK: - DataSource required
extension SecondDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let colorRow = self.colors[indexPath.row]  as? SecondCell else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SecondCell ?? UITableViewCell()
//        cell.configure(with: self.selectionColorHandler)
//        cell.configure(with: [colorRow])
        return cell
    }
}
