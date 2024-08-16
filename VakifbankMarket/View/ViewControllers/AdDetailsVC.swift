//
//  AdDetailsVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 29.07.2024.
//

import UIKit

class AdDetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var allProductsLabel = CustomLabels(text: "", font: .boldSystemFont(ofSize: 18), color: .black)
    
    lazy var activityIndicator = ActivityIndicators(indicatorColor: .darkGray)
    
    lazy var topBarView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    
    lazy var backButton = CustomButtons(title: "", textColor: .white, buttonColor: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1), radius: 0, imageName: "chevron.backward", buttonTintColor: .black)
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
        
    var advert: Advert?
    var products = [ProductModel]()
    var category: String?
    
    var viewModel = AdDetailsViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureActivityIndicator()
        getDataAdProducts()
        configureTopBar()
        configureCollectionView()
        
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataAdProducts()
        configureActivityIndicator()
    }
    
    func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.style = .large
        activityIndicator.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 100, height: 100)
    }
    
    func getDataAdProducts() {
        if let advert = advert {
            activityIndicator.startAnimating()
            
            viewModel.getDataAdProducts(brand: advert.brandName) { products in
                self.products = products ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        } else if let category = category {
            activityIndicator.startAnimating()
            
            viewModel.getDataSelectedCategoryProducts(category: category) { products in
                self.products = products ?? []
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func configureTopBar() {
        if let advert = advert {
            allProductsLabel.text = "\(advert.brandName) Tüm Ürünler"
        } else if let category = category {
            allProductsLabel.text = "\(category) Tüm Ürünler"
        }
        
        view.addSubview(topBarView)
        topBarView.addSubviewsFromExt(backButton, allProductsLabel)
        
        let originalImage = UIImage(systemName: "chevron.backward")
        let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        backButton.setImage(resizedImage, for: .normal)
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        backButton.anchor(left: topBarView.leftAnchor, bottom: topBarView.bottomAnchor, paddingLeft: 10, paddingBottom: 25)
        allProductsLabel.anchor(bottom: topBarView.bottomAnchor, centerX: topBarView.centerXAnchor, paddingBottom: 25)
    }
    
    func configureCollectionView() {
        view.addSubviewsFromExt(collectionView)
        
        collectionView.register(AdDetailsCollectionViewCell.self, forCellWithReuseIdentifier: AdDetailsCollectionViewCell.reuseID)
                
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingRight: 5)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdDetailsCollectionViewCell.reuseID, for: indexPath) as! AdDetailsCollectionViewCell
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
        let padding: CGFloat = 20
        let collectionViewSize = collectionView.frame.size.width - padding
        let itemWidth = collectionViewSize / 2
        let itemHeight: CGFloat = 350
        
        return CGSize(width: itemWidth, height: itemHeight)
    }

}
