//
//  LoginTextField.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 23.07.2024.
//

import UIKit

class CustomTextFields: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    convenience init(isSecureText: Bool, text: String) {
        self.init(frame: .zero)
        set(isSecureText: isSecureText, text: text)
    }
    
    func configure() {
        borderStyle = .none
        textColor = .black
        autocapitalizationType = .none
        autocorrectionType = .no
    }
    
    private func set(isSecureText: Bool, text: String) {
        isSecureTextEntry = isSecureText
        placeholder = text
    }

}
