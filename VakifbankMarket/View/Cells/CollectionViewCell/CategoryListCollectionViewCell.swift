//
//  CategoryListCollectionViewCell.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 13.08.2024.
//

import UIKit

class CategoryListCollectionViewCell: UICollectionViewCell {
    static let reuseID = "cell"
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    lazy var categoryLabel = CustomLabels(text: "", font: .systemFont(ofSize: 16), color: .black)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI() {
        contentView.addSubviewsFromExt(imageView, categoryLabel)
        
        imageView.anchor(top: contentView.topAnchor, centerX: contentView.centerXAnchor, width: 80, height: 80)
        categoryLabel.anchor(top: imageView.bottomAnchor, centerX: contentView.centerXAnchor, paddingTop: 5)
    }
    
    func configure(with category: Category) {
        categoryLabel.text = category.text
        imageView.image = UIImage(named: category.imageName)
    }
}
