//
//  NotificationVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 12.08.2024.
//

import UIKit
import Firebase

class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var topBarView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    
    lazy var backButton = CustomButtons(title: "", textColor: .white, buttonColor: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1), radius: 0, imageName: "xmark", buttonTintColor: .black)
    
    lazy var notificationLabel = CustomLabels(text: "Bildirimler", font: .boldSystemFont(ofSize: 18), color: .black)
    lazy var alertLabel = CustomLabels(text: "Bildiriminiz bulunmamaktadır", font: .boldSystemFont(ofSize: 20), color: .black)
    
    lazy var tableView = UITableView()
    
    var products = [ProductModel]()
    var viewModel = AccountViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        getDataProductsSold()
        configureTopBar()
        configureTableView()
        addTarget()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataProductsSold()
    }
    
    func getDataProductsSold() {
        viewModel.getDataConfirmedOrders { products in
            if let products = products {
                self.products = products
                
                if products.isEmpty {
                    self.tableView.isHidden = true
                    self.alertLabel.isHidden = false
                } else {
                    self.tableView.isHidden = false
                    self.alertLabel.isHidden = true
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                self.tableView.isHidden = true
                self.alertLabel.isHidden = false
            }
        }
    }
    
    func configureTopBar() {
        view.addSubview(topBarView)
        topBarView.addSubviewsFromExt(backButton, notificationLabel)
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        backButton.anchor(left: topBarView.leftAnchor, bottom: topBarView.bottomAnchor, paddingLeft: 10, paddingBottom: 25)
        notificationLabel.anchor(bottom: topBarView.bottomAnchor, centerX: topBarView.centerXAnchor, paddingBottom: 25)
    }
    
    func configureTableView() {
        view.addSubviewsFromExt(tableView, alertLabel)
                
        tableView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: NotificationsTableViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        
        alertLabel.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 25, paddingLeft: 10)
        tableView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
    }
    
    func addTarget() {
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    }
    
    func showProductAlert(for product: ProductModel) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 60, height: 100))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.sd_setImage(with: URL(string: product.imageUrls.first ?? ""))
        
        let brandLabel = UILabel(frame: CGRect(x: 80, y: 10, width: 80, height: 20))
        brandLabel.font = UIFont.boldSystemFont(ofSize: 16)
        brandLabel.text = product.brand
        
        let nameLabel = UILabel(frame: CGRect(x: 80, y: 40, width: 160, height: 50))
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.text = product.productName
        
        alertController.view.addSubview(imageView)
        alertController.view.addSubview(brandLabel)
        alertController.view.addSubview(nameLabel)
        
        alertController.addAction(UIAlertAction(title: "Onayla", style: .default, handler: { action in
            self.confirmSale(product: product, completion: {
                if let index = self.products.firstIndex(where: { $0.productID == product.productID }) {
                    self.products.remove(at: index)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                alertController.dismiss(animated: true)
            })
        }))
        
        alertController.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        alertController.view.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        present(alertController, animated: true)
    }
    
    func confirmOrder(product: ProductModel) {
        guard let user = Auth.auth().currentUser else { return }
        let currentUserID = user.uid
        
        let firestore = Firestore.firestore()
        
        firestore.collection("Orders").whereField("productID", isEqualTo: product.productID).whereField("salesID", isEqualTo: currentUserID).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else if let documents = snapshot?.documents {
                for document in documents {
                    let documentID = document.documentID
                    
                    firestore.collection("Orders").document(documentID).updateData(["confirm": true]) { error in
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                        } else {
                            print("confirm true olarak güncellendi")
                        }
                    }
                }
            }
        }
    }
    
    func confirmSale(product: ProductModel, completion: @escaping () -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let currentUserID = user.uid
        
        let firestore = Firestore.firestore()
        
        firestore.collection("Sales").whereField("productID", isEqualTo: product.productID).whereField("salesID", isEqualTo: currentUserID).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            } else if let documents = snapshot?.documents {
                for document in documents {
                    let documentID = document.documentID
                    
                    firestore.collection("Sales").document(documentID).updateData(["confirm": true]) { error in
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                        } else {
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
                                    completion()
                                })
                            }
                            
                            self.confirmOrder(product: product)
                        }
                    }
                }
            }
        }
    }
    
    @objc func backButtonClicked() {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsTableViewCell.reuseID, for: indexPath) as! NotificationsTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        showProductAlert(for: product)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

}
