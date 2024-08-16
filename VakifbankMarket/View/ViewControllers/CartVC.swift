//
//  CartVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 1.08.2024.
//

import UIKit
import Lottie

class CartVC: TabBarController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var topBarView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    lazy var bottomBar = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    
    lazy var favoriteTextLabel = CustomLabels(text: "Sepetim", font: .boldSystemFont(ofSize: 20), color: .black)
    lazy var totalLabel = CustomLabels(text: "Toplam", font: .systemFont(ofSize: 14), color: .gray)
    lazy var totalPriceLabel = CustomLabels(text: "", font: .boldSystemFont(ofSize: 16), color: .black)
    lazy var alertLabel = CustomLabels(text: "Sepetinizde ürün bulunmamaktadır", font: .boldSystemFont(ofSize: 20), color: .black)
    
    lazy var confirmCartButton = CustomButtons(title: "Sepeti Onayla", textColor: .white, buttonColor: .systemYellow, radius: 10, imageName: "", buttonTintColor: .white)
    
    private var animationView = LottieAnimationView(name: "loadingAnimation")
    
    lazy var tableView = UITableView()
    
    let viewModel = CartViewModel()
    var products = [ProductModel]()
    
    var productQuantities = [IndexPath: Int]()
    var quantity = Int()
    var totalPrice: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        confirmCartButton.isEnabled = false
        confirmCartButton.backgroundColor = .gray
        
        configureAnimationView()
        configureTopBarView()
        configureBottomBar()
        configureBottomBarView()
        configureTableView()
        addTarget()
        
        toggleUIElementsVisibility(isHidden: true)
        getDataProductsInTheCart()
        calculateTotalPrice()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedTab = "cart"
        getDataProductsInTheCart()
        calculateTotalPrice()
    }
    
    func configureAnimationView() {
        view.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 100, height: 100)
    }
    
    func toggleUIElementsVisibility(isHidden: Bool) {
        tableView.isHidden = isHidden
        bottomBar.isHidden = isHidden
    }
    
    func addTarget() {
        confirmCartButton.addTarget(self, action: #selector(confirmCartButtonClicked), for: .touchUpInside)
    }
    
    @objc func confirmCartButtonClicked() {
        let vc = ConfirmCartVC()
        vc.totalPrice = totalPrice
        vc.products = products
        vc.quantity = quantity
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureBottomBarView() {
        view.addSubview(bottomBar)
        bottomBar.addSubviewsFromExt(totalLabel, totalPriceLabel, confirmCartButton)
        
        bottomBar.anchor(left: view.leftAnchor, right: view.rightAnchor, bottom: bottomBarView.topAnchor, height: 80)
        totalLabel.anchor(top: bottomBar.topAnchor, left: bottomBar.leftAnchor, paddingTop: 20, paddingLeft: 20)
        totalPriceLabel.anchor(top: totalLabel.bottomAnchor, left: bottomBar.leftAnchor, paddingTop: 5, paddingLeft: 20)
        confirmCartButton.anchor(top: bottomBar.topAnchor, right: bottomBar.rightAnchor, paddingTop: 20, paddingRight: 20, width: 160, height: 40)
    }
    
    func calculateTotalPrice() {
        var totalPrice: Double = 0
        
        for (index, cartModel) in products.enumerated() {
            let quantity = productQuantities[IndexPath(row: index, section: 0)] ?? 1
            totalPrice += cartModel.price * Double(quantity)
        }
        
        totalPriceLabel.text = String(format: "%.2f TL", totalPrice)
        self.totalPrice = totalPrice
    }

    
    func getDataProductsInTheCart() {
        self.alertLabel.isHidden = true
        self.animationView.isHidden = false
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            viewModel.getDataProductsInTheCart { cartModels in
                if let cartModels = cartModels {
                    let products = cartModels.compactMap { $0.toProductModel() }
                    
                    if products.isEmpty {
                        self.alertLabel.isHidden = false
                        self.tableView.isHidden = true
                        self.confirmCartButton.isEnabled = false
                        self.confirmCartButton.backgroundColor = .gray
                    } else {
                        self.alertLabel.isHidden = true
                        self.tableView.isHidden = false
                        self.confirmCartButton.isEnabled = true
                        self.confirmCartButton.backgroundColor = .systemYellow
                    }
                    
                    self.products = products.reversed()
                    DispatchQueue.main.async {
                        self.animationView.stop()
                        self.tableView.reloadData()
                        self.calculateTotalPrice()
                        
                        self.animationView.isHidden = true
                        self.toggleUIElementsVisibility(isHidden: products.isEmpty)
                    }
                } else {
                    self.animationView.stop()
                    self.animationView.isHidden = true
                    self.alertLabel.isHidden = false
                    self.confirmCartButton.isEnabled = false
                    self.confirmCartButton.backgroundColor = .gray
                }
                
            }
        }
    }

    
    func configureTableView() {
        view.addSubviewsFromExt(tableView, alertLabel)
        
        alertLabel.textAlignment = .center
        
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        
        alertLabel.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 25)
        tableView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: bottomBar.topAnchor, paddingLeft: 5, paddingRight: 5)
    }
    
    func configureTopBarView() {
        view.addSubview(topBarView)
        topBarView.addSubviewsFromExt(favoriteTextLabel)
                
        topBarView.layer.borderWidth = 1
        topBarView.layer.borderColor = CGColor(red: 224 / 255, green: 224 / 255, blue: 224 / 255, alpha: 1)
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        
        favoriteTextLabel.anchor(bottom: topBarView.bottomAnchor, centerX: topBarView.centerXAnchor, paddingBottom: 25)
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseID, for: indexPath) as! CartTableViewCell
        let product = products[indexPath.row]
        cell.configure(product: product)
        cell.quantity = productQuantities[indexPath] ?? 1
        cell.quantityChanged = { [weak self] newQuantity in
            guard let self = self else { return }
            self.productQuantities[indexPath] = newQuantity
            self.calculateTotalPrice()
         }
        self.quantity = cell.quantity
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
        return 140
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Sil") { [weak self] action, indexPath in
            guard let self = self else { return }
            
            let product = products[indexPath.row]
            
            self.viewModel.removeProductFromCarts(productID: product.productID) { success in
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

extension CartModel {
    func toProductModel() -> ProductModel? {
        return ProductModel(productID: self.product.productID, productName: self.product.productName, explanation: self.product.explanation, category: self.product.category, brand: self.product.brand, color: self.product.color, price: self.product.price, stockQuantity: self.product.stockQuantity, imageUrls: self.product.imageUrls, userID: self.product.userID, likes: self.product.likes)
    }
}
