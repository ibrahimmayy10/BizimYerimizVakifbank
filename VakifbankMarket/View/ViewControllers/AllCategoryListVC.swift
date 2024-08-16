//
//  AllCategoryListVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 13.08.2024.
//

import UIKit

class AllCategoryListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var categoryLabel = CustomLabels(text: "Tüm Kategoriler", font: .boldSystemFont(ofSize: 18), color: .black)
    
    lazy var topBarView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    
    lazy var backButton = CustomButtons(title: "", textColor: .white, buttonColor: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1), radius: 0, imageName: "chevron.backward", buttonTintColor: .black)
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    var categories = [
        Category(text: "Giyim", imageName: "tshirt"),
        Category(text: "Ayakkabı", imageName: "ayakkabi"),
        Category(text: "Elektronik", imageName: "electronics"),
        Category(text: "Aksesuar", imageName: "jewellery"),
        Category(text: "Gözlük", imageName: "gozluk"),
        Category(text: "Çanta", imageName: "bag"),
        Category(text: "Saat", imageName: "saat"),
        Category(text: "Müzik Aleti", imageName: "guitar"),
        Category(text: "Kozmetik", imageName: "kozmetik"),
        Category(text: "Oyuncak", imageName: "toy"),
        Category(text: "Kitap & Kırtasiye", imageName: "book"),
        Category(text: "Ev Eşyaları", imageName: "koltuk")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .white
        
        configureTopBar()
        configureCategoryCollectionView()
        
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureCategoryCollectionView() {
        collectionView.register(CategoryListCollectionViewCell.self, forCellWithReuseIdentifier: CategoryListCollectionViewCell.reuseID)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        collectionView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
    }
    
    func configureTopBar() {
        view.addSubview(topBarView)
        topBarView.addSubviewsFromExt(backButton, categoryLabel)
        
        let originalImage = UIImage(systemName: "chevron.backward")
        let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        backButton.setImage(resizedImage, for: .normal)
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        backButton.anchor(left: topBarView.leftAnchor, bottom: topBarView.bottomAnchor, paddingLeft: 10, paddingBottom: 25)
        categoryLabel.anchor(bottom: topBarView.bottomAnchor, centerX: topBarView.centerXAnchor, paddingBottom: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryListCollectionViewCell.reuseID, for: indexPath) as! CategoryListCollectionViewCell
        let category = categories[indexPath.row]
        cell.configure(with: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AdDetailsVC()
        let category = categories[indexPath.row]
        vc.category = category.text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }

}
