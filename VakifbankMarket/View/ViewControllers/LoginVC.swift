//
//  CommercialSigninVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 23.07.2024.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {
    
    lazy var emailTextField = CustomTextFields(isSecureText: false, text: "E-posta Adresiniz")
    lazy var passwordTextField = CustomTextFields(isSecureText: true, text: "Şifreniz")
    
    lazy var emailLabel = CustomLabels(text: "E-posta", font: .boldSystemFont(ofSize: 15), color: .black)
    lazy var passwordLabel = CustomLabels(text: "Şifre", font: .boldSystemFont(ofSize: 15), color: .black)
    
    lazy var registerButton = CustomButtons(title: "Hesap oluştur", textColor: .systemOrange, buttonColor: .white, radius: 0, imageName: "", buttonTintColor: .white)
    lazy var loginButton = CustomButtons(title: "Giriş yap", textColor: .white, buttonColor: .gray, radius: 10, imageName: "", buttonTintColor: .white)
    
    lazy var label = CustomLabels(text: "Bizim Yerimiz", font: .italicSystemFont(ofSize: 25), color: .white)
    
    lazy var imageView = CustomImageViews()
    lazy var vakifImageView = CustomImageViews()
    
    lazy var topBarView = CustomViews(color: .darkGray)
    
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
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var activityIndicator = ActivityIndicators(indicatorColor: .white)
    
    var loginViewModel = LoginViewModel()
    var keyboardHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        configureTopBar()
        textFieldSettings()
        addTarget()
        configureUI()
        
        textFieldDidChangeSelection(emailTextField)
        
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
            if emailTextField.isFirstResponder {
                activeField = emailTextField
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
        UIView.animate(withDuration: 0.25) {
            let contentInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldSettings() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.gray.cgColor
        
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        
        setLeftPaddingFor(textField: emailTextField, padding: 16)
        setLeftPaddingFor(textField: passwordTextField, padding: 16)
    }
    
    func setLeftPaddingFor(textField: UITextField, padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let isEmailValid = !(emailTextField.text?.isEmpty ?? true)
        let isPasswordValid = !(passwordTextField.text?.isEmpty ?? true) && (passwordTextField.text?.count ?? 0) >= 6
        
        if isEmailValid && isPasswordValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .systemYellow
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .gray
        }
    }
    
    func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubviewsFromExt(contentView, registerButton)
        contentView.addSubviewsFromExt(vakifImageView, emailLabel, passwordLabel, emailTextField, passwordTextField, loginButton, activityIndicator)
        
        scrollView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, width: view.bounds.size.width)
        
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, bottom: scrollView.bottomAnchor, width: view.bounds.size.width)
        contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        activityIndicator.style = .medium
        
        vakifImageView.image = UIImage(named: "vakif")
        vakifImageView.anchor(top: contentView.topAnchor, centerX: contentView.centerXAnchor, paddingTop: 60, width: 100, height: 90)
        
        emailLabel.anchor(top: vakifImageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15)
        emailTextField.anchor(top: emailLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingRight: 15, height: 40)
        
        passwordLabel.anchor(top: emailTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 15)
        passwordTextField.anchor(top: passwordLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingRight: 15, height: 40)
        
        loginButton.anchor(top: passwordTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 30, paddingLeft: 15, paddingRight: 15, height: 40)
        
        activityIndicator.anchor(centerX: loginButton.centerXAnchor, centerY: loginButton.centerYAnchor)
        
        registerButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.centerXAnchor)
    }
    
    func configureTopBar() {
        view.addSubviewsFromExt(topBarView)
        topBarView.addSubviewsFromExt(stackView)
        
        imageView.image = UIImage(named: "vakif")
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        
        stackView.anchor(bottom: topBarView.bottomAnchor, centerX: topBarView.centerXAnchor, paddingBottom: 25)
        
        imageView.anchor(width: 30, height: 20)
    }
    
    func addTarget() {
        registerButton.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
    }
    
    @objc func loginButtonClicked() {
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.loginButton.isEnabled = false
            self.loginButton.setTitle("", for: .normal)
        }
        
        let email = emailTextField.text ?? ""
        
        if !email.contains("@") || !email.contains(".") || !email.contains("@vakifbank.com.tr") {
            self.showAlert(message: "Lütfen Vakıfbank' a ait bir e-posta adresi giriniz")
            self.activityIndicator.stopAnimating()
            self.loginButton.setTitle("Giriş yap", for: .normal)
            self.loginButton.isEnabled = true
        } else {
            loginViewModel.commercialLogin(email: email, password: passwordTextField.text ?? "") { success in
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.loginButton.isEnabled = true
                    self.loginButton.setTitle("Giriş yap", for: .normal)
                }
                
                if success {
                    self.navigationController?.pushViewController(HomePageVC(), animated: true)
                } else {
                    self.showAlert(message: "Giriş başarısız")
                    self.activityIndicator.stopAnimating()
                    self.loginButton.isEnabled = true
                    self.loginButton.setTitle("Giriş yap", for: .normal)
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    @objc func registerButtonClicked() {
        navigationController?.pushViewController(RegisterVC(), animated: true)
    }
    
}
