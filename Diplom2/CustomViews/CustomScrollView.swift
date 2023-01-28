//
//  CustomScrollView.swift
//  Diplom2
//
//  Created by Mac on 07.01.2023.
//

import UIKit

class CustomScrollView: UIScrollView {

    lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomSubview(subView: UIView) {
        self.backView.addSubview(subView)
    }
    
}
