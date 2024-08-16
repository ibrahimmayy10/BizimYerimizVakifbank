//
//  OrderDetailsVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 9.08.2024.
//

import UIKit
import Firebase

class OrderDetailsVC: UIViewController {
    
    lazy var topBarView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var orderInfoView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var orderSummaryView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var addressView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var separatorLine1 = CustomViews(color: .gray)
    lazy var separatorLine2 = CustomViews(color: .systemGray4)
    lazy var separatorLine3 = CustomViews(color: .systemGray4)
    lazy var separatorLine4 = CustomViews(color: .systemGray4)
    lazy var contentView = CustomViews(color: .white)
    
    lazy var backButton = CustomButtons(title: "", textColor: .white, buttonColor: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1), radius: 0, imageName: "chevron.backward", buttonTintColor: .black)
    lazy var evaluateButton = CustomButtons(title: "Değerlendir", textColor: .black, buttonColor: .white, radius: 5, imageName: "star.fill", buttonTintColor: .systemYellow)
    lazy var deliveryButton = CustomButtons(title: "Teslimatı Onayla", textColor: .white, buttonColor: .systemYellow, radius: 0, imageName: "", buttonTintColor: .white)
    
    lazy var orderLabel = CustomLabels(text: "Sipariş Detay", font: .boldSystemFont(ofSize: 20), color: .black)
    lazy var orderNoLabel = CustomLabels(text: "Sipariş No: ", font: .systemFont(ofSize: 18), color: .black)
    lazy var orderDateLabel = CustomLabels(text: "Sipariş Tarihi", font: .systemFont(ofSize: 18), color: .black)
    lazy var confirmLabel = CustomLabels(text: "Siparişin Onaylanıyor", font: .systemFont(ofSize: 16), color: .systemGreen)
    lazy var brandLabel = CustomLabels(text: "", font: .systemFont(ofSize: 18), color: .black)
    lazy var productNameLabel = CustomLabels(text: "", font: .systemFont(ofSize: 18), color: .gray)
    lazy var priceLabel = CustomLabels(text: "", font: .systemFont(ofSize: 18), color: .systemYellow)
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
    
    lazy var imageView = CustomImageViews()
    lazy var confirmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "minus")
        imageView.tintColor = .systemGreen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var product: ProductModel?
    var order: OrderModel?
    
    let viewModel = ConfirmCartViewModel()
    
    var address = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        
        getDataAddress()
        fillItems()
        configureTopBarView()
        configureScrollView()
        getDataConfirm()
        configureOrderInfoView()
        configureOrderSummaryView()
        configureAddressView()
        configureDeliveryButton()
        cargoSettings()
        addTarget()
        updateContentViewHeight()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataConfirm()
    }
    
    func getDataConfirm() {
        guard let product = product else { return }
        
        guard let user = Auth.auth().currentUser else { return }
        let currentUserID = user.uid
        
        let firestore = Firestore.firestore()
        
        firestore.collection("Orders").whereField("productID", isEqualTo: product.productID).whereField("buyerID", isEqualTo: currentUserID).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else if let documents = snapshot?.documents {
                for document in documents {
                    guard let confirm = document.get("confirm") as? Bool else { return }
                    guard let delivery = document.get("delivery") as? Bool else { return }
                    
                    if delivery {
                        self.confirmLabel.text = "Teslim Edildi"
                        self.confirmLabel.textColor = .systemGreen
                        self.confirmImageView.image = UIImage(systemName: "checkmark")
                        self.deliveryButton.isHidden = true
                    } else if confirm {
                        self.confirmLabel.text = "Siparişin Onaylandı"
                        self.confirmLabel.textColor = .systemGreen
                        self.confirmImageView.image = UIImage(systemName: "checkmark")
                        self.deliveryButton.isHidden = false
                    } else {
                        self.confirmLabel.text = "Siparişin Onaylanıyor"
                        self.confirmLabel.textColor = .systemGreen
                        self.confirmImageView.image = UIImage(systemName: "minus")
                        self.deliveryButton.isHidden = true
                    }
                }
            }
        }
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, bottom: scrollView.bottomAnchor, width: view.bounds.size.width)
    }
    
    func updateContentViewHeight() {
        let topBarHeight: CGFloat = 100
        let orderInfoViewHeight: CGFloat = 220
        let orderSummaryViewHeight: CGFloat = 200
        let addressViewHeight: CGFloat = 150
        let deliveryButtonHeight: CGFloat = 60
        
        let verticalPadding: CGFloat = 0
        
        let totalHeight = topBarHeight +
        orderInfoViewHeight +
        verticalPadding +
        orderSummaryViewHeight +
        verticalPadding +
        addressViewHeight +
        deliveryButtonHeight +
        verticalPadding
        
        contentView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
    
    func addTarget() {
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        evaluateButton.addTarget(self, action: #selector(evaluateButtonClicked), for: .touchUpInside)
        deliveryButton.addTarget(self, action: #selector(deliveryButtonClicked), for: .touchUpInside)
    }
    
    @objc func deliveryButtonClicked() {
        let alert = UIAlertController(title: "", message: "Teslimatı onaylayacaksınız", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Onayla", style: .default, handler: { action in
            let qrScannerVC = QrScannerVC()
            qrScannerVC.completion = { [weak self] qrCode in
                self?.updateOrderConfirmStatus(with: qrCode)
            }
            let navController = UINavigationController(rootViewController: qrScannerVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Kapat", style: .cancel))
        present(alert, animated: true)
    }
    
    func updateOrderConfirmStatus(with qrCode: String) {
        guard let product = product else { return }
        
        let firestore = Firestore.firestore()
        firestore.collection("Orders").whereField("productID", isEqualTo: product.productID)
            .whereField("buyerID", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .getDocuments { snapshot, error in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                } else if let documents = snapshot?.documents {
                    for document in documents {
                        document.reference.updateData(["delivery": true]) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                    }
                }
            }
        
        firestore.collection("Sales").whereField("productID", isEqualTo: product.productID)
            .whereField("buyerID", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .getDocuments { snapshot, error in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                } else if let documents = snapshot?.documents {
                    for document in documents {
                        document.reference.updateData(["delivery": true]) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                    }
                }
            }
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func evaluateButtonClicked() {
        let vc = EvaluateVC()
        vc.product = product
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func getDataAddress() {
        viewModel.fetchAddresses { addresses in
            self.addressLabel.text = addresses.first ?? ""
        }
    }
    
    func fillItems() {
        guard let product = product else { return }
        
        let orderNoText = "Sipariş No: "
        let orderNoValue = "#2340423432"

        let attributedString = NSMutableAttributedString(string: orderNoText, attributes: [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ])

        let orderNoValueAttributedString = NSAttributedString(string: orderNoValue, attributes: [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.gray
        ])

        attributedString.append(orderNoValueAttributedString)

        orderNoLabel.attributedText = attributedString
        
        let orderDateText = "Sipariş Tarihi: "
        let orderDateValue = dateFormatter()

        let attributedString2 = NSMutableAttributedString(string: orderDateText, attributes: [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ])

        let orderNoValueAttributedString2 = NSAttributedString(string: orderDateValue, attributes: [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.gray
        ])

        attributedString2.append(orderNoValueAttributedString2)

        orderDateLabel.attributedText = attributedString2

        brandLabel.text = product.brand
        productNameLabel.text = product.productName
        
        if product.price.truncatingRemainder(dividingBy: 1) == 0 {
            priceLabel.text = "\(Int(product.price)) TL"
        } else {
            priceLabel.text = String(format: "%.2f TL", product.price)
        }
        
        imageView.sd_setImage(with: URL(string: product.imageUrls.first ?? ""))
    }
    
    func dateFormatter() -> String {
        guard let order = order else { return "" }
        
        let date = order.time.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateFormatted = dateFormatter.string(from: date)
        return dateFormatted
    }
    
    func configureTopBarView() {
        view.addSubview(topBarView)
        topBarView.addSubviewsFromExt(backButton, orderLabel)
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        
        let originalImage = UIImage(systemName: "chevron.backward")
        let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        backButton.setImage(resizedImage, for: .normal)
        
        backButton.anchor(left: topBarView.leftAnchor, bottom: topBarView.bottomAnchor, paddingLeft: 10, paddingBottom: 25)
        orderLabel.anchor(bottom: topBarView.bottomAnchor, centerX: topBarView.centerXAnchor, paddingBottom: 25)
    }
    
    func configureOrderInfoView() {
        contentView.addSubview(orderInfoView)
        orderInfoView.addSubviewsFromExt(orderNoLabel, orderDateLabel, brandLabel, productNameLabel, priceLabel, imageView, separatorLine1, evaluateButton, confirmLabel, confirmImageView)
        
        orderInfoView.layer.cornerRadius = 5
                
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        evaluateButton.layer.borderWidth = 2
        evaluateButton.layer.borderColor = UIColor.systemYellow.cgColor
        
        orderInfoView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingRight: 15, height: 250)
        orderNoLabel.anchor(top: orderInfoView.topAnchor, left: orderInfoView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        orderDateLabel.anchor(top: orderNoLabel.bottomAnchor, left: orderInfoView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        separatorLine1.anchor(top: orderDateLabel.bottomAnchor, left: orderInfoView.leftAnchor, right: orderInfoView.rightAnchor, paddingTop: 10, height: 1)
        confirmImageView.anchor(top: separatorLine1.bottomAnchor, left: orderInfoView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        confirmLabel.anchor(top: separatorLine1.bottomAnchor, left: confirmImageView.rightAnchor, paddingTop: 10, paddingLeft: 5)
        imageView.anchor(top: confirmLabel.bottomAnchor, left: orderInfoView.leftAnchor, paddingTop: 10, paddingLeft: 10, width: 100, height: 120)
        brandLabel.anchor(top: confirmLabel.bottomAnchor, left: imageView.rightAnchor, paddingTop: 10, paddingLeft: 10)
        productNameLabel.anchor(top: brandLabel.bottomAnchor, left: imageView.rightAnchor, right: orderInfoView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10)
        priceLabel.anchor(top: productNameLabel.bottomAnchor, left: imageView.rightAnchor, paddingTop: 5, paddingLeft: 10)
        evaluateButton.anchor(top: priceLabel.bottomAnchor, left: imageView.rightAnchor, paddingTop: 5, paddingLeft: 10, width: 150, height: 30)
    }
    
    func configureOrderSummaryView() {
        guard let product = product else { return }
        
        contentView.addSubview(orderSummaryView)
        orderSummaryView.addSubviewsFromExt(orderSummaryLabel, subtotalLabel, subtotalLabel2, cargoLabel, cargoPriceLabel, offerLabel, offerLabel2, separatorLine2, separatorLine3, totalLabel, totalPriceLabel)
        
        subtotalLabel2.text = String(format: "%.2f TL", product.price)
        
        orderSummaryView.layer.cornerRadius = 5
        orderSummaryView.clipsToBounds = true
        
        orderSummaryView.anchor(top: orderInfoView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15, height: 200)
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
        guard let product = product else { return }
        
        if product.price < 200 {
            offerLabel.isHidden = true
            offerLabel2.isHidden = true
            separatorLine3.anchor(top: cargoLabel.bottomAnchor, left: orderSummaryView.leftAnchor, right: orderSummaryView.rightAnchor, paddingTop: 10)
            totalPriceLabel.text = String(format: "%.2f TL", product.price + 39.99)
        } else {
            offerLabel.isHidden = false
            offerLabel2.isHidden = false
            separatorLine3.anchor(top: offerLabel.bottomAnchor, left: orderSummaryView.leftAnchor, right: orderSummaryView.rightAnchor, paddingTop: 10)
            totalPriceLabel.text = String(format: "%.2f TL", product.price)
        }
    }
    
    func configureAddressView() {
        contentView.addSubview(addressView)
        addressView.addSubviewsFromExt(deliveryAddressLabel, addressLabel, separatorLine4)
        
        addressView.layer.cornerRadius = 5
        addressView.clipsToBounds = true
        
        addressLabel.numberOfLines = 0
        
        addressView.anchor(top: orderSummaryView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15, height: 150)
        deliveryAddressLabel.anchor(top: addressView.topAnchor, left: addressView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        separatorLine4.anchor(top: deliveryAddressLabel.bottomAnchor, left: addressView.leftAnchor, right: addressView.rightAnchor, paddingTop: 10, height: 1)
        addressLabel.anchor(top: separatorLine4.bottomAnchor, left: addressView.leftAnchor, right: addressView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
    }
    
    func configureDeliveryButton() {
        contentView.addSubview(deliveryButton)
        
        deliveryButton.layer.cornerRadius = 5
        
        deliveryButton.anchor(top: addressView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15, height: 50)
    }

}
