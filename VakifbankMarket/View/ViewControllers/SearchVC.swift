//
//  SearchVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 24.07.2024.
//

import UIKit
import Firebase
import Lottie

class SearchVC: TabBarController, UITabBarDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var topBarLabel = CustomLabels(text: "Ürün, Marka veya Kategori Ara", font: .boldSystemFont(ofSize: 18), color: .black)
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Ürün, marka veya kategori ara"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    lazy var topBarView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    
    lazy var popularLabel = CustomLabels(text: "Sizin için önerilenler", font: .systemFont(ofSize: 14), color: .black)
        
    lazy var tableView = UITableView()
    
    private var animationView = LottieAnimationView(name: "loadingAnimation")
    
    var products = [ProductModel]()
    var filteredProducts = [ProductModel]()
    
    let viewModel = HomePageViewModel()
    
    var popularProducts = [ProductModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        loadProducts()
        configureAnimationView()
        configureTopBar()
        configureBottomBar()
        configureTableView()
        configureCollectionView()
        
        toggleUIElementsVisibility(isHidden: true)
        getDataProduct()
        
        tableView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedTab = "search"
    }
    
    func configureAnimationView() {
        view.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 100, height: 100)
    }
    
    func toggleUIElementsVisibility(isHidden: Bool) {
        collectionView.isHidden = isHidden
        popularLabel.isHidden = isHidden
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
        view.self.endEditing(true)
    }
    
    func getDataProduct() {
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            viewModel.getRandomCategoryProducts { products in
                self.popularProducts = products ?? []
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.animationView.stop()
                    self.animationView.isHidden = true
                    
                    self.loadProducts()
                    
                    self.toggleUIElementsVisibility(isHidden: false)
                }
            }
        }
    }
    
    func configureCollectionView() {
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseID)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubviewsFromExt(collectionView, popularLabel)
        
        popularLabel.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 10)
        collectionView.anchor(top: popularLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 180)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 300)
    }
    
    func loadProducts() {
        let firestore = Firestore.firestore()
        firestore.collection("Product").getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else if let documents = snapshot?.documents {
                var products = [ProductModel]()
                
                for document in documents {
                    let data = document.data()
                    
                    if let product = ProductModel.createFrom(data) {
                        products.append(product)
                    }
                }
                
                self.products = products
            }
        }
    }
    
    func configureTopBar() {
        view.addSubviewsFromExt(searchBar, topBarView)
        topBarView.addSubview(topBarLabel)
    
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        topBarLabel.anchor(bottom: topBarView.bottomAnchor, centerX: topBarView.centerXAnchor, paddingBottom: 25)
        
        searchBar.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 50)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredProducts.removeAll()
            tableView.reloadData()
            return
        }
        
        filteredProducts = products.filter { product in
            product.productName.lowercased().contains(searchText.lowercased()) ||
            product.brand.lowercased().contains(searchText.lowercased()) ||
            product.category.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1.0
            self.collectionView.alpha = 0.0
            self.popularLabel.alpha = 0.0
        } completion: { _ in
            self.tableView.isHidden = false
            self.collectionView.isHidden = true
            self.popularLabel.isHidden = true
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 0.0
            self.collectionView.alpha = 1.0
            self.popularLabel.alpha = 1.0
        } completion: { _ in
            self.tableView.isHidden = true
            self.collectionView.isHidden = false
            self.popularLabel.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let product = filteredProducts[indexPath.row]
        
        cell.textLabel?.text = product.productName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = filteredProducts[indexPath.row]
        let vc = ProductDetailsVC()
        vc.hidesBottomBarWhenPushed = true
        vc.product = product
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseID, for: indexPath) as! SearchCollectionViewCell
        let product = popularProducts[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = popularProducts[indexPath.row]
        if let cell = collectionView.cellForItem(at: indexPath) {
            AnimationHelper.animateCell(cell: cell, in: self.view) {
                AnimationHelper.navigateToProductDetailsVC(product: product, from: self.navigationController)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 170)
    }
    
}
