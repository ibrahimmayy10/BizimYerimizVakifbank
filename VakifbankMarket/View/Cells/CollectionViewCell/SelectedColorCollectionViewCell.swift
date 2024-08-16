//
//  SelectedColorCollectionViewCell.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 25.07.2024.
//

import UIKit

class SelectedColorCollectionViewCell: UICollectionViewCell {
    static let reuseID = "cell"
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 25
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "circle.fill")
        return image
    }()
    
    lazy var colorLabel = CustomLabels(text: "", font: .systemFont(ofSize: 18), color: .black)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(colorLabel)
        
        imageView.anchor(top: contentView.topAnchor, centerX: contentView.centerXAnchor, width: 70, height: 70)
        colorLabel.anchor(top: imageView.bottomAnchor, centerX: imageView.centerXAnchor, paddingTop: 10)
    }
}
