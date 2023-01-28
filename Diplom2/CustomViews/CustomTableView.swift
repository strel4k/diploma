//
//  CustomTableView.swift
//  Diplom2
//
//  Created by Mac on 08.01.2023.
//

import UIKit

class CustomTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        
        super.init(frame: frame, style: style)
        
        self.backgroundColor = ColorSet.colorLight
        
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 44
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
