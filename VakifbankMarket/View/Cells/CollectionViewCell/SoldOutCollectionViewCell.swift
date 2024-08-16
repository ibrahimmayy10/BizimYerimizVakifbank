//
//  SoldOutCollectionViewCell.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 10.08.2024.
//

import UIKit

class SoldOutCollectionViewCell: UICollectionViewCell {
    static let reuseID = "soldOutCellID"
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .systemOrange
        return imageView
    }()
    
    lazy var brandLabel = CustomLabels(text: "", font: .systemFont(ofSize: 14, weight: .bold), color: .black)
    lazy var productNameLabel = CustomLabels(text: "", font: .systemFont(ofSize: 14), color: .darkGray)
    lazy var priceLabel = CustomLabels(text: "", font: .systemFont(ofSize: 14, weight: .semibold), color: .systemYellow)
    lazy var favoriteLabel = CustomLabels(text: "", font: .systemFont(ofSize: 14), color: .darkGray)
    
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
        
        imageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 150)
        brandLabel.anchor(top: imageView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        productNameLabel.anchor(top: brandLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, width: contentView.bounds.size.width * 0.95)
        heartImageView.anchor(top: productNameLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 5, paddingLeft: 10, width: 20, height: 20)
        favoriteLabel.anchor(left: heartImageView.rightAnchor, centerY: heartImageView.centerYAnchor, paddingLeft: 5)
        priceLabel.anchor(top: heartImageView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 10)
    }
    
    func configure(with product: ProductModel) {
        brandLabel.text = product.brand
        productNameLabel.text = product.productName
        priceLabel.text = "\(product.price) TL"
        favoriteLabel.text = "(\(product.likes.count))"
        
        if let imageUrlString = product.imageUrls.first, let imageUrl = URL(string: imageUrlString) {
            imageView.sd_setImage(with: imageUrl)
        }
    }
}
