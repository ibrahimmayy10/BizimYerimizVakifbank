//
//  ActivityIndicators.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 25.07.2024.
//

import UIKit

class ActivityIndicators: UIActivityIndicatorView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(indicatorColor: UIColor) {
        self.init(frame: .zero)
        set(indicatorColor: indicatorColor)
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func set(indicatorColor: UIColor) {
       color = indicatorColor
    }

}
