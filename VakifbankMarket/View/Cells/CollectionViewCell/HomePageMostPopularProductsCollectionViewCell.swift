//
//  HomePageMostPopularProductsCollectionViewCell.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 29.07.2024.
//

import UIKit

class HomePageMostPopularProductsCollectionViewCell: UICollectionViewCell {
    static let reuseID = "cell"
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var heartImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "heart.fill")
        image.contentMode = .scaleToFill
        image.tintColor = .systemOrange
        return image
    }()
    
    lazy var brandLabel = CustomLabels(text: "", font: .systemFont(ofSize: 14), color: .black)
    lazy var productNameLabel = CustomLabels(text: "", font: .systemFont(ofSize: 14), color: .darkGray)
    lazy var priceLabel = CustomLabels(text: "", font: .boldSystemFont(ofSize: 14), color: .systemYellow)
    lazy var favoriteLabel = CustomLabels(text: "(35) kişi favoriledi", font: .systemFont(ofSize: 14), color: .black)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI() {
        contentView.addSubviewsFromExt(imageView, brandLabel, productNameLabel, priceLabel, heartImageView, favoriteLabel)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.backgroundColor = .white
        
        productNameLabel.numberOfLines = 2
        
        imageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 200)
        brandLabel.anchor(top: imageView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        productNameLabel.anchor(top: brandLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10)
        heartImageView.anchor(top: productNameLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 5, paddingLeft: 10, width: 20, height: 20)
        favoriteLabel.anchor(left: heartImageView.rightAnchor, centerY: heartImageView.centerYAnchor, paddingLeft: 5)
        priceLabel.anchor(top: heartImageView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 10)
    }
    
    func configure(with product: ProductModel) {
        brandLabel.text = product.brand
        productNameLabel.text = product.productName
        priceLabel.text = "\(product.price) TL"
        
        favoriteLabel.text = "(\(product.likes.count)) kişi favoriledi"
        
        if let imageUrlString = product.imageUrls.first, let imageUrl = URL(string: imageUrlString) {
            imageView.sd_setImage(with: imageUrl)
        }
    }
}
