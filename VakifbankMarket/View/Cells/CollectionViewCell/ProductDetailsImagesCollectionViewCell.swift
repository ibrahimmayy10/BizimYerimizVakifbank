//
//  ProductDetailsImagesCollectionViewCell.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 28.07.2024.
//

import UIKit
import SDWebImage

class ProductDetailsImagesCollectionViewCell: UICollectionViewCell {
    static let reuseID = "detailsCell"
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
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
        
        imageView.anchor(top: contentView.topAnchor, centerX: contentView.centerXAnchor, paddingBottom: 5, width: contentView.bounds.size.width, height: 500)
    }
    
    func configure(product: ProductModel, indexPath: IndexPath) {
        imageView.sd_setImage(with: URL(string: product.imageUrls[indexPath.row]))
    }
}
