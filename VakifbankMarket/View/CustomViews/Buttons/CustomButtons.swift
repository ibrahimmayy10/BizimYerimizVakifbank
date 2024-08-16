//
//  CustomButtons.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 24.07.2024.
//

import UIKit

class CustomButtons: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    convenience init(title: String, textColor: UIColor, buttonColor: UIColor, radius: CGFloat, imageName: String, buttonTintColor: UIColor) {
        self.init(frame: .zero)
        set(title: title, textColor: textColor, buttonColor: buttonColor, radius: radius, imageName: imageName, buttonTintColor: buttonTintColor)
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func set(title: String, textColor: UIColor, buttonColor: UIColor, radius: CGFloat, imageName: String?, buttonTintColor: UIColor) {
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        setImage(UIImage(systemName: imageName ?? ""), for: .normal)
        tintColor = buttonTintColor
        backgroundColor = buttonColor
        layer.cornerRadius = radius
    }

}
