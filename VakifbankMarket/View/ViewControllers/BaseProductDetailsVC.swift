//
//  BaseProductDetailsVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 31.07.2024.
//

import UIKit

class BaseProductDetailsVC: UIViewController {
    
    lazy var brandLabel = CustomLabels(text: "", font: .boldSystemFont(ofSize: 16), color: .systemBlue)
    lazy var productNameLabel = CustomLabels(text: "", font: .systemFont(ofSize: 16), color: .systemGray2)
    lazy var pointLabel1 = CustomLabels(text: "4.4", font: .boldSystemFont(ofSize: 16), color: .black)
    lazy var pointLabel2 = CustomLabels(text: "4.4", font: .boldSystemFont(ofSize: 18), color: .black)
    lazy var evaluationLabel = CustomLabels(text: "", font: .systemFont(ofSize: 16), color: .black)
    lazy var deliveryLabel = CustomLabels(text: "Tahmini kargoya teslim: 3 gün içinde", font: .systemFont(ofSize: 15), color: .gray)
    lazy var campaignLabel = CustomLabels(text: "Ürünün Kampanyaları", font: .systemFont(ofSize: 18), color: .black)
    lazy var cargoLabel = CustomLabels(text: "200 TL ve Üzeri Kargo Bedava", font: .systemFont(ofSize: 16), color: .black)
    
    lazy var productFeaturesLabel = CustomLabels(text: "Ürün Özellikleri", font: .systemFont(ofSize: 18), color: .black)
    lazy var productBrandHeaderLabel = CustomLabels(text: "Marka", font: .systemFont(ofSize: 14), color: .systemOrange)
    lazy var productColorHeaderLabel = CustomLabels(text: "Renk", font: .systemFont(ofSize: 14), color: .systemOrange)
    lazy var productCategoryHeaderLabel = CustomLabels(text: "Kategori", font: .systemFont(ofSize: 14), color: .systemOrange)
    lazy var productBrandLabel = CustomLabels(text: "", font: .systemFont(ofSize: 14), color: UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0))
    lazy var productColorLabel = CustomLabels(text: "", font: .systemFont(ofSize: 14), color: UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0))
    lazy var productCategoryLabel = CustomLabels(text: "", font: .systemFont(ofSize: 14), color: UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0))
    
    lazy var explanationLabel = CustomLabels(text: "", font: .systemFont(ofSize: 16), color: UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0))
    
    lazy var productReviewsLabel = CustomLabels(text: "Ürün Değelendirmeleri", font: .systemFont(ofSize: 18), color: .black)
    
    lazy var priceLabel = CustomLabels(text: "", font: .boldSystemFont(ofSize: 16), color: .systemOrange)
    lazy var freeCargoLabel = CustomLabels(text: "Kargo Bedava", font: .systemFont(ofSize: 14), color: .systemGreen)
    
    lazy var starImageView = CustomImageViews()
    lazy var truckImageView = CustomImageViews()
    lazy var explanationImageView = CustomImageViews()
    
    lazy var backButton = CustomButtons(title: "", textColor: .white, buttonColor: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1), radius: 0, imageName: "chevron.backward", buttonTintColor: .black)
    lazy var likeBtn = CustomButtons(title: "", textColor: .white, buttonColor: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1), radius: 0, imageName: "heart", buttonTintColor: .black)
    lazy var cartButton = CustomButtons(title: "", textColor: .white, buttonColor: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1), radius: 0, imageName: "cart", buttonTintColor: .black)
    lazy var likeButton = CustomButtons(title: "", textColor: .white, buttonColor: .white, radius: 25, imageName: "heart", buttonTintColor: .black)
    lazy var addProductToCartButton = CustomButtons(title: "Sepete Ekle", textColor: .white, buttonColor: .systemYellow, radius: 10, imageName: "", buttonTintColor: .white)
    lazy var buyNowButton = CustomButtons(title: "Şimdi Al", textColor: .systemYellow, buttonColor: .white, radius: 10, imageName: "", buttonTintColor: .white)
    lazy var readMoreButton = CustomButtons(title: "Daha fazla göster", textColor: .black, buttonColor: .white, radius: 0, imageName: "", buttonTintColor: .white)
    
    lazy var contentView = CustomViews(color: .white)
    lazy var topBarView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var separatorLine1 = CustomViews(color: .systemGray4)
    lazy var separatorLine2 = CustomViews(color: .systemGray4)
    lazy var separatorLine3 = CustomViews(color: .systemGray4)
    lazy var separatorLine4 = CustomViews(color: .systemGray4)
    lazy var separatorLine5 = CustomViews(color: .systemGray4)
    lazy var separatorLine6 = CustomViews(color: .systemGray4)
    lazy var productBrandView = CustomViews(color: UIColor(red: 1.0, green: 0.95, blue: 0.9, alpha: 1.0))
    lazy var productColorView = CustomViews(color: UIColor(red: 1.0, green: 0.95, blue: 0.9, alpha: 1.0))
    lazy var productCategoryView = CustomViews(color: UIColor(red: 1.0, green: 0.95, blue: 0.9, alpha: 1.0))
    lazy var bottomBarView = CustomViews(color: UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0))
    
    lazy var activityIndicator = ActivityIndicators(indicatorColor: .white)
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let reviewsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likeBtn.isHidden = true
        
    }
    
    
    func adjustContentViewHeight() {
        let maxSize = CGSize(width: explanationLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let explanationLabelSize = explanationLabel.sizeThatFits(maxSize)
        
        let contentHeight = explanationLabelSize.height + 30 + 210 + 15 + 15 + 15 + 15 + 45 + 45 + 45 + 40 + 15 + 100 + 15 + 40 + 130 + 500
        
        updateViewHeights(explanationLabelHeights: explanationLabelSize.height, contentHeight: contentHeight)
    }
    
    func updateViewHeights(explanationLabelHeights: CGFloat, contentHeight: CGFloat) {
        explanationLabel.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = explanationLabelHeights
            }
        }
        
        contentView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = contentHeight
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func configureBottomBarView() {
        view.addSubview(bottomBarView)
        bottomBarView.addSubviewsFromExt(addProductToCartButton, buyNowButton, priceLabel, freeCargoLabel)
        addProductToCartButton.addSubview(activityIndicator)
        
        buyNowButton.layer.borderColor = UIColor.systemYellow.cgColor
        buyNowButton.layer.borderWidth = 1
        
        bottomBarView.anchor(left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, height: 80)
        addProductToCartButton.anchor(top: bottomBarView.topAnchor, right: bottomBarView.rightAnchor, paddingTop: 10, paddingRight: 20, width: 110, height: 50)
        buyNowButton.anchor(top: bottomBarView.topAnchor, right: addProductToCartButton.leftAnchor, paddingTop: 10, paddingRight: 10, width: 110, height: 50)
        priceLabel.anchor(top: bottomBarView.topAnchor, left: bottomBarView.leftAnchor, paddingTop: 10, paddingLeft: 20)
        freeCargoLabel.anchor(top: priceLabel.bottomAnchor, left: bottomBarView.leftAnchor, paddingLeft: 20)
        activityIndicator.anchor(centerX: addProductToCartButton.centerXAnchor, centerY: addProductToCartButton.centerYAnchor)
    }
    
    func configureTopBarView() {
        view.addSubview(topBarView)
        topBarView.addSubviewsFromExt(backButton, likeBtn, cartButton)
                
        topBarView.layer.borderWidth = 1
        topBarView.layer.borderColor = CGColor(red: 224 / 255, green: 224 / 255, blue: 224 / 255, alpha: 1)
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        
        let originalImage = UIImage(systemName: "chevron.backward")
        let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        backButton.setImage(resizedImage, for: .normal)
        
        let originalImage2 = UIImage(systemName: "heart")
        let resizedImage2 = originalImage2?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        likeBtn.setImage(resizedImage2, for: .normal)
        
        let originalImage3 = UIImage(systemName: "cart")
        let resizedImage3 = originalImage3?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        cartButton.setImage(resizedImage3, for: .normal)
        
        backButton.anchor(left: topBarView.leftAnchor, bottom: topBarView.bottomAnchor, paddingLeft: 10, paddingBottom: 25)
        likeBtn.anchor(right: topBarView.rightAnchor, bottom: topBarView.bottomAnchor, paddingRight: 10, paddingBottom: 25)
        cartButton.anchor(right: topBarView.rightAnchor, bottom: topBarView.bottomAnchor, paddingRight: 10, paddingBottom: 25)
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubviewsFromExt(contentView)
        contentView.addSubviewsFromExt(imagesCollectionView, brandLabel, productNameLabel, pointLabel1, evaluationLabel, deliveryLabel, starImageView, truckImageView, separatorLine1, separatorLine2, separatorLine3, separatorLine4, separatorLine5, campaignLabel, cargoLabel, productFeaturesLabel, productBrandView, productColorView, productCategoryView, explanationImageView, explanationLabel, readMoreButton, productReviewsLabel, reviewsCollectionView, pointLabel2, likeButton)
        
        productCategoryView.addSubviewsFromExt(productCategoryLabel, productCategoryHeaderLabel)
        productBrandView.addSubviewsFromExt(productBrandLabel, productBrandHeaderLabel)
        productColorView.addSubviewsFromExt(productColorLabel, productColorHeaderLabel)
        
        scrollView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, bottom: scrollView.bottomAnchor, width: view.bounds.size.width, height: 1350)
        
        likeButton.anchor(top: contentView.topAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingRight: 10, width: 50, height: 50)
        
        imagesCollectionView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 500)
        
        productNameLabel.anchor(top: imagesCollectionView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 15, paddingRight: 5)
        brandLabel.anchor(top: imagesCollectionView.bottomAnchor, left: contentView.leftAnchor, right: productNameLabel.leftAnchor, paddingTop: 15, paddingLeft: 10, paddingRight: 5)
        
        pointLabel1.anchor(top: productNameLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        starImageView.anchor(top: productNameLabel.bottomAnchor, left: pointLabel1.rightAnchor, paddingTop: 10, paddingLeft: 5)
        evaluationLabel.anchor(top: productNameLabel.bottomAnchor, left: starImageView.rightAnchor, paddingTop: 10, paddingLeft: 10)
        
        separatorLine1.anchor(top: pointLabel1.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 15, height: 1)
        
        truckImageView.anchor(top: separatorLine1.bottomAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        deliveryLabel.anchor(top: separatorLine1.bottomAnchor, left: truckImageView.rightAnchor, paddingTop: 10, paddingLeft: 5)
        
        campaignLabel.anchor(top: truckImageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10)
        cargoLabel.anchor(top: campaignLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingRight: 15, height: 40)
        
        separatorLine2.anchor(top: cargoLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 15, height: 1)
        
        productFeaturesLabel.anchor(top: separatorLine2.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 15, paddingLeft: 10)
        separatorLine3.anchor(top: productFeaturesLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 15, height: 1)
        
        productCategoryView.anchor(top: separatorLine3.bottomAnchor, left: contentView.leftAnchor, paddingTop: 15, paddingLeft: 15, width: 120, height: 45)
        productCategoryHeaderLabel.anchor(top: productCategoryView.topAnchor, left: productCategoryView.leftAnchor, paddingTop: 5, paddingLeft: 5)
        productCategoryLabel.anchor(top: productCategoryHeaderLabel.bottomAnchor, left: productCategoryView.leftAnchor, paddingLeft: 5)
        
        productBrandView.anchor(top: separatorLine3.bottomAnchor, left: productCategoryView.rightAnchor, paddingTop: 15, paddingLeft: 10, width: 100, height: 45)
        productBrandHeaderLabel.anchor(top: productBrandView.topAnchor, left: productBrandView.leftAnchor, paddingTop: 5, paddingLeft: 5)
        productBrandLabel.anchor(top: productBrandHeaderLabel.bottomAnchor, left: productBrandView.leftAnchor, paddingLeft: 5)
        
        productColorView.anchor(top: separatorLine3.bottomAnchor, left: productBrandView.rightAnchor, paddingTop: 15, paddingLeft: 10, width: 85, height: 45)
        productColorHeaderLabel.anchor(top: productColorView.topAnchor, left: productColorView.leftAnchor, paddingTop: 5, paddingLeft: 5)
        productColorLabel.anchor(top: productColorHeaderLabel.bottomAnchor, left: productColorView.leftAnchor, paddingLeft: 5)
        
        explanationImageView.anchor(top: productCategoryView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 15, paddingLeft: 10, width: 20, height: 20)
        explanationLabel.anchor(top: productCategoryView.bottomAnchor, left: explanationImageView.rightAnchor, right: contentView.rightAnchor, paddingTop: 15, paddingLeft: 5, paddingRight: 5)
        readMoreButton.anchor(top: explanationLabel.bottomAnchor, right: contentView.rightAnchor, paddingTop: 5, paddingRight: 5, height: 30)
        
        separatorLine4.anchor(top: readMoreButton.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 15, height: 1)
        productReviewsLabel.anchor(top: separatorLine4.bottomAnchor, left: contentView.leftAnchor, paddingTop: 15, paddingLeft: 10)
        separatorLine5.anchor(top: productReviewsLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 15, height: 1)
        
        pointLabel2.anchor(top: separatorLine5.bottomAnchor, left: contentView.leftAnchor, paddingTop: 15, paddingLeft: 10, paddingRight: 10)
        reviewsCollectionView.anchor(top: pointLabel2.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 15, paddingLeft: 5, paddingRight: 5, height: 210)
    }
    
}
