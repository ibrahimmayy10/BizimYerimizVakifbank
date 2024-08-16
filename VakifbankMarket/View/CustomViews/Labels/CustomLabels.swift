//
//  LoginLabel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 23.07.2024.
//

import UIKit

class CustomLabels: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    convenience init(text: String, font: UIFont, color: UIColor) {
        self.init(frame: .zero)
        set(textLabel: text, labelFont: font, color: color)
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func set(textLabel: String, labelFont: UIFont, color: UIColor) {
        text = textLabel
        font = labelFont
        textColor = color
    }

}
