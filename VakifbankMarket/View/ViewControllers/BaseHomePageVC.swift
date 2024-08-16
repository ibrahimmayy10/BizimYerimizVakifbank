//
//  BaseHomePageVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 1.08.2024.
//

import UIKit

class BaseHomePageVC: TabBarController {
    
    lazy var welcomeLabel = CustomLabels(text: "Hoş geldiniz,", font: .systemFont(ofSize: 16), color: .white)
    lazy var vakifbankLabel = CustomLabels(text: "Bizim Yerimiz", font: .boldSystemFont(ofSize: 20), color: .systemYellow)
    lazy var popularProductsLabel = CustomLabels(text: "En Beğenilen Ürünler", font: .boldSystemFont(ofSize: 20), color: .black)
    lazy var specialForYouLabel = CustomLabels(text: "Sana Özel Ürünler", font: .boldSystemFont(ofSize: 20), color: .black)
    lazy var mostPopularProductsLabel = CustomLabels(text: "Listedeki Ürünlerin", font: .boldSystemFont(ofSize: 20), color: .black)
    
    lazy var topBarView = CustomViews(color: .darkGray)
    lazy var contentView = CustomViews(color: .white)
    
    let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let popularProductsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let specialForYouProductsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let advertCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let advert2CollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let mostPopularCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func configureTopBar() {
        view.addSubviewsFromExt(topBarView)
        topBarView.addSubviewsFromExt(welcomeLabel, vakifbankLabel)

        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        
        welcomeLabel.anchor(left: topBarView.leftAnchor, centerY: topBarView.centerYAnchor, paddingLeft: 16)
        vakifbankLabel.anchor(top: welcomeLabel.bottomAnchor, left: topBarView.leftAnchor, paddingLeft: 16)
    }
    
    func configureScrollView() {
        view.addSubviewsFromExt(scrollView)
        scrollView.addSubviewsFromExt(contentView)
        contentView.addSubviewsFromExt(categoryCollectionView, popularProductsLabel, popularProductsCollectionView, advertCollectionView, specialForYouLabel, specialForYouProductsCollectionView, mostPopularProductsLabel, mostPopularCollectionView, advert2CollectionView)
        
        scrollView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: bottomBarView.topAnchor)
        
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, bottom: scrollView.bottomAnchor, width: view.bounds.size.width, height: 1570)
        
        categoryCollectionView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 5, height: 125)
        
        popularProductsLabel.anchor(top: categoryCollectionView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10)
        popularProductsCollectionView.anchor(top: popularProductsLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 330)

        advertCollectionView.anchor(top: popularProductsCollectionView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingRight: 5, height: 140)
        
        specialForYouLabel.anchor(top: advertCollectionView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10)
        specialForYouProductsCollectionView.anchor(top: specialForYouLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 330)
        
        mostPopularProductsLabel.anchor(top: specialForYouProductsCollectionView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        mostPopularCollectionView.anchor(top: mostPopularProductsLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingRight: 5, height: 330)
        
        advert2CollectionView.anchor(top: mostPopularCollectionView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingRight: 5, height: 140)
    }

}
