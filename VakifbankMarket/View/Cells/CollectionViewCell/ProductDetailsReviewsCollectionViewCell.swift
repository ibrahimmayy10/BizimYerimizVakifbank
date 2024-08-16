//
//  ProductDetailsReviewsCollectionViewCell.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 29.07.2024.
//

import UIKit

class ProductDetailsReviewsCollectionViewCell: UICollectionViewCell {
    static let reuseID = "reviewsCell"
    
    lazy var cellBarView = CustomViews(color: .white)
    
    lazy var starImageView1 = CustomImageViews()
    lazy var starImageView2 = CustomImageViews()
    lazy var starImageView3 = CustomImageViews()
    lazy var starImageView4 = CustomImageViews()
    lazy var starImageView5 = CustomImageViews()
    
    lazy var nameLabel = CustomLabels(text: "İbrahim Ay", font: .systemFont(ofSize: 14), color: .gray)
    lazy var commentLabel = CustomLabels(text: "Ürün çok güzel", font: .systemFont(ofSize: 16), color: .black)
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starImageView1, starImageView2, starImageView3, starImageView4, starImageView5])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI() {
        contentView.addSubview(cellBarView)
        cellBarView.addSubviewsFromExt(stackView, nameLabel, commentLabel)
        
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        
        cellBarView.layer.cornerRadius = 5
        cellBarView.layer.shadowColor = UIColor.black.cgColor
        cellBarView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cellBarView.layer.shadowOpacity = 0.2
        cellBarView.layer.shadowRadius = 5
        
        starImageView1.image = UIImage(systemName: "star.fill")
        starImageView1.tintColor = .systemGray6
        
        starImageView2.image = UIImage(systemName: "star.fill")
        starImageView2.tintColor = .systemGray6
        
        starImageView3.image = UIImage(systemName: "star.fill")
        starImageView3.tintColor = .systemGray6
        
        starImageView4.image = UIImage(systemName: "star.fill")
        starImageView4.tintColor = .systemGray6
        
        starImageView5.image = UIImage(systemName: "star.fill")
        starImageView5.tintColor = .systemGray6
        
        cellBarView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, bottom: contentView.bottomAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, paddingBottom: 10)
        
        stackView.anchor(top: cellBarView.topAnchor, left: cellBarView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        nameLabel.anchor(top: stackView.bottomAnchor, left: cellBarView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        commentLabel.anchor(top: nameLabel.bottomAnchor, left: cellBarView.leftAnchor, paddingTop: 10, paddingLeft: 10)
    }
    
    func configure(evaluate: EvaluateModel) {
        nameLabel.text = evaluate.name
        commentLabel.text = evaluate.comment
        
        switch evaluate.point {
        case 1: starImageView1.tintColor = .systemYellow
        case 2:
            starImageView1.tintColor = .systemYellow
            starImageView2.tintColor = .systemYellow
        case 3:
            starImageView1.tintColor = .systemYellow
            starImageView2.tintColor = .systemYellow
            starImageView3.tintColor = .systemYellow
        case 4:
            starImageView1.tintColor = .systemYellow
            starImageView2.tintColor = .systemYellow
            starImageView3.tintColor = .systemYellow
            starImageView4.tintColor = .systemYellow
        case 5:
            starImageView1.tintColor = .systemYellow
            starImageView2.tintColor = .systemYellow
            starImageView3.tintColor = .systemYellow
            starImageView4.tintColor = .systemYellow
            starImageView5.tintColor = .systemYellow
        default:
            print("")
        }
    }
    
}
