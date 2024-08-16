//
//  CustomTextViews.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 30.07.2024.
//

import UIKit

class CustomTextViews: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .black
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 5
        font = UIFont.systemFont(ofSize: 17)
    }

}
