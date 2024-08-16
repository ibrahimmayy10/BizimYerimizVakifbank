//
//  FavoriteTableViewCell.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 31.07.2024.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    static let reuseID = "cellID"
    
    lazy var cellBarView = CustomViews(color: .white)
    lazy var cargoView = CustomViews(color: .systemGray6)
    
    lazy var favoriteImageView = CustomImageViews()
    lazy var starImageView1 = CustomImageViews()
    lazy var cargoImageView = CustomImageViews()
    
    lazy var brandLabel = CustomLabels(text: "", font: .systemFont(ofSize: 18), color: .black)
    lazy var productNameLabel = CustomLabels(text: "", font: .systemFont(ofSize: 16), color: .gray)
    lazy var pointLabel = CustomLabels(text: "9.4", font: .systemFont(ofSize: 16), color: .black)
    lazy var cargoLabel = CustomLabels(text: "Kargo Bedava", font: .systemFont(ofSize: 9), color: .black)
    lazy var priceLabel = CustomLabels(text: "", font: .systemFont(ofSize: 18), color: .systemYellow)
    
    lazy var addBasketButton = CustomButtons(title: "Sepete Ekle", textColor: .white, buttonColor: .systemYellow, radius: 10, imageName: "", buttonTintColor: .white)
    lazy var buyNowButton = CustomButtons(title: "Şimdi Al", textColor: .systemYellow, buttonColor: .white, radius: 10, imageName: "", buttonTintColor: .white)
    
    weak var delegate: FavoriteTableViewCellDelegate?
    
    var product: ProductModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageViewSettings()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        imageViewSettings()
        configureTableView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func addBasketButtonClicked() {
        guard let product = product else { return }
        delegate?.didTapAddBasketButton(product: product)
    }
    
    @objc func buyNowButtonClicked() {
        guard let product = product else { return }
        delegate?.didTapBuyNowButton(product: product)
    }
    
    func imageViewSettings() {
        starImageView1.image = UIImage(systemName: "heart.fill")
        starImageView1.tintColor = .systemOrange
        
        cargoImageView.image = UIImage(systemName: "shippingbox.fill")
        cargoImageView.tintColor = .darkGray
        cargoLabel.numberOfLines = 2
        cargoImageView.contentMode = .scaleAspectFit
        
        cargoLabel.textAlignment = .center
    }
    
    func configureTableView() {
        contentView.addSubview(cellBarView)
        cellBarView.addSubviewsFromExt(favoriteImageView, brandLabel, productNameLabel, addBasketButton, starImageView1, buyNowButton, pointLabel, cargoView, priceLabel)
        cargoView.addSubviewsFromExt(cargoImageView, cargoLabel)
        
        contentView.backgroundColor = .white
        
        cellBarView.layer.cornerRadius = 10
        cellBarView.layer.shadowColor = UIColor.black.cgColor
        cellBarView.layer.shadowOpacity = 0.2
        cellBarView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cellBarView.layer.shadowRadius = 5
        cellBarView.backgroundColor = .white
        
        cargoView.layer.cornerRadius = 5
        
        buyNowButton.layer.borderWidth = 1
        buyNowButton.layer.borderColor = UIColor.systemYellow.cgColor
        
        favoriteImageView.contentMode = .scaleAspectFill
        favoriteImageView.layer.cornerRadius = 10
        favoriteImageView.clipsToBounds = true
        
        cellBarView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, bottom: contentView.bottomAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, paddingBottom: 10)
        
        favoriteImageView.anchor(top: cellBarView.topAnchor, left: cellBarView.leftAnchor, bottom: cellBarView.bottomAnchor, width: 120)
        brandLabel.anchor(top: cellBarView.topAnchor, left: favoriteImageView.rightAnchor, paddingTop: 10, paddingLeft: 10)
        productNameLabel.anchor(top: cellBarView.topAnchor, left: brandLabel.rightAnchor, right: cellBarView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingRight: 5)
        
        pointLabel.anchor(top: brandLabel.bottomAnchor, left: favoriteImageView.rightAnchor, paddingTop: 5, paddingLeft: 10)
        starImageView1.anchor(top: brandLabel.bottomAnchor, left: pointLabel.rightAnchor, paddingTop: 5, paddingLeft: 5)
        
        cargoView.anchor(top: pointLabel.bottomAnchor, left: favoriteImageView.rightAnchor, paddingTop: 10, paddingLeft: 10, width: 40, height: 55)
        cargoImageView.anchor(top: cargoView.topAnchor, left: cargoView.leftAnchor, right: cargoView.rightAnchor, paddingTop: 2, paddingLeft: 2, paddingRight: 2)
        cargoLabel.anchor(top: cargoImageView.bottomAnchor, left: cargoView.leftAnchor, right: cargoView.rightAnchor, bottom: cargoView.bottomAnchor, paddingTop: 2, paddingLeft: 2, paddingRight: 2, paddingBottom: 2)
        
        priceLabel.anchor(left: favoriteImageView.rightAnchor, bottom: addBasketButton.topAnchor, paddingLeft: 10, paddingBottom: 5)
        
        addBasketButton.anchor(right: cellBarView.rightAnchor, bottom: cellBarView.bottomAnchor, paddingRight: 5, paddingBottom: 10, width: 120)
        buyNowButton.anchor(right: addBasketButton.leftAnchor, bottom: cellBarView.bottomAnchor, paddingTop: 10, paddingRight: 5, paddingBottom: 10, width: 100)
    }
    
    func configure(product: ProductModel, indexPath: IndexPath) {
        favoriteImageView.sd_setImage(with: URL(string: product.imageUrls.first ?? ""))
        brandLabel.text = product.brand
        productNameLabel.text = product.productName
        
        pointLabel.text = "(\(String(product.likes.count)))"
        
        let price = product.price
        
        if price.truncatingRemainder(dividingBy: 1) == 0 {
            priceLabel.text = "\(Int(price)) TL"
        } else {
            priceLabel.text = String(format: "%.2f TL", price)
        }
        
        self.product = product
        addBasketButton.addTarget(self, action: #selector(addBasketButtonClicked), for: .touchUpInside)
        buyNowButton.addTarget(self, action: #selector(buyNowButtonClicked), for: .touchUpInside)
    }

}
