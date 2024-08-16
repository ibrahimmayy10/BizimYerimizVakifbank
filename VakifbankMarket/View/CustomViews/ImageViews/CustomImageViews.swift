//
//  CustomImageViews.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 29.07.2024.
//

import UIKit

class CustomImageViews: UIImageView {

    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    }

}
