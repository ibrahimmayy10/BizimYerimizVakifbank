//
//  CartTableViewCell.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 1.08.2024.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    static let reuseID = "cellID"
    
    lazy var cartImageView = CustomImageViews()
    
    lazy var brandLabel = CustomLabels(text: "", font: .systemFont(ofSize: 18), color: .black)
    lazy var productNameLabel = CustomLabels(text: "", font: .systemFont(ofSize: 16), color: .gray)
    lazy var priceLabel = CustomLabels(text: "", font: .systemFont(ofSize: 18), color: .systemYellow)
    
    lazy var minusButton = CustomButtons(title: "", textColor: .white, buttonColor: .systemYellow, radius: 10, imageName: "minus", buttonTintColor: .white)
    lazy var plusButton = CustomButtons(title: "", textColor: .white, buttonColor: .systemYellow, radius: 10, imageName: "plus", buttonTintColor: .white)
    
    lazy var productPieceLabel = CustomLabels(text: "1", font: .boldSystemFont(ofSize: 18), color: .systemYellow)
    
    var quantityChanged: ((Int) -> Void)?
    
    var quantity: Int = 1 {
        didSet {
            productPieceLabel.text = "\(quantity)"
            quantityChanged?(quantity)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTableViewCell()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupActions() {
        minusButton.addTarget(self, action: #selector(minusButtonClicked), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
    }
    
    @objc func minusButtonClicked() {
        if quantity > 1 {
            quantity -= 1
        }
    }
    
    @objc func plusButtonClicked() {
        quantity += 1
    }
    
    func configureTableViewCell() {
        contentView.addSubviewsFromExt(cartImageView, brandLabel, productNameLabel, minusButton, plusButton, productPieceLabel, priceLabel)
        
        contentView.backgroundColor = .white
        
        productNameLabel.numberOfLines = 0
        
        cartImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, width: 100)
        brandLabel.anchor(top: contentView.topAnchor, left: cartImageView.rightAnchor, paddingTop: 10, paddingLeft: 10)
        productNameLabel.anchor(top: contentView.topAnchor, left: brandLabel.rightAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingRight: 10)
        
        minusButton.anchor(left: cartImageView.rightAnchor, bottom: contentView.bottomAnchor, paddingLeft: 20, paddingBottom: 20, width: 20, height: 20)
        productPieceLabel.anchor(left: minusButton.rightAnchor, bottom: contentView.bottomAnchor, paddingLeft: 10, paddingBottom: 20, height: 20)
        plusButton.anchor(left: productPieceLabel.rightAnchor, bottom: contentView.bottomAnchor, paddingLeft: 10, paddingBottom: 20, width: 20, height: 20)
        
        priceLabel.anchor(right: contentView.rightAnchor, bottom: contentView.bottomAnchor, paddingRight: 10, paddingBottom: 20, height: 20)
    }
    
    func configure(product: ProductModel) {
        cartImageView.sd_setImage(with: URL(string: product.imageUrls.first ?? ""))
        brandLabel.text = product.brand
        productNameLabel.text = product.productName
        priceLabel.text = String(format: "%.2f TL", product.price)
    }

}
