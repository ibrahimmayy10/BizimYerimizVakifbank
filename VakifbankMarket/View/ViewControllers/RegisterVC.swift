//
//  CommercialRegisterVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 23.07.2024.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    lazy var label = CustomLabels(text: "Bizim Yerimiz Kayıt Formu", font: .boldSystemFont(ofSize: 20), color: .white)
    
    lazy var nameSurnameTextField = CustomTextFields(isSecureText: false, text: "Adınız Soyadınız")
    lazy var emailTextField = CustomTextFields(isSecureText: false, text: "E-posta Adresiniz")
    lazy var telNoTextField = CustomTextFields(isSecureText: false, text: "Cep Telefonunuz")
    lazy var passwordTextField = CustomTextFields(isSecureText: true, text: "Şifreniz")
    
    lazy var nameSurnameLabel = CustomLabels(text: "Ad Soyad", font: .boldSystemFont(ofSize: 15), color: .black)
    lazy var emailLabel = CustomLabels(text: "E-posta", font: .boldSystemFont(ofSize: 15), color: .black)
    lazy var telNoLabel = CustomLabels(text: "Cep Telefonu", font: .boldSystemFont(ofSize: 15), color: .black)
    lazy var passwordLabel = CustomLabels(text: "Şifre", font: .boldSystemFont(ofSize: 15), color: .black)
    
    lazy var registerButton = CustomButtons(title: "Kayıt ol", textColor: .white, buttonColor: .gray, radius: 10, imageName: "", buttonTintColor: .white)
    lazy var backButton = CustomButtons(title: "", textColor: .white, buttonColor: .darkGray, radius: 0, imageName: "xmark", buttonTintColor: .white)
    
    lazy var imageView = CustomImageViews()
    
    lazy var topBarView = CustomViews(color: .darkGray)
    
    lazy var activityIndicator = ActivityIndicators(indicatorColor: .white)
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
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
    
    var registerViewModel = RegisterViewModel()
    var loginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        configureTopBar()
        textFieldSettings()
        configureUI()
        addTarget()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            var activeField: UIView?
            if nameSurnameTextField.isFirstResponder {
                activeField = nameSurnameTextField
            } else if emailTextField.isFirstResponder {
                activeField = emailTextField
            } else if telNoTextField.isFirstResponder {
                activeField = telNoTextField
            } else if passwordTextField.isFirstResponder {
                activeField = passwordTextField
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
    
    func textFieldSettings() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nameSurnameTextField.delegate = self
        telNoTextField.delegate = self
        
        nameSurnameTextField.layer.cornerRadius = 5
        nameSurnameTextField.layer.borderWidth = 1
        nameSurnameTextField.layer.borderColor = UIColor.gray.cgColor
        
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.gray.cgColor
        
        telNoTextField.layer.cornerRadius = 5
        telNoTextField.layer.borderWidth = 1
        telNoTextField.layer.borderColor = UIColor.gray.cgColor
        
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        
        setLeftPaddingFor(textField: nameSurnameTextField, padding: 16)
        setLeftPaddingFor(textField: emailTextField, padding: 16)
        setLeftPaddingFor(textField: telNoTextField, padding: 16)
        setLeftPaddingFor(textField: passwordTextField, padding: 16)
    }
    
    func setLeftPaddingFor(textField: UITextField, padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let isEmailValid = !(emailTextField.text?.isEmpty ?? true)
        let isNameSurnameValid = !(nameSurnameTextField.text?.isEmpty ?? true)
        let isTelNoValid = !(telNoTextField.text?.isEmpty ?? true) && (telNoTextField.text?.count ?? 0) >= 11
        let isPasswordValid = !(passwordTextField.text?.isEmpty ?? true) && (passwordTextField.text?.count ?? 0) >= 6
        
        if isEmailValid && isPasswordValid && isTelNoValid && isNameSurnameValid {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .systemYellow
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .gray
        }
    }
    
    func addTarget() {
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
    }
    
    @objc func registerButtonClicked() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.registerButton.isEnabled = false
            self.registerButton.setTitle("", for: .normal)
        }
        let email = emailTextField.text ?? ""
        
        if !email.contains("@") || !email.contains(".") || !email.contains("@vakifbank.com.tr") {
            self.showAlert(message: "Lütfen Vakıfbank' a ait bir e-posta adresi giriniz")
        } else {
            registerViewModel.commercialRegister(nameSurname: nameSurnameTextField.text ?? "", email: emailTextField.text ?? "", telNo: telNoTextField.text ?? "", password: passwordTextField.text ?? "") { success in
                if success {
                    self.loginViewModel.commercialLogin(email: email, password: self.passwordTextField.text ?? "") { success in
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.registerButton.isEnabled = true
                            self.registerButton.setTitle("Kayıt ol", for: .normal)
                        }
                        
                        if success {
                            self.navigationController?.pushViewController(HomePageVC(), animated: true)
                        } else {
                            self.showAlert(message: "Giriş işlemi başarısız")
                        }
                    }
                } else {
                    self.showAlert(message: "Kayıt başarısız")
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureTopBar() {
        view.addSubviewsFromExt(topBarView)
        topBarView.addSubviewsFromExt(backButton, stackView)
        
        imageView.image = UIImage(named: "vakif")
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        
        stackView.anchor(bottom: topBarView.bottomAnchor, centerX: topBarView.centerXAnchor, paddingBottom: 25)
        
        imageView.anchor(width: 30, height: 20)
        
        backButton.anchor(left: topBarView.leftAnchor, bottom: topBarView.bottomAnchor, paddingLeft: 10, paddingBottom: 25)
    }
    
    func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubviewsFromExt(contentView)
        contentView.addSubviewsFromExt(nameSurnameLabel, emailLabel, telNoLabel, passwordLabel, nameSurnameTextField, emailTextField, telNoTextField, passwordTextField, registerButton, activityIndicator)
        
        scrollView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, width: view.bounds.size.width)
        
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, bottom: scrollView.bottomAnchor, width: view.bounds.size.width)
        contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        activityIndicator.style = .medium
        
        nameSurnameLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15)
        nameSurnameTextField.anchor(top: nameSurnameLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingRight: 15, height: 40)
        
        emailLabel.anchor(top: nameSurnameTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15)
        emailTextField.anchor(top: emailLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingRight: 15, height: 40)
        
        telNoLabel.anchor(top: emailTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15)
        telNoTextField.anchor(top: telNoLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingRight: 15, height: 40)
        
        passwordLabel.anchor(top: telNoTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingRight: 15)
        passwordTextField.anchor(top: passwordLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingRight: 15, height: 40)
        
        registerButton.anchor(top: passwordTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 30, paddingLeft: 15, paddingRight: 15, height: 40)
        
        activityIndicator.anchor(centerX: registerButton.centerXAnchor, centerY: registerButton.centerYAnchor)
    }

}
