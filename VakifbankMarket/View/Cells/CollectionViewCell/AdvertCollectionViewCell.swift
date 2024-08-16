//
//  AdvertCollectionViewCell.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 13.08.2024.
//

import UIKit

class AdvertCollectionViewCell: UICollectionViewCell {
    static let reuseID = "cell"
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI() {
        contentView.addSubviewsFromExt(imageView)
        
        imageView.anchor(top: contentView.topAnchor, centerX: contentView.centerXAnchor, width: contentView.bounds.size.width, height: 135)
    }
    
    func configure(with design: Advert) {
        imageView.image = UIImage(named: design.imageName)
    }
}
