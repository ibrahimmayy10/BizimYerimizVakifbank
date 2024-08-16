//
//  ConfirmCartVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 2.08.2024.
//

import UIKit
import Lottie

class ConfirmCartVC: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var safeLabel = CustomLabels(text: "Güvenli Ödeme", font: .boldSystemFont(ofSize: 20), color: .black)
    lazy var productToCartLabel = CustomLabels(text: "Sepetimdeki Ürünler", font: .systemFont(ofSize: 18), color: .black)
    lazy var deliveryAddressLabel = CustomLabels(text: "Teslimat Adresi", font: .systemFont(ofSize: 18), color: .black)
    lazy var addressLabel = CustomLabels(text: "Adres eklemeniz gerekmektedir", font: .systemFont(ofSize: 18), color: .gray)
    lazy var cardInfoLabel = CustomLabels(text: "Kart Bilgileri", font: .systemFont(ofSize: 18), color: .black)
    lazy var cardLabel = CustomLabels(text: "Kart eklemeniz gerekmektedir", font: .systemFont(ofSize: 18), color: .gray)
    lazy var totalLabel = CustomLabels(text: "Toplam", font: .systemFont(ofSize: 14), color: .gray)
    lazy var totalPriceLabel = CustomLabels(text: "", font: .systemFont(ofSize: 16), color: .black)
    lazy var totalPriceLabel2 = CustomLabels(text: "", font: .systemFont(ofSize: 16), color: .black)
    lazy var paymentLabel = CustomLabels(text: "Taksit Seçenekleri", font: .systemFont(ofSize: 18), color: .black)
    lazy var paymentLabel2 = CustomLabels(text: "Tek Çekim", font: .systemFont(ofSize: 18), color: .gray)
    
    lazy var cardNoTextField = CustomTextFields(isSecureText: false, text: "Kart No")
    lazy var monthTextField = CustomTextFields(isSecureText: false, text: "Ay")
    lazy var yearTextField = CustomTextFields(isSecureText: false, text: "Yıl")
    lazy var cvvTextField = CustomTextFields(isSecureText: false, text: "CVV")
    
    lazy var topBarView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var productToCartView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var addressView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var cardInfoView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var paymentView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var contentView = CustomViews(color: .white)
    lazy var bottomBarView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    
    lazy var separatorLine1 = CustomViews(color: .systemGray4)
    lazy var separatorLine2 = CustomViews(color: .systemGray4)
    lazy var separatorLine3 = CustomViews(color: .systemGray4)
    
    lazy var chevronDownImageView = CustomImageViews()
    
    lazy var backButton = CustomButtons(title: "", textColor: .white, buttonColor: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1), radius: 0, imageName: "chevron.backward", buttonTintColor: .black)
    lazy var addAddressButton = CustomButtons(title: "Ekle / Düzenle", textColor: .systemYellow, buttonColor: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1), radius: 0, imageName: "", buttonTintColor: .white)
    lazy var addCardButton = CustomButtons(title: "Ekle / Değiştir", textColor: .systemYellow, buttonColor: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1), radius: 0, imageName: "", buttonTintColor: .white)
    lazy var confirmButton = CustomButtons(title: "Onayla ve Bitir", textColor: .white, buttonColor: .systemYellow, radius: 10, imageName: "", buttonTintColor: .white)
    lazy var saveCardButton = CustomButtons(title: "Kaydet", textColor: .white, buttonColor: .systemYellow, radius: 10, imageName: "", buttonTintColor: .white)
    
    lazy var activityIndicator = ActivityIndicators(indicatorColor: .white)
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var animationView = LottieAnimationView(name: "loadingAnimation")
    
    var totalPrice: Double = 0
    
    var products = [ProductModel]()
    var quantity = Int()
    let viewModel = ConfirmCartViewModel()
    var productQuantities = [IndexPath: Int]()
    var address = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        getDataCardInfo()
        configureTopBar()
        configureBottomBar()
        configureScrollView()
        collectionViewSettings()
        configureProductToCartView()
        viewSettings()
        textFieldSettings()
        configureAddressView()
        configureCardInfoView()
        configurePaymentView()
        addTarget()
        
        getDataAddress()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleCollectionViewVisibility))
        productToCartView.addGestureRecognizer(tapGestureRecognizer)
        productToCartView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        updateViewHeights(productToCartHeight: 60, contentHeight: 720)

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataAddress()
        getDataCardInfo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cardNoTextField.resignFirstResponder()
        monthTextField.resignFirstResponder()
        yearTextField.resignFirstResponder()
        view.endEditing(true)
        contentView.endEditing(true)
        cardInfoView.endEditing(true)
        addressView.endEditing(true)
        paymentView.endEditing(true)
    }
    
    func configureAnimationView() {
        view.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 100, height: 100)
    }
    
    func toggleUIElementsVisibility(isHidden: Bool) {
        scrollView.isHidden = isHidden
        topBarView.isHidden = isHidden
        bottomBarView.isHidden = isHidden
    }
    
    func addTarget() {
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        addAddressButton.addTarget(self, action: #selector(addAddressButtonClicked), for: .touchUpInside)
        addCardButton.addTarget(self, action: #selector(addCardButtonClicked), for: .touchUpInside)
        saveCardButton.addTarget(self, action: #selector(saveCardButtonClicked), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
    }
    
    @objc func confirmButtonClicked() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.confirmButton.isEnabled = true
            self.confirmButton.setTitle("", for: .normal)
        }
        
        if !products.isEmpty {
            for (index, product) in products.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                let productQuantity = productQuantities[indexPath] ?? 1
                viewModel.confirmOrder(productID: product.productID, salesID: product.userID, quantity: productQuantity, price: product.price) { success in
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.confirmButton.isEnabled = false
                        self.confirmButton.setTitle("Onayla ve Bitir", for: .normal)
                    }
                    
                    if success {
                        UIView.transition(with: self.navigationController!.view!, duration: 0.5, options: .transitionCurlUp) {
                            let vc = ConfirmOrderVC()
                            vc.products = self.products
                            vc.subtotal = self.totalPrice
                            vc.address = self.address
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                    }
                }
            }
        } else {
            
        }
    }
    
    @objc func saveCardButtonClicked() {
        guard !((cardNoTextField.text?.isEmpty) == nil) && !((monthTextField.text?.isEmpty) == nil) && !((yearTextField.text?.isEmpty) == nil) else { return }
        viewModel.saveCardInfo(cardNo: cardNoTextField.text ?? "", month: monthTextField.text ?? "", year: yearTextField.text ?? "")
        cardNoTextField.isHidden.toggle()
        monthTextField.isHidden.toggle()
        yearTextField.isHidden.toggle()
        cvvTextField.isHidden.toggle()
        saveCardButton.isHidden.toggle()
        
        cardLabel.isHidden.toggle()
        getDataCardInfo()
    }
    
    @objc func addAddressButtonClicked() {
        let vc = AddAddressVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func getDataCardInfo() {
        viewModel.fetchCardInfo { cardNo in
            if cardNo.isEmpty {
                self.cardLabel.text = "Kart eklemeniz gerekmektedir"
            } else {
                self.cardLabel.numberOfLines = 0
                self.cardLabel.text = "\(cardNo.first ?? "") numaralı kartınızla işlem yapılacaktır"
            }
        }
    }
    
    func getDataAddress() {
        viewModel.fetchAddresses { addresses in
            if addresses.isEmpty {
                self.addressLabel.text = "Adres eklemeniz gerekmektedir"
            } else {
                self.addressLabel.numberOfLines = 0
                self.addressLabel.text = addresses.first
                self.address = addresses.first ?? ""
            }
        }
    }
    
    func updateViewHeights(productToCartHeight: CGFloat, contentHeight: CGFloat) {
        productToCartView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = productToCartHeight
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
    
    @objc func addCardButtonClicked() {
        cardNoTextField.isHidden.toggle()
        monthTextField.isHidden.toggle()
        yearTextField.isHidden.toggle()
        cvvTextField.isHidden.toggle()
        saveCardButton.isHidden.toggle()
        
        cardLabel.isHidden.toggle()
    }
    
    @objc func toggleCollectionViewVisibility() {
        collectionView.isHidden.toggle()
        
        if collectionView.isHidden {
            updateViewHeights(productToCartHeight: 60, contentHeight: 720)
            chevronDownImageView.image = UIImage(systemName: "chevron.down")
        } else {
            updateViewHeights(productToCartHeight: 260, contentHeight: 920)
            chevronDownImageView.image = UIImage(systemName: "chevron.up")
        }
    }

    func textFieldSettings() {
        cardNoTextField.delegate = self
        monthTextField.delegate = self
        yearTextField.delegate = self
        cvvTextField.delegate = self
        
        cardNoTextField.isHidden = true
        monthTextField.isHidden = true
        yearTextField.isHidden = true
        cvvTextField.isHidden = true
        saveCardButton.isHidden = true
        
        cardNoTextField.layer.borderWidth = 1
        cardNoTextField.layer.borderColor = UIColor.gray.cgColor
        cardNoTextField.layer.cornerRadius = 5
        cardNoTextField.keyboardType = .numberPad
        setLeftPaddingFor(textField: cardNoTextField, padding: 5)
        cardNoTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        monthTextField.layer.borderWidth = 1
        monthTextField.layer.borderColor = UIColor.gray.cgColor
        monthTextField.layer.cornerRadius = 5
        monthTextField.keyboardType = .numberPad
        setLeftPaddingFor(textField: monthTextField, padding: 5)
        
        yearTextField.layer.borderWidth = 1
        yearTextField.layer.borderColor = UIColor.gray.cgColor
        yearTextField.layer.cornerRadius = 5
        yearTextField.keyboardType = .numberPad
        setLeftPaddingFor(textField: yearTextField, padding: 5)
        
        cvvTextField.layer.borderWidth = 1
        cvvTextField.layer.borderColor = UIColor.gray.cgColor
        cvvTextField.layer.cornerRadius = 5
        cvvTextField.keyboardType = .numberPad
        setLeftPaddingFor(textField: cvvTextField, padding: 5)
    }
    
    func setLeftPaddingFor(textField: UITextField, padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let textWithoutSpaces = textField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        
        let formattedText = textWithoutSpaces.chunked(into: 4).joined(separator: " ")
        
        textField.text = formattedText
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cardNoTextField {
            if string.isEmpty {
                return true
            }
            
            let currentText = textField.text?.replacingOccurrences(of: " ", with: "") ?? ""
            if currentText.count + string.count > 16 {
                return false
            }
            
            return true
        } else if textField == monthTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 2
        } else if textField == yearTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 2
        } else if textField == cvvTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 3
        } else {
            return false
        }
    }
    
    func collectionViewSettings() {
        collectionView.register(ConfirmCartCollectionViewCell.self, forCellWithReuseIdentifier: ConfirmCartCollectionViewCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
        collectionView.isHidden = true
    }
    
    func viewSettings() {
        productToCartView.layer.cornerRadius = 5
        productToCartView.layer.shadowColor = UIColor.black.cgColor
        productToCartView.layer.shadowOffset = CGSize(width: 0, height: 2)
        productToCartView.layer.shadowOpacity = 0.2
        productToCartView.layer.shadowRadius = 5
        
        addressView.layer.cornerRadius = 5
        addressView.layer.shadowColor = UIColor.black.cgColor
        addressView.layer.shadowOffset = CGSize(width: 0, height: 2)
        addressView.layer.shadowOpacity = 0.2
        addressView.layer.shadowRadius = 5
        
        cardInfoView.layer.cornerRadius = 5
        cardInfoView.layer.shadowColor = UIColor.black.cgColor
        cardInfoView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardInfoView.layer.shadowOpacity = 0.2
        cardInfoView.layer.shadowRadius = 5
        
        paymentView.layer.cornerRadius = 5
        paymentView.layer.shadowColor = UIColor.black.cgColor
        paymentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        paymentView.layer.shadowOpacity = 0.2
        paymentView.layer.shadowRadius = 5
    }
    
    func configureTopBar() {
        view.addSubview(topBarView)
        topBarView.addSubviewsFromExt(backButton, safeLabel)
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        backButton.anchor(left: topBarView.leftAnchor, bottom: topBarView.bottomAnchor, paddingLeft: 10, paddingBottom: 25)
        safeLabel.anchor(bottom: topBarView.bottomAnchor, centerX: topBarView.centerXAnchor, paddingBottom: 25)
    }
    
    func configureBottomBar() {
        view.addSubview(bottomBarView)
        bottomBarView.addSubviewsFromExt(confirmButton, totalLabel, totalPriceLabel, activityIndicator)
        
        activityIndicator.style = .medium
        
        totalPriceLabel.text = String(format: "%.2f TL", totalPrice)
        
        bottomBarView.anchor(left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, height: view.bounds.size.height * 0.15)
        totalLabel.anchor(top: bottomBarView.topAnchor, left: bottomBarView.leftAnchor, paddingTop: 20, paddingLeft: 20)
        totalPriceLabel.anchor(top: totalLabel.bottomAnchor, left: bottomBarView.leftAnchor, paddingTop: 5, paddingLeft: 20)
        confirmButton.anchor(top: bottomBarView.topAnchor, right: bottomBarView.rightAnchor, paddingTop: 20, paddingRight: 20, width: 180, height: 40)
        activityIndicator.anchor(centerX: confirmButton.centerXAnchor, centerY: confirmButton.centerYAnchor)
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: bottomBarView.topAnchor)
        
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, bottom: scrollView.bottomAnchor, width: view.bounds.size.width, height: 720)
    }
    
    func configureProductToCartView() {
        contentView.addSubviewsFromExt(productToCartView)
        productToCartView.addSubviewsFromExt(productToCartLabel, collectionView, chevronDownImageView)
        
        productToCartLabel.text = "Sepetimdeki Ürünler (\(products.count))"
        chevronDownImageView.image = UIImage(systemName: "chevron.down")
        chevronDownImageView.tintColor = .gray
        
        productToCartView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 60)
        productToCartLabel.anchor(top: productToCartView.topAnchor, left: productToCartView.leftAnchor, paddingTop: 20, paddingLeft: 10)
        chevronDownImageView.anchor(top: productToCartView.topAnchor, right: productToCartView.rightAnchor, paddingTop: 20, paddingRight: 10)
        collectionView.anchor(top: productToCartLabel.bottomAnchor, left: productToCartView.leftAnchor, right: productToCartView.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 190)
    }
    
    func configureAddressView() {
        contentView.addSubview(addressView)
        addressView.addSubviewsFromExt(deliveryAddressLabel, addAddressButton, separatorLine1, addressLabel)
        
        addressView.anchor(top: productToCartView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 220)
        deliveryAddressLabel.anchor(top: addressView.topAnchor, left: addressView.leftAnchor, paddingTop: 20, paddingLeft: 10)
        addAddressButton.anchor(right: addressView.rightAnchor, centerY: deliveryAddressLabel.centerYAnchor, paddingTop: 20, paddingRight: 10)
        separatorLine1.anchor(top: deliveryAddressLabel.bottomAnchor, left: addressView.leftAnchor, right: addressView.rightAnchor, paddingTop: 20, height: 1)
        addressLabel.anchor(top: separatorLine1.bottomAnchor, left: addressView.leftAnchor, right: addressView.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)
    }
    
    func configureCardInfoView() {
        contentView.addSubview(cardInfoView)
        cardInfoView.addSubviewsFromExt(separatorLine2, cardInfoLabel, addCardButton, cardLabel, cardNoTextField, monthTextField, yearTextField, cvvTextField, saveCardButton)
        
        cardInfoView.anchor(top: addressView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 240)
        cardInfoLabel.anchor(top: cardInfoView.topAnchor, left: cardInfoView.leftAnchor, paddingTop: 20, paddingLeft: 10)
        addCardButton.anchor(right: cardInfoView.rightAnchor, centerY: cardInfoLabel.centerYAnchor, paddingTop: 20, paddingRight: 10)
        separatorLine2.anchor(top: cardInfoLabel.bottomAnchor, left: cardInfoView.leftAnchor, right: cardInfoView.rightAnchor, paddingTop: 20, height: 1)
        cardLabel.anchor(top: separatorLine2.bottomAnchor, left: cardInfoView.leftAnchor, right: cardInfoView.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)
        cardNoTextField.anchor(top: separatorLine2.bottomAnchor, left: cardInfoView.leftAnchor, right: cardInfoView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15, height: 40)
        monthTextField.anchor(top: cardNoTextField.bottomAnchor, left: cardInfoView.leftAnchor, paddingTop: 10, paddingLeft: 15, width: 100, height: 40)
        yearTextField.anchor(top: cardNoTextField.bottomAnchor, left: monthTextField.rightAnchor, paddingTop: 10, paddingLeft: 10, width: 100, height: 40)
        cvvTextField.anchor(top: cardNoTextField.bottomAnchor, left: yearTextField.rightAnchor, paddingTop: 10, paddingLeft: 10, width: 80, height: 40)
        saveCardButton.anchor(right: cardInfoView.rightAnchor, bottom: cardInfoView.bottomAnchor, paddingRight: 15, paddingBottom: 15, width: 100, height: 40)
    }
    
    func configurePaymentView() {
        contentView.addSubview(paymentView)
        paymentView.addSubviewsFromExt(paymentLabel, paymentLabel2, separatorLine3, totalPriceLabel2)
        
        totalPriceLabel2.text = String(format: "%.2f TL", totalPrice)
        
        paymentView.anchor(top: cardInfoView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 120)
        paymentLabel.anchor(top: paymentView.topAnchor, left: paymentView.leftAnchor, paddingTop: 20, paddingLeft: 10)
        separatorLine3.anchor(top: paymentLabel.bottomAnchor, left: paymentView.leftAnchor, right: paymentView.rightAnchor, paddingTop: 20, height: 1)
        paymentLabel2.anchor(top: separatorLine3.bottomAnchor, left: paymentView.leftAnchor, paddingTop: 20, paddingLeft: 10)
        totalPriceLabel2.anchor(top: separatorLine3.bottomAnchor, right: paymentView.rightAnchor, paddingTop: 20, paddingRight: 10)
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConfirmCartCollectionViewCell.reuseID, for: indexPath) as! ConfirmCartCollectionViewCell
        let product = products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 180)
    }

}

extension String {
    func chunked(into size: Int) -> [String] {
        var chunks: [String] = []
        var startIndex = self.startIndex
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: size, limitedBy: self.endIndex) ?? self.endIndex
            chunks.append(String(self[startIndex..<endIndex]))
            startIndex = endIndex
        }
        return chunks
    }
}
