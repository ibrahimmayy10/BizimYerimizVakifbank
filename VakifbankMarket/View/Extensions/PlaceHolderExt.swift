//
//  PlaceHolderExt.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 30.07.2024.
//

import UIKit

extension UITextView {
    func addPlaceholder(_ placeholder: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = self.font
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        self.addSubview(placeholderLabel)
    }
    
    func removePlaceholder() {
        if let viewWithTag = self.viewWithTag(222) {
            viewWithTag.removeFromSuperview()
        }
    }
}
