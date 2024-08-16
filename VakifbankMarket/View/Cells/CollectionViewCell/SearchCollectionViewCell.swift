//
//  SearchCollectionViewCell.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 2.08.2024.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    static let reuseID = "cell"
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var brandLabel = CustomLabels(text: "", font: .systemFont(ofSize: 10), color: .black)
    lazy var productNameLabel = CustomLabels(text: "", font: .systemFont(ofSize: 10), color: .darkGray)
    lazy var priceLabel = CustomLabels(text: "", font: .boldSystemFont(ofSize: 10), color: .systemYellow)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI() {
        contentView.addSubviewsFromExt(imageView, brandLabel, productNameLabel, priceLabel)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.backgroundColor = .white
        
        productNameLabel.numberOfLines = 2
        
        imageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 100)
        brandLabel.anchor(top: imageView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 5, paddingLeft: 5)
        productNameLabel.anchor(top: brandLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 3, paddingLeft: 5, paddingRight: 5)
        priceLabel.anchor(top: productNameLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 3, paddingLeft: 5)
    }
    
    func configure(with product: ProductModel) {
        brandLabel.text = product.brand
        productNameLabel.text = product.productName
        priceLabel.text = "\(product.price) TL"
        
        if let imageUrlString = product.imageUrls.first, let imageUrl = URL(string: imageUrlString) {
            imageView.sd_setImage(with: imageUrl)
        }
    }
}
