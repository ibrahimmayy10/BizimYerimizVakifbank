//
//  FavoriteVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 31.07.2024.
//

import UIKit
import Lottie

class FavoriteVC: TabBarController, FavoriteTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource {
    
    lazy var topBarView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    
    lazy var favoriteTextLabel = CustomLabels(text: "Favorilerim", font: .boldSystemFont(ofSize: 20), color: .black)
    lazy var alertLabel = CustomLabels(text: "Favorilerinizde ürün bulunmamaktadır", font: .boldSystemFont(ofSize: 20), color: .black)
    
    lazy var tableView = UITableView()
    
    private var animationView = LottieAnimationView(name: "loadingAnimation")
    
    let viewModel = FavoriteViewModel()
    let productDetailsViewModel = ProductDetailsViewModel()
    
    var products = [ProductModel]()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureAnimationView()
        configureTopBar()
        configureBottomBar()
        configureTableView()
        
        toggleUIElementsVisibility(isHidden: true)
        getDataLikeProduct()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedTab = "favorite"
        getDataLikeProduct()
    }
    
    func configureAnimationView() {
        view.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 100, height: 100)
    }
    
    func getDataLikeProduct() {
        alertLabel.isHidden = true
        animationView.isHidden = false
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            viewModel.getLikeProduct { products in
                if let products = products {
                    self.products = products.reversed()
                    
                    if products.isEmpty {
                        self.tableView.isHidden = true
                        self.alertLabel.isHidden = false
                    } else {
                        self.tableView.isHidden = false
                        self.alertLabel.isHidden = true
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.animationView.stop()
                        self.animationView.isHidden = true
                        
                        self.toggleUIElementsVisibility(isHidden: false)
                    }
                } else {
                    self.animationView.stop()
                    self.animationView.isHidden = true
                    self.tableView.isHidden = true
                    self.alertLabel.isHidden = false
                }
            }
        }
    }
    
    func toggleUIElementsVisibility(isHidden: Bool) {
        tableView.isHidden = isHidden
    }
    
    func configureTableView() {
        view.addSubviewsFromExt(tableView, alertLabel)
        
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        alertLabel.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 25, paddingLeft: 10)
        tableView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: bottomBarView.topAnchor)
    }
    
    func configureTopBar() {
        view.addSubview(topBarView)
        topBarView.addSubviewsFromExt(favoriteTextLabel)
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        favoriteTextLabel.anchor(bottom: topBarView.bottomAnchor, centerX: topBarView.centerXAnchor, paddingBottom: 25)
    }
    
    func didTapBuyNowButton(product: ProductModel) {
        let vc = ConfirmCartVC()
        var buyProducts = [ProductModel]()
        buyProducts.append(product)
        vc.products = buyProducts
        vc.totalPrice = product.price
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapAddBasketButton(product: ProductModel) {
        productDetailsViewModel.addProductToCart(productID: product.productID) { success in
            if success {
                let successImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
                successImageView.tintColor = .systemOrange
                successImageView.alpha = 0.0
                successImageView.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(successImageView)
                
                NSLayoutConstraint.activate([
                    successImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    successImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                    successImageView.widthAnchor.constraint(equalToConstant: 100),
                    successImageView.heightAnchor.constraint(equalToConstant: 100)
                ])
                
                UIView.animate(withDuration: 0.5, animations: {
                    successImageView.alpha = 1.0
                }) { _ in
                    UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
                        successImageView.alpha = 0.0
                    }, completion: { _ in
                        successImageView.removeFromSuperview()
                    })
                }
            } else {
                let alert = UIAlertController(title: "", message: "Ürün zaten sepette", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseID, for: indexPath) as! FavoriteTableViewCell
        let product = products[indexPath.row]
        cell.configure(product: product, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) {
            AnimationHelper.animateCell(cell: cell, in: self.view) {
                AnimationHelper.navigateToProductDetailsVC(product: product, from: self.navigationController)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Sil") { [weak self] action, indexPath in
            guard let self = self else { return }
            
            let product = self.products[indexPath.row]
            
            self.viewModel.removeUserFromLikes(productID: product.productID) { success in
                if success {
                    self.products.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    let alert = UIAlertController(title: "Hata", message: "Ürün silinemedi", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
        
        return [deleteAction]
    }

}
