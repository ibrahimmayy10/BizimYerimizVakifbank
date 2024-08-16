//
//  ConfirmOrderVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 7.08.2024.
//

import UIKit
import Firebase

class ConfirmOrderVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var vakifLabel = CustomLabels(text: "Bizim Yerimiz", font: .boldSystemFont(ofSize: 20), color: .black)
    lazy var confirmLabel = CustomLabels(text: "SİPARİŞİNİZ ALINDI", font: .systemFont(ofSize: 24), color: .systemYellow)
    lazy var explanationLabel = CustomLabels(text: "Alışverişinizin detaylarını aşağıda bulabilir, Siparişlerim bölümünden inceleyebilirsiniz", font: .systemFont(ofSize: 16), color: .black)
    lazy var dateLabel = CustomLabels(text: "Tahmini Teslim: ", font: .systemFont(ofSize: 16), color: .systemYellow)
    lazy var dateLabel2 = CustomLabels(text: "", font: .systemFont(ofSize: 16), color: .black)
    lazy var orderSummaryLabel = CustomLabels(text: "Sipariş Özeti", font: .systemFont(ofSize: 18), color: .systemYellow)
    lazy var subtotalLabel = CustomLabels(text: "Ara Toplam", font: .systemFont(ofSize: 18), color: .black)
    lazy var subtotalLabel2 = CustomLabels(text: "", font: .systemFont(ofSize: 18), color: .black)
    lazy var cargoLabel = CustomLabels(text: "Kargo", font: .systemFont(ofSize: 18), color: .black)
    lazy var cargoPriceLabel = CustomLabels(text: "39.99 TL", font: .systemFont(ofSize: 18), color: .black)
    lazy var offerLabel = CustomLabels(text: "200 TL ve Üzeri Kargo Bedava", font: .systemFont(ofSize: 18), color: .systemYellow)
    lazy var offerLabel2 = CustomLabels(text: "-39.99 TL", font: .systemFont(ofSize: 18), color: .systemYellow)
    lazy var totalLabel = CustomLabels(text: "Toplam", font: .systemFont(ofSize: 18), color: .black)
    lazy var totalPriceLabel = CustomLabels(text: "", font: .systemFont(ofSize: 18), color: .systemYellow)
    lazy var deliveryAddressLabel = CustomLabels(text: "Teslimat Adresi", font: .systemFont(ofSize: 18), color: .systemYellow)
    lazy var addressLabel = CustomLabels(text: "Teslimat Adresi", font: .systemFont(ofSize: 18), color: .black)
    
    lazy var keepShoppingButton = CustomButtons(title: "Alışverişe Devam Et", textColor: .white, buttonColor: .systemYellow, radius: 10, imageName: "", buttonTintColor: .white)
        
    lazy var topBarView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var confirmOrderView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var productDetailsView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var separatorLine1 = CustomViews(color: .systemGray4)
    lazy var separatorLine2 = CustomViews(color: .systemGray4)
    lazy var separatorLine3 = CustomViews(color: .systemGray4)
    lazy var separatorLine4 = CustomViews(color: .systemGray4)
    lazy var orderSummaryView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var addressView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var contentView = CustomViews(color: .white)
    
    lazy var confirmImageView = CustomImageViews()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var products = [ProductModel]()
    var subtotal = Double()
    var address = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureTopBar()
        configureScrollView()
        configureConfirmView()
        configureKeepShoppingButton()
        configureProductDetailsView()
        configureOrderSummaryView()
        configureAddressView()
        cargoSettings()
        addTarget()
        
    }
    
    func addTarget() {
        keepShoppingButton.addTarget(self, action: #selector(keepShoppingButtonClicked), for: .touchUpInside)
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keepShoppingButtonClicked() {
        navigationController?.pushViewController(HomePageVC(), animated: true)
    }
    
    func configureTopBar() {
        view.addSubview(topBarView)
        topBarView.addSubviewsFromExt(vakifLabel)
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        vakifLabel.anchor(bottom: topBarView.bottomAnchor, centerX: topBarView.centerXAnchor, paddingBottom: 25)
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, bottom: scrollView.bottomAnchor, width: view.bounds.size.width, height: 920)
    }
    
    func configureConfirmView() {
        contentView.addSubview(confirmOrderView)
        confirmOrderView.addSubviewsFromExt(confirmImageView, confirmLabel, explanationLabel)
        
        confirmOrderView.layer.cornerRadius = 5
        confirmOrderView.clipsToBounds = true
        
        confirmImageView.image = UIImage(systemName: "checkmark.circle")
        confirmImageView.tintColor = .systemGreen
        
        confirmLabel.textColor = .systemGreen
        
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .center
        
        confirmOrderView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15, height: 200)
        confirmImageView.anchor(top: confirmOrderView.topAnchor, centerX: confirmOrderView.centerXAnchor, paddingTop: 10, width: 80, height: 80)
        confirmLabel.anchor(top: confirmImageView.bottomAnchor, centerX: confirmOrderView.centerXAnchor, paddingTop: 10)
        explanationLabel.anchor(top: confirmLabel.bottomAnchor, left: confirmOrderView.leftAnchor, right: confirmOrderView.rightAnchor, paddingTop: 25, paddingLeft: 10, paddingRight: 10)
    }
    
    func configureKeepShoppingButton() {
        contentView.addSubview(keepShoppingButton)
        
        keepShoppingButton.anchor(top: confirmOrderView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 50)
    }
    
    func configureProductDetailsView() {
        collectionView.register(ConfirmOrderCollectionViewCell.self, forCellWithReuseIdentifier: ConfirmOrderCollectionViewCell.reuseID)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        contentView.addSubview(productDetailsView)
        productDetailsView.addSubviewsFromExt(collectionView, dateLabel, dateLabel2, separatorLine1)
        
        productDetailsView.layer.cornerRadius = 5
        productDetailsView.clipsToBounds = true
        
        dateLabel2.text = dateWithAddedDays(daysToAdd: 5)
        
        productDetailsView.anchor(top: keepShoppingButton.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15, height: 250)
        dateLabel.anchor(top: productDetailsView.topAnchor, left: productDetailsView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        dateLabel2.anchor(top: productDetailsView.topAnchor, left: dateLabel.rightAnchor, paddingTop: 10, paddingLeft: 10)
        separatorLine1.anchor(top: dateLabel.bottomAnchor, left: productDetailsView.leftAnchor, right: productDetailsView.rightAnchor, paddingTop: 10, height: 1)
        collectionView.anchor(top: separatorLine1.bottomAnchor, left: productDetailsView.leftAnchor, right: productDetailsView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingRight: 5, height: 180)
    }
    
    func dateWithAddedDays(daysToAdd: Int) -> String {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.day = daysToAdd
        
        let calendar = Calendar.current
        if let futureDate = calendar.date(byAdding: dateComponents, to: currentDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: futureDate)
        }
        
        return ""
    }
    
    func configureOrderSummaryView() {
        contentView.addSubview(orderSummaryView)
        orderSummaryView.addSubviewsFromExt(orderSummaryLabel, subtotalLabel, subtotalLabel2, cargoLabel, cargoPriceLabel, offerLabel, offerLabel2, separatorLine2, separatorLine3, totalLabel, totalPriceLabel)
        
        subtotalLabel2.text = String(format: "%.2f TL", subtotal)
        
        orderSummaryView.layer.cornerRadius = 5
        orderSummaryView.clipsToBounds = true
        
        orderSummaryView.anchor(top: productDetailsView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15, height: 200)
        orderSummaryLabel.anchor(top: orderSummaryView.topAnchor, left: orderSummaryView.leftAnchor, right: orderSummaryView.rightAnchor, paddingTop: 10, paddingLeft: 10)
        separatorLine2.anchor(top: orderSummaryLabel.bottomAnchor, left: orderSummaryView.leftAnchor, right: orderSummaryView.rightAnchor, paddingTop: 10, height: 1)
        subtotalLabel.anchor(top: separatorLine2.bottomAnchor, left: orderSummaryView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        subtotalLabel2.anchor(top: separatorLine2.bottomAnchor, right: orderSummaryView.rightAnchor, paddingTop: 10, paddingRight: 10)
        cargoLabel.anchor(top: subtotalLabel.bottomAnchor, left: orderSummaryView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        cargoPriceLabel.anchor(top: subtotalLabel2.bottomAnchor, right: orderSummaryView.rightAnchor, paddingTop: 10, paddingRight: 10)
        offerLabel.anchor(top: cargoLabel.bottomAnchor, left: orderSummaryView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        offerLabel2.anchor(top: cargoPriceLabel.bottomAnchor, right: orderSummaryView.rightAnchor, paddingTop: 10, paddingRight: 10)
        separatorLine3.anchor(top: offerLabel.bottomAnchor, left: orderSummaryView.leftAnchor, right: orderSummaryView.rightAnchor, paddingTop: 10, height: 1)
        totalLabel.anchor(top: separatorLine3.bottomAnchor, left: orderSummaryView.leftAnchor, paddingTop: 15, paddingLeft: 10)
        totalPriceLabel.anchor(top: separatorLine3.bottomAnchor, right: orderSummaryView.rightAnchor, paddingTop: 15, paddingRight: 10)
    }
    
    func cargoSettings() {
        if subtotal < 200 {
            offerLabel.isHidden = true
            offerLabel2.isHidden = true
            separatorLine3.anchor(top: cargoLabel.bottomAnchor, left: orderSummaryView.leftAnchor, right: orderSummaryView.rightAnchor, paddingTop: 10)
            totalPriceLabel.text = String(format: "%.2f TL", subtotal + 39.99)
        } else {
            offerLabel.isHidden = false
            offerLabel2.isHidden = false
            separatorLine3.anchor(top: offerLabel.bottomAnchor, left: orderSummaryView.leftAnchor, right: orderSummaryView.rightAnchor, paddingTop: 10)
            totalPriceLabel.text = String(format: "%.2f TL", subtotal)
        }
    }
    
    func configureAddressView() {
        contentView.addSubview(addressView)
        addressView.addSubviewsFromExt(deliveryAddressLabel, addressLabel, separatorLine4)
        
        addressView.layer.cornerRadius = 5
        addressView.clipsToBounds = true
        
        addressLabel.text = address
        addressLabel.numberOfLines = 0
        
        addressView.anchor(top: orderSummaryView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15, height: 100)
        deliveryAddressLabel.anchor(top: addressView.topAnchor, left: addressView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        separatorLine4.anchor(top: deliveryAddressLabel.bottomAnchor, left: addressView.leftAnchor, right: addressView.rightAnchor, paddingTop: 10, height: 1)
        addressLabel.anchor(top: separatorLine4.bottomAnchor, left: addressView.leftAnchor, right: addressView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConfirmOrderCollectionViewCell.reuseID, for: indexPath) as! ConfirmOrderCollectionViewCell
        let product = products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        if let cell = collectionView.cellForItem(at: indexPath) {
            AnimationHelper.animateCell(cell: cell, in: self.view) {
                AnimationHelper.navigateToProductDetailsVC(product: product, from: self.navigationController)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 170)
    }

}
