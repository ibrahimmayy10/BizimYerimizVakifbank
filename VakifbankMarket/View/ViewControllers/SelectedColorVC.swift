//
//  SelectedColorVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 25.07.2024.
//

import UIKit

class SelectedColorVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var colors = [ColorModel(color: .black, colorName: "Siyah"),
                  ColorModel(color: .white, colorName: "Beyaz"),
                  ColorModel(color: .red, colorName: "Kırmızı"),
                  ColorModel(color: .gray, colorName: "Gri"),
                  ColorModel(color: .green, colorName: "Yeşil"),
                  ColorModel(color: .brown, colorName: "Kahverengi"),
                  ColorModel(color: .blue, colorName: "Mavi"),
                  ColorModel(color: .purple, colorName: "Mor"),
                  ColorModel(color: .systemPink, colorName: "Pembe"),
                  ColorModel(color: .yellow, colorName: "Sarı"),
                  ColorModel(color: .orange, colorName: "Turuncu")]
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    lazy var topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var backButton = CustomButtons(title: "", textColor: .white, buttonColor: UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0), radius: 0, imageName: "xmark", buttonTintColor: .black)
    
    lazy var label = CustomLabels(text: "Renk Seçin", font: .boldSystemFont(ofSize: 20), color: .black)
    
    weak var delegate: SelectedColorDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        
        configureTopBar()
        configureCollectionView()
        collectionView.register(SelectedColorCollectionViewCell.self, forCellWithReuseIdentifier: SelectedColorCollectionViewCell.reuseID)
        
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
    }
    
    @objc func backButtonClicked() {
        dismiss(animated: true)
    }
    
    func configureTopBar() {
        view.addSubviewsFromExt(topBarView)
        topBarView.addSubviewsFromExt(backButton, label)
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        label.anchor(centerX: topBarView.centerXAnchor, centerY: topBarView.centerYAnchor)
        backButton.anchor(left: topBarView.leftAnchor, centerY: topBarView.centerYAnchor, paddingLeft: 10)
    }
    
    func configureCollectionView() {
        view.addSubviewsFromExt(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: 15)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedColorCollectionViewCell.reuseID, for: indexPath) as! SelectedColorCollectionViewCell
        let color = colors[indexPath.row]
        cell.imageView.tintColor = color.color
        cell.colorLabel.text = color.colorName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = colors[indexPath.row]
        delegate?.didChooseColor(colorName: color.colorName)
        dismiss(animated: true)
    }

}
