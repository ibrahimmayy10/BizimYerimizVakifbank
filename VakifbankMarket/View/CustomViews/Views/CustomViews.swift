//
//  CustomViews.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 25.07.2024.
//

import UIKit

class CustomViews: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    convenience init(color: UIColor) {
        self.init(frame: .zero)
        set(color: color)
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func set(color: UIColor) {
       backgroundColor = color
    }

}
