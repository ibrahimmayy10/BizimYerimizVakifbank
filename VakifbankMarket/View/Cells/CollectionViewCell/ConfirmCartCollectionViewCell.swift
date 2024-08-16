//
//  ConfirmCartCollectionViewCell.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 5.08.2024.
//

import UIKit

class ConfirmCartCollectionViewCell: UICollectionViewCell {
    static let reuseID = "cell"
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var priceLabel = CustomLabels(text: "", font: .boldSystemFont(ofSize: 14), color: .systemYellow)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI() {
        contentView.addSubviewsFromExt(imageView, priceLabel)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.backgroundColor = .white
                
        imageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 150)
        priceLabel.anchor(top: imageView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 10)
    }
    
    func configure(with product: ProductModel) {
        priceLabel.text = "\(product.price) TL"
        
        if let imageUrlString = product.imageUrls.first, let imageUrl = URL(string: imageUrlString) {
            imageView.sd_setImage(with: imageUrl)
        }
    }
}
