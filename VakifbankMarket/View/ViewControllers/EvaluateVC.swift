//
//  EvaluateVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 9.08.2024.
//

import UIKit

class EvaluateVC: UIViewController, UITextViewDelegate {
    
    lazy var topBarView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    
    lazy var backButton = CustomButtons(title: "", textColor: .white, buttonColor: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1), radius: 0, imageName: "xmark", buttonTintColor: .black)
    lazy var evaluateButton = CustomButtons(title: "Değerlendir", textColor: .white, buttonColor: .systemYellow, radius: 5, imageName: "", buttonTintColor: .white)
    
    lazy var evaluateLabel = CustomLabels(text: "Siparişi Değerlendir", font: .boldSystemFont(ofSize: 20), color: .black)
    lazy var brandLabel = CustomLabels(text: "", font: .systemFont(ofSize: 18), color: .black)
    lazy var productNameLabel = CustomLabels(text: "", font: .systemFont(ofSize: 16), color: .gray)
    lazy var priceLabel = CustomLabels(text: "", font: .systemFont(ofSize: 18), color: .systemYellow)
    lazy var productEvaluateLabel = CustomLabels(text: "Ürünü Değerlendir", font: .systemFont(ofSize: 16), color: .black)
    
    lazy var evaluateTextView = CustomTextViews()
    
    lazy var imageView = CustomImageViews()
    lazy var starImageView1 = CustomImageViews()
    lazy var starImageView2 = CustomImageViews()
    lazy var starImageView3 = CustomImageViews()
    lazy var starImageView4 = CustomImageViews()
    lazy var starImageView5 = CustomImageViews()
    
    lazy var activityIndicator = ActivityIndicators(indicatorColor: .white)
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starImageView1, starImageView2, starImageView3, starImageView4, starImageView5])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var product: ProductModel?
    
    var point = Int()
    
    let viewModel = EvaluateViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .white
        
        fillItems()
        configureTopBarView()
        configureUI()
        addTarget()
        tapGestureImages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            var activeField: UIView?
            if evaluateTextView.isFirstResponder {
                activeField = evaluateTextView
            }
            
            if let activeField = activeField {
                let visibleRect = view.frame.inset(by: contentInsets)
                if !visibleRect.contains(activeField.frame.origin) {
                    scrollView.scrollRectToVisible(activeField.frame, animated: true)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.25) {
            let contentInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func tapGestureImages() {
        starImageView1.isUserInteractionEnabled = true
        let starImageView1TapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureStarImageView1))
        starImageView1.addGestureRecognizer(starImageView1TapRecognizer)
        
        starImageView2.isUserInteractionEnabled = true
        let starImageView2TapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureStarImageView2))
        starImageView2.addGestureRecognizer(starImageView2TapRecognizer)
        
        starImageView3.isUserInteractionEnabled = true
        let starImageView3TapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureStarImageView3))
        starImageView3.addGestureRecognizer(starImageView3TapRecognizer)
        
        starImageView4.isUserInteractionEnabled = true
        let starImageView4TapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureStarImageView4))
        starImageView4.addGestureRecognizer(starImageView4TapRecognizer)
        
        starImageView5.isUserInteractionEnabled = true
        let starImageView5TapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureStarImageView5))
        starImageView5.addGestureRecognizer(starImageView5TapRecognizer)
    }
    
    @objc func tapGestureStarImageView1() {
        starImageView1.tintColor = .systemYellow
        starImageView2.tintColor = .systemGray6
        starImageView3.tintColor = .systemGray6
        starImageView4.tintColor = .systemGray6
        starImageView5.tintColor = .systemGray6
        point = 1
    }
    
    @objc func tapGestureStarImageView2() {
        starImageView1.tintColor = .systemYellow
        starImageView2.tintColor = .systemYellow
        starImageView3.tintColor = .systemGray6
        starImageView4.tintColor = .systemGray6
        starImageView5.tintColor = .systemGray6
        point = 2
    }
    
    @objc func tapGestureStarImageView3() {
        starImageView1.tintColor = .systemYellow
        starImageView2.tintColor = .systemYellow
        starImageView3.tintColor = .systemYellow
        starImageView4.tintColor = .systemGray6
        starImageView5.tintColor = .systemGray6
        point = 3
        print(point)
    }
    
    @objc func tapGestureStarImageView4() {
        starImageView1.tintColor = .systemYellow
        starImageView2.tintColor = .systemYellow
        starImageView3.tintColor = .systemYellow
        starImageView4.tintColor = .systemYellow
        starImageView5.tintColor = .systemGray6
        point = 4
    }
    
    @objc func tapGestureStarImageView5() {
        starImageView1.tintColor = .systemYellow
        starImageView2.tintColor = .systemYellow
        starImageView3.tintColor = .systemYellow
        starImageView4.tintColor = .systemYellow
        starImageView5.tintColor = .systemYellow
        point = 5
        print(point)
    }
    
    func fillItems() {
        starImageView1.image = UIImage(systemName: "star.fill")
        starImageView2.image = UIImage(systemName: "star.fill")
        starImageView3.image = UIImage(systemName: "star.fill")
        starImageView4.image = UIImage(systemName: "star.fill")
        starImageView5.image = UIImage(systemName: "star.fill")
        
        starImageView1.tintColor = .systemGray6
        starImageView2.tintColor = .systemGray6
        starImageView3.tintColor = .systemGray6
        starImageView4.tintColor = .systemGray6
        starImageView5.tintColor = .systemGray6
        
        starImageView1.contentMode = .scaleAspectFill
        starImageView2.contentMode = .scaleAspectFill
        starImageView3.contentMode = .scaleAspectFill
        starImageView4.contentMode = .scaleAspectFill
        starImageView5.contentMode = .scaleAspectFill
        
        guard let product = product else { return }
        imageView.sd_setImage(with: URL(string: product.imageUrls.first ?? ""))
        brandLabel.text = product.brand
        productNameLabel.text = product.productName
        
        if product.price.truncatingRemainder(dividingBy: 1) == 0 {
            priceLabel.text = "\(Int(product.price)) TL"
        } else {
            priceLabel.text = String(format: "%.2f TL", product.price)
        }
    }
    
    func addTarget() {
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        evaluateButton.addTarget(self, action: #selector(evaluateButtonClicked), for: .touchUpInside)
    }
    
    @objc func evaluateButtonClicked() {
        guard let product = product else { return }
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.evaluateButton.setTitle("", for: .normal)
            self.evaluateButton.isEnabled = true
        }
        
        if !evaluateTextView.text.isEmpty || point != 0 {
            viewModel.evaluateTheProduct(productID: product.productID, comment: evaluateTextView.text, point: point) { success in
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                    self.evaluateButton.isEnabled = false
                    
                    if success {
                        self.dismiss(animated: true)
                    } else {
                        let alert = UIAlertController(title: "", message: "Değerlendirmenizde bir sorun oluştu", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                        self.present(alert, animated: true)
                        
                        self.evaluateButton.setTitle("Değerlendir", for: .normal)
                        self.evaluateButton.isEnabled = true
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "", message: "Lütfen değerlendirme yapınız", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { action in
                self.activityIndicator.stopAnimating()
                self.evaluateButton.setTitle("Değerlendir", for: .normal)
                self.evaluateButton.isEnabled = true
            }))
            present(alert, animated: true)
        }
    }
    
    @objc func backButtonClicked() {
        dismiss(animated: true)
    }
    
    func configureTopBarView() {
        view.addSubview(topBarView)
        topBarView.addSubviewsFromExt(backButton, evaluateLabel)
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        
        let originalImage = UIImage(systemName: "xmark")
        let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        backButton.setImage(resizedImage, for: .normal)
        
        backButton.anchor(left: topBarView.leftAnchor, bottom: topBarView.bottomAnchor, paddingLeft: 10, paddingBottom: 25)
        evaluateLabel.anchor(bottom: topBarView.bottomAnchor, centerX: topBarView.centerXAnchor, paddingBottom: 25)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            textView.removePlaceholder()
        } else {
            textView.addPlaceholder("Ürünle ilgili görüşlerini bekliyoruz")
        }
    }
    
    func configureUI() {
        evaluateTextView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviewsFromExt(imageView, stackView, brandLabel, productNameLabel, priceLabel, productEvaluateLabel, evaluateTextView, evaluateButton, activityIndicator)
        evaluateTextView.addPlaceholder("Ürünle ilgili görüşlerini bekliyoruz")
        
        imageView.layer.cornerRadius = 5
        
        evaluateTextView.backgroundColor = .systemGray6
        
        scrollView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, width: view.bounds.size.width)
        
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, bottom: scrollView.bottomAnchor, width: view.bounds.size.width)
        contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        imageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 20, paddingLeft: 10, width: 100, height: 150)
        brandLabel.anchor(top: contentView.topAnchor, left: imageView.rightAnchor, paddingTop: 20, paddingLeft: 10)
        productNameLabel.anchor(top: brandLabel.bottomAnchor, left: imageView.rightAnchor, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: 10)
        priceLabel.anchor(top: productNameLabel.bottomAnchor, left: imageView.rightAnchor, paddingTop: 5, paddingLeft: 10)
        
        productNameLabel.numberOfLines = 0
        
        stackView.anchor(top: imageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingLeft: 15, paddingRight: 15, height: 50)
        
        productEvaluateLabel.anchor(top: stackView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 30, paddingLeft: 10)
        evaluateTextView.anchor(top: productEvaluateLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingRight: 15, height: 80)
        evaluateButton.anchor(left: contentView.leftAnchor, right: contentView.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 15, paddingRight: 15, height: 50)
        activityIndicator.anchor(centerX: evaluateButton.centerXAnchor, centerY: evaluateButton.centerYAnchor)
    }

}
