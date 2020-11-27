//
//  SecondCell.swift
//  ColorPickerClosures
//
//  Created by Marina Huber on 11/24/20.
//  Copyright © 2020 Marina Huber. All rights reserved.
//

import UIKit

typealias SelectionColorHandler = ((_ color: UIColor) -> Void)?

class SecondCell: UITableViewCell {
    
    static var identifier = "Cell"
    private var selectionHandler: SelectionColorHandler?
    private var data: ColorsModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Configuration for data injection
    internal func configure(with data: ColorsModel?, selectionHandler: SelectionColorHandler?) {
        self.data = data
        self.selectionHandler = selectionHandler

    }
    
}
