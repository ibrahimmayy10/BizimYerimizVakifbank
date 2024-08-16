//
//  AddAddressVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 5.08.2024.
//

import UIKit

class AddAddressVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    lazy var topBarView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    
    lazy var provinceTextField = CustomTextFields(isSecureText: false, text: "")
    lazy var districtTextField = CustomTextFields(isSecureText: false, text: "")
    
    lazy var addressTextView = CustomTextViews()
    
    lazy var addAddressLabel = CustomLabels(text: "Adres Ekle", font: .boldSystemFont(ofSize: 18), color: .black)
    lazy var provinceLabel = CustomLabels(text: "İl Seçiniz", font: .systemFont(ofSize: 17), color: .black)
    lazy var districtLabel = CustomLabels(text: "İlçe Seçiniz", font: .systemFont(ofSize: 17), color: .black)
    lazy var addressLabel = CustomLabels(text: "Detaylı Adres", font: .systemFont(ofSize: 17), color: .black)
    
    lazy var backButton = CustomButtons(title: "", textColor: .white, buttonColor: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1), radius: 0, imageName: "xmark", buttonTintColor: .black)
    lazy var saveButton = CustomButtons(title: "Kaydet", textColor: .white, buttonColor: .systemYellow, radius: 10, imageName: "", buttonTintColor: .white)
    
    lazy var provincesPickerView = UIPickerView()
    lazy var districtsPickerView = UIPickerView()
    
    let provincesViewModel = ProvincesViewModel()
    var provinceData = [ProvinceData]()
    var districts = [Districts]()
    
    let viewModel = AddAddressViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureTopBar()
        textFieldSettings()
        configureUI()
        addTarget()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        provincesPickerView.delegate = self
        provincesPickerView.dataSource = self
        
        provincesViewModel.getDataProvinces { [weak self] provinces in
            DispatchQueue.main.async {
                self?.provinceData = provinces ?? []
                self?.provincesPickerView.reloadAllComponents()
            }
        }
                
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addTarget() {
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    }
    
    @objc func saveButtonClicked() {
        viewModel.addAddress(province: provinceTextField.text ?? "", district: districtTextField.text ?? "", address: addressTextView.text)
        dismiss(animated: true)
    }
    
    func showDistrictPicker() {
        let pickerVC = UIViewController()
        pickerVC.preferredContentSize = CGSize(width: view.frame.width, height: 250)
        
        districtsPickerView = UIPickerView()
        districtsPickerView.delegate = self
        districtsPickerView.dataSource = self
        
        districtsPickerView.frame = CGRect(x: 0, y: 0, width: pickerVC.view.frame.width, height: 250)
        pickerVC.view.addSubview(districtsPickerView)
        
        districtsPickerView.reloadAllComponents()
        
        let alert = UIAlertController(title: "İlçe Seçiniz", message: nil, preferredStyle: .actionSheet)
        alert.setValue(pickerVC, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "Seç", style: .default, handler: { _ in
            let selectedRow = self.districtsPickerView.selectedRow(inComponent: 0)
            self.districtTextField.text = self.districts[selectedRow].name
            self.view.endEditing(true)
        }))
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: { _ in
            self.view.endEditing(true)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showProvincesPicker() {
        let pickerVC = UIViewController()
        pickerVC.preferredContentSize = CGSize(width: view.frame.width, height: 250)
        
        provincesPickerView = UIPickerView()
        provincesPickerView.delegate = self
        provincesPickerView.dataSource = self
        
        provincesPickerView.frame = CGRect(x: 0, y: 0, width: pickerVC.view.frame.width, height: 250)
        pickerVC.view.addSubview(provincesPickerView)
        
        let alert = UIAlertController(title: "İl Seçiniz", message: nil, preferredStyle: .actionSheet)
        alert.setValue(pickerVC, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "Seç", style: .default, handler: { _ in
            let selectedRow = self.provincesPickerView.selectedRow(inComponent: 0)
            self.provinceTextField.text = self.provinceData[selectedRow].name
            self.view.endEditing(true)
        }))
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: { _ in
            self.view.endEditing(true)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func backButtonClicked() {
        dismiss(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == provinceTextField {
            showProvincesPicker()
            AnimationHelper.animateLabel(label: provinceLabel, moveUp: true)
        } else if textField == districtTextField {
            if let selectedProvince = provinceTextField.text {
                provincesViewModel.getDataDistricts(for: selectedProvince) { [weak self] districts in
                    DispatchQueue.main.async {
                        self?.districts = districts ?? []
                        self?.districtsPickerView.reloadAllComponents()
                        self?.showDistrictPicker()
                    }
                }
            } else {
                let alert = UIAlertController(title: "Hata", message: "Lütfen önce il seçiniz.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            
            AnimationHelper.animateLabel(label: districtLabel, moveUp: true)
        }
    }
       
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == provinceTextField {
            if textField.text?.isEmpty == true {
                AnimationHelper.animateLabel(label: provinceLabel, moveUp: false)
            }
        } else if textField == districtTextField {
            if textField.text?.isEmpty == true {
                AnimationHelper.animateLabel(label: districtLabel, moveUp: false)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        AnimationHelper.animateLabel(label: addressLabel, moveUp: true)
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        AnimationHelper.animateLabel(label: addressLabel, moveUp: false)
    }
    
    func textFieldSettings() {
        provinceTextField.delegate = self
        provinceTextField.layer.borderWidth = 1
        provinceTextField.layer.borderColor = UIColor.gray.cgColor
        provinceTextField.layer.cornerRadius = 5
        provinceTextField.keyboardType = .numberPad
        setLeftPaddingFor(textField: provinceTextField, padding: 5)
        
        districtTextField.delegate = self
        districtTextField.layer.borderWidth = 1
        districtTextField.layer.borderColor = UIColor.gray.cgColor
        districtTextField.layer.cornerRadius = 5
        districtTextField.keyboardType = .numberPad
        setLeftPaddingFor(textField: districtTextField, padding: 5)
        
        addressTextView.delegate = self
    }
    
    func setLeftPaddingFor(textField: UITextField, padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    func configureTopBar() {
        view.addSubview(topBarView)
        topBarView.addSubviewsFromExt(backButton, addAddressLabel)
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        backButton.anchor(left: topBarView.leftAnchor, bottom: topBarView.bottomAnchor, paddingLeft: 10, paddingBottom: 25)
        addAddressLabel.anchor(bottom: topBarView.bottomAnchor, centerX: topBarView.centerXAnchor, paddingBottom: 25)
    }
    
    func configureUI() {
        view.addSubviewsFromExt(provinceTextField, provinceLabel, districtTextField, districtLabel, addressTextView, addressLabel, saveButton)
        
        provinceTextField.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingRight: 15, height: 40)
        provinceLabel.anchor(top: provinceTextField.topAnchor, left: provinceTextField.leftAnchor, paddingTop: 10, paddingLeft: 5)
        
        districtTextField.anchor(top: provinceTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingRight: 15, height: 40)
        districtLabel.anchor(top: districtTextField.topAnchor, left: districtTextField.leftAnchor, paddingTop: 10, paddingLeft: 5)
        
        addressTextView.anchor(top: districtTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingRight: 15, height: 40)
        addressLabel.anchor(top: addressTextView.topAnchor, left: addressTextView.leftAnchor, paddingTop: 10, paddingLeft: 5)
        
        saveButton.anchor(left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingLeft: 15, paddingRight: 15, paddingBottom: 35, height: 50)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == provincesPickerView {
            return provinceData.count
        } else if pickerView == districtsPickerView {
            return districts.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == provincesPickerView {
            return provinceData[row].name
        } else if pickerView == districtsPickerView {
            return districts[row].name
        } else {
            return ""
        }
    }
    
}
