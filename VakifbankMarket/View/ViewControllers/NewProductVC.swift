//
//  NewProductVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 24.07.2024.
//

import UIKit
import PhotosUI

class NewProductVC: UIViewController, PHPickerViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, SelectedColorDelegate {
    
    lazy var infoLabel = CustomLabels(text: "Ürün Bilgileri", font: .boldSystemFont(ofSize: 18), color: .white)
    lazy var productNameLabel = CustomLabels(text: "Ürün Başlığı", font: .systemFont(ofSize: 17), color: .gray)
    lazy var explanationLabel = CustomLabels(text: "Açıklama", font: .systemFont(ofSize: 17), color: .gray)
    lazy var categoryLabel = CustomLabels(text: "Kategori", font: .systemFont(ofSize: 17), color: .gray)
    lazy var brandLabel = CustomLabels(text: "Marka", font: .systemFont(ofSize: 17), color: .gray)
    lazy var colorLabel = CustomLabels(text: "Renk", font: .systemFont(ofSize: 17), color: .gray)
    lazy var priceLabel = CustomLabels(text: "Fiyat", font: .systemFont(ofSize: 17), color: .gray)
    lazy var stockQuantityLabel = CustomLabels(text: "Stok Adedi", font: .systemFont(ofSize: 17), color: .gray)
    
    lazy var productNameTextView = CustomTextViews()
    lazy var explanationTextField = CustomTextViews()
    
    lazy var categoryTextField = CustomTextFields(isSecureText: false, text: "")
    lazy var brandTextField = CustomTextFields(isSecureText: false, text: "")
    lazy var colorTextField = CustomTextFields(isSecureText: false, text: "")
    lazy var priceTextField = CustomTextFields(isSecureText: false, text: "")
    lazy var stockQuantityTextField = CustomTextFields(isSecureText: false, text: "")

    lazy var createAdvertButton = CustomButtons(title: "İlan Oluştur", textColor: .white, buttonColor: .systemYellow, radius: 10, imageName: "", buttonTintColor: .white)
    lazy var backButton = CustomButtons(title: "", textColor: .white, buttonColor: .darkGray, radius: 0, imageName: "xmark", buttonTintColor: .white)
    
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
    
    lazy var addImageView1: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .systemOrange
        image.image = UIImage(named: "camera")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        return image
    }()
    
    lazy var addImageView2: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .systemOrange
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        return image
    }()
    
    lazy var addImageView3: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .systemOrange
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        return image
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addImageView1, addImageView2, addImageView3])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var topBarView = CustomViews(color: .darkGray)
    
    lazy var activityIndicator = ActivityIndicators(indicatorColor: .white)
    
    lazy var categoryPicker = UIPickerView()
    
    let categories = ["Elektronik", "Ayakkabı", "Çanta", "Saat", "Gözlük", "Giyim", "Müzik Aleti", "Kozmetik", "Oyuncak", "Kitap & Kırtasiye", "Aksesuar", "Ev Eşyaları"]
    
    var selectedImageView: UIImageView?
    
    var colorText = String()
    var category = String()
    
    var newProductViewModel = NewProductViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        topGestureImage()
        textViewSettings()
        pickerSettings()
        configureTopBar()
        addTarget()
        configureUI()
        imageViewSettings()
        
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
            if productNameTextView.isFirstResponder {
                activeField = productNameTextView
            } else if explanationTextField.isFirstResponder {
                activeField = explanationTextField
            } else if brandTextField.isFirstResponder {
                activeField = brandTextField
            } else if priceTextField.isFirstResponder {
                activeField = priceTextField
            } else if stockQuantityTextField.isFirstResponder {
                activeField = stockQuantityTextField
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
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func imageViewSettings() {
        addImageView1.layer.borderWidth = 1
        addImageView1.layer.borderColor = UIColor.gray.cgColor
        addImageView1.contentMode = .scaleAspectFit
        
        addImageView2.layer.borderWidth = 1
        addImageView2.layer.borderColor = UIColor.gray.cgColor
        addImageView2.contentMode = .scaleAspectFit
        
        addImageView3.layer.borderWidth = 1
        addImageView3.layer.borderColor = UIColor.gray.cgColor
        addImageView3.contentMode = .scaleAspectFit
    }
    
    func didChooseColor(colorName: String) {
        colorText = colorName
        colorTextField.text = colorName
    }
    
    func pickerSettings() {
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        categoryPicker.isHidden = true
        categoryPicker.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        categoryPicker.layer.cornerRadius = 10
    }
    
    func topGestureImage() {
        addImageView1.isUserInteractionEnabled = true
        let image1TapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        addImageView1.addGestureRecognizer(image1TapRecognizer)
        
        categoryTextField.isUserInteractionEnabled = true
        let textFieldTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(categoryTextFieldClicked))
        categoryTextField.addGestureRecognizer(textFieldTapRecognizer)
        
        colorTextField.isUserInteractionEnabled = true
        let colorTextFieldTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(colorTextFieldClicked))
        colorTextField.addGestureRecognizer(colorTextFieldTapRecognizer)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == productNameTextView {
            UIView.animate(withDuration: 0.3) {
                AnimationHelper.animateLabel(label: self.productNameLabel, moveUp: true)
            }
        } else if textView == explanationTextField {
            UIView.animate(withDuration: 0.3) {
                AnimationHelper.animateLabel(label: self.explanationLabel, moveUp: true)
            }
        }
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == productNameTextView {
            if textView.text.isEmpty {
                AnimationHelper.animateLabel(label: self.productNameLabel, moveUp: false)
            }
        } else if textView == explanationTextField {
            if textView.text.isEmpty {
                AnimationHelper.animateLabel(label: self.explanationLabel, moveUp: false)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == brandTextField {
            AnimationHelper.animateLabel(label: self.brandLabel, moveUp: true)
        } else if textField == priceTextField {
            AnimationHelper.animateLabel(label: self.priceLabel, moveUp: true)
        } else if textField == stockQuantityTextField {
            AnimationHelper.animateLabel(label: self.stockQuantityLabel, moveUp: true)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == brandTextField {
            if textField.text?.isEmpty == true {
                AnimationHelper.animateLabel(label: self.brandLabel, moveUp: false)
            }
        } else if textField == priceTextField {
            if textField.text?.isEmpty == true {
                AnimationHelper.animateLabel(label: self.priceLabel, moveUp: false)
            }
        } else if textField == stockQuantityTextField {
            if textField.text?.isEmpty == true {
                AnimationHelper.animateLabel(label: self.stockQuantityLabel, moveUp: false)
            }
        }
    }
    
    func textViewSettings() {
        productNameTextView.delegate = self
        explanationTextField.delegate = self
        
        categoryTextField.layer.borderWidth = 1
        categoryTextField.layer.borderColor = UIColor.gray.cgColor
        categoryTextField.layer.cornerRadius = 5
        setLeftPaddingFor(textField: categoryTextField, padding: 5)
        
        brandTextField.delegate = self
        brandTextField.layer.borderWidth = 1
        brandTextField.layer.borderColor = UIColor.gray.cgColor
        brandTextField.layer.cornerRadius = 5
        setLeftPaddingFor(textField: brandTextField, padding: 5)
        
        colorTextField.layer.borderWidth = 1
        colorTextField.layer.borderColor = UIColor.gray.cgColor
        colorTextField.layer.cornerRadius = 5
        setLeftPaddingFor(textField: colorTextField, padding: 5)
        
        priceTextField.delegate = self
        priceTextField.layer.borderWidth = 1
        priceTextField.layer.borderColor = UIColor.gray.cgColor
        priceTextField.layer.cornerRadius = 5
        priceTextField.keyboardType = .numberPad
        setLeftPaddingFor(textField: priceTextField, padding: 5)
        
        stockQuantityTextField.delegate = self
        stockQuantityTextField.layer.borderWidth = 1
        stockQuantityTextField.layer.borderColor = UIColor.gray.cgColor
        stockQuantityTextField.layer.cornerRadius = 5
        priceTextField.keyboardType = .numberPad
        setLeftPaddingFor(textField: stockQuantityTextField, padding: 5)
    }
    
    func setLeftPaddingFor(textField: UITextField, padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let imageViews = [addImageView1, addImageView2, addImageView3]
        var imageViewIndex = 0
        
        for result in results {
            if imageViewIndex < imageViews.count {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    guard let self = self else { return }
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            imageViews[imageViewIndex].image = image
                            imageViewIndex += 1
                        }
                    }
                }
            }
        }
    }
        
    @objc func selectImage(_ sender: UITapGestureRecognizer) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 3
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage ?? info[.originalImage] as? UIImage {
            selectedImageView?.image = selectedImage
        }
        self.dismiss(animated: true)
    }
    
    func configureUI() {
        view.addSubviewsFromExt(scrollView)
        
        activityIndicator.style = .medium
        
        scrollView.addSubviewsFromExt(contentView, createAdvertButton, activityIndicator)
        contentView.addSubviewsFromExt(stackView, productNameTextView, productNameLabel, explanationTextField, explanationLabel, categoryTextField, categoryLabel, brandTextField, brandLabel, colorTextField, colorLabel, priceTextField, priceLabel, stockQuantityTextField, stockQuantityLabel)
        
        scrollView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, width: view.bounds.size.width)
        
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, bottom: scrollView.bottomAnchor, width: view.bounds.size.width, height: 650)
        
        createAdvertButton.anchor(left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 16, paddingRight: 16, paddingBottom: 16, height: 50)
        
        stackView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
        
        addImageView1.anchor(width: 70, height: 70)
        addImageView2.anchor(width: 70, height: 70)
        addImageView3.anchor(width: 70, height: 70)

        productNameTextView.anchor(top: stackView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingRight: 15, height: 40)
        productNameLabel.anchor(top: productNameTextView.topAnchor, left: productNameTextView.leftAnchor, paddingTop: 10, paddingLeft: 5)

        explanationTextField.anchor(top: productNameTextView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingRight: 15, height: 40)
        explanationLabel.anchor(top: explanationTextField.topAnchor, left: explanationTextField.leftAnchor, paddingTop: 10, paddingLeft: 5)

        categoryTextField.anchor(top: explanationTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingRight: 15, height: 40)
        categoryLabel.anchor(top: categoryTextField.topAnchor, left: categoryTextField.leftAnchor, paddingTop: 10, paddingLeft: 5)

        brandTextField.anchor(top: categoryTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingRight: 15, height: 40)
        brandLabel.anchor(top: brandTextField.topAnchor, left: brandTextField.leftAnchor, paddingTop: 10, paddingLeft: 5)
        
        colorTextField.anchor(top: brandTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingRight: 15, height: 40)
        colorLabel.anchor(top: colorTextField.topAnchor, left: colorTextField.leftAnchor, paddingTop: 10, paddingLeft: 5)
        
        priceTextField.anchor(top: colorTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingRight: 15, height: 40)
        priceLabel.anchor(top: priceTextField.topAnchor, left: priceTextField.leftAnchor, paddingTop: 10, paddingLeft: 5)
        
        stockQuantityTextField.anchor(top: priceTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingRight: 15, height: 40)
        stockQuantityLabel.anchor(top: stockQuantityTextField.topAnchor, left: stockQuantityTextField.leftAnchor, paddingTop: 10, paddingLeft: 5)
        
        activityIndicator.anchor(centerX: createAdvertButton.centerXAnchor, centerY: createAdvertButton.centerYAnchor)
    }
    
    func configureTopBar() {
        view.addSubviewsFromExt(topBarView)
        topBarView.addSubviewsFromExt(infoLabel, backButton)
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        
        infoLabel.anchor(bottom: topBarView.bottomAnchor, centerX: topBarView.centerXAnchor, paddingBottom: 25)
        backButton.anchor(left: topBarView.leftAnchor, bottom: topBarView.bottomAnchor, paddingLeft: 10, paddingBottom: 25)
    }
    
    func addTarget() {
        createAdvertButton.addTarget(self, action: #selector(createAdvertButtonClicked), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    }
    
    @objc func createAdvertButtonClicked() {
        
        guard !productNameTextView.text.isEmpty &&
                  !explanationTextField.text.isEmpty &&
                  !category.isEmpty &&
                  !(brandTextField.text?.isEmpty ?? true) &&
                  !colorText.isEmpty &&
                  !(priceTextField.text?.isEmpty ?? true) &&
                (addImageView1.image != nil || addImageView2.image != nil || addImageView3.image != nil) else {
            
            let alert = UIAlertController(title: "", message: "Lütfen ürünün tüm özelliklerini giriniz", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            self.present(alert, animated: true)
            
            return
        }
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.createAdvertButton.setTitle("", for: .normal)
            self.createAdvertButton.isEnabled = false
        }
        
        let price = Double(priceTextField.text ?? "")
        let stockQuantity = Int(stockQuantityTextField.text ?? "")
        
        newProductViewModel.addProduct(productName: productNameTextView.text ?? "",
                                        explanation: explanationTextField.text ?? "",
                                        category: category,
                                        brand: brandTextField.text ?? "",
                                        color: colorText,
                                        price: price ?? 0,
                                        stockQuantity: stockQuantity ?? 0,
                                        image1: (addImageView1.image) ?? UIImage(),
                                        image2: (addImageView2.image) ?? UIImage(),
                                        image3: (addImageView3.image) ?? UIImage()) { success in
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                self.createAdvertButton.isEnabled = true
                
                if success {
                    self.dismiss(animated: true)
                } else {
                    let alert = UIAlertController(title: "", message: "Ürün yüklemede sorun yaşandı", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    
    @objc func colorTextFieldClicked() {
        UIView.animate(withDuration: 0.3) {
            self.colorLabel.transform = CGAffineTransform(translationX: 0, y: -30)
            self.colorLabel.font = UIFont.systemFont(ofSize: 12)
        }
        
        let selectedColorVC = SelectedColorVC()
        selectedColorVC.delegate = self
        present(selectedColorVC, animated: true)
    }
    
    @objc func categoryTextFieldClicked() {
        UIView.animate(withDuration: 0.3) {
            self.categoryLabel.transform = CGAffineTransform(translationX: 0, y: -30)
            self.categoryLabel.font = UIFont.systemFont(ofSize: 12)
        }
        
        if categoryPicker.isHidden {
            view.addSubview(categoryPicker)
            NSLayoutConstraint.activate([
                categoryPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                categoryPicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                categoryPicker.heightAnchor.constraint(equalToConstant: 200)
            ])
            categoryPicker.isHidden = false
        } else {
            categoryPicker.isHidden = true
        }
    }
    
    @objc func backButtonClicked() {
        dismiss(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = categories[row]
        categoryTextField.text = selectedCategory
        category = selectedCategory
        categoryPicker.isHidden = true
    }

}
