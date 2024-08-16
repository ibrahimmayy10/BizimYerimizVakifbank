//
//  HomePageAllCategoriesCollectionViewCell.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 28.07.2024.
//

import UIKit

class HomePageAllCategoriesCollectionViewCell: UICollectionViewCell {
    static let reuseID = "cellID"
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.image = UIImage(named: "categories")
        return image
    }()
    
    lazy var allCategoryLabel = CustomLabels(text: "Kategoriler", font: .systemFont(ofSize: 16), color: .black)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI() {
        contentView.addSubviewsFromExt(imageView, allCategoryLabel)
        
        imageView.anchor(top: contentView.topAnchor, centerX: contentView.centerXAnchor, width: 80, height: 80)
        allCategoryLabel.anchor(top: imageView.bottomAnchor, centerX: contentView.centerXAnchor, paddingTop: 5)
    }
}
