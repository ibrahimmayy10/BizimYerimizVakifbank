//
//  ProductDetailsVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 28.07.2024.
//

import UIKit

class ProductDetailsVC: BaseProductDetailsVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    var product: ProductModel?
    var isLoading = true
    var isExpanded = false
    
    let viewModel = ProductDetailsViewModel()
    var evaluates = [EvaluateModel]()
    var products = [ProductModel]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        scrollView.delegate = self
        
        guard let product = product else { return }
        products.append(product)
                                
        getDataEvaluate()
        getDataPoint()
        configureImagesCollectionView()
        configureReviewsCollectionView()
        configureTopBarView()
        configureScrollView()
        itemsSetting()
        fillItems()
        configureBottomBarView()
        buttonSettings()
        addTarget()
        isProductLiked()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureBottomBarView()
    }
    
    @objc func cartButtonClicked() {
        navigationController?.pushViewController(CartVC(), animated: true)
    }
    
    func getDataPoint() {
        viewModel.getAverageRating(productID: product?.productID ?? "") { point in
            self.pointLabel1.text = String(point ?? 0)
            if point != nil {
                self.pointLabel2.text = String(point ?? 0)
                self.contentView.anchor(height: 1350)
            } else {
                self.pointLabel2.text = "Ürünle ilgili değerlendirme bulunmamaktadır"
                self.contentView.anchor(height: 1150)
            }
        }
    }
    
    func getDataEvaluate() {
        viewModel.getDataEvaluate(productID: product?.productID ?? "") { evaluates in
            guard let evaluates = evaluates else { return }
            self.evaluationLabel.text = "| \(String(describing: evaluates.count)) değerlendirme"
            
            self.evaluates = evaluates
            
            DispatchQueue.main.async {
                self.reviewsCollectionView.reloadData()
            }
        }
    }
    
    @objc func addProductToCartButtonClicked() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.addProductToCartButton.setTitle("", for: .normal)
            self.addProductToCartButton.isEnabled = true
        }
        
        guard let productID = product?.productID else { return }
        viewModel.addProductToCart(productID: productID) { success in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.addProductToCartButton.setTitle("Sepete Ekle", for: .normal)
                
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
    }
    
    func buttonSettings() {
        guard let explanation = product?.explanation else { return }
        readMoreButton.isHidden = explanation.count <= 150
        readMoreButton.isEnabled = explanation.count > 150
    }
    
    func addTarget() {
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        likeBtn.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(cartButtonClicked), for: .touchUpInside)
        readMoreButton.addTarget(self, action: #selector(readMoreButtonClicked), for: .touchUpInside)
        addProductToCartButton.addTarget(self, action: #selector(addProductToCartButtonClicked), for: .touchUpInside)
        buyNowButton.addTarget(self, action: #selector(buyNowButtonClicked), for: .touchUpInside)
    }
    
    @objc func buyNowButtonClicked() {
        let vc = ConfirmCartVC()
        vc.products = products
        vc.totalPrice = product?.price ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func isProductLiked() {
        viewModel.isProductLiked(productID: product?.productID ?? "") { liked in
            if liked {
                self.likeButton.tag = 1
                self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.likeButton.tintColor = .systemRed
                
                self.likeBtn.tag = 1
                let originalImage = UIImage(systemName: "heart.fill")
                let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
                self.likeBtn.setImage(resizedImage, for: .normal)
                self.likeBtn.tintColor = .systemRed
            } else {
                self.likeButton.tag = 0
                self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                self.likeButton.tintColor = .black
                
                self.likeBtn.tag = 0
                let originalImage = UIImage(systemName: "heart")
                let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
                self.likeBtn.setImage(resizedImage, for: .normal)
                self.likeBtn.tintColor = .black
            }
        }
    }
    
    @objc func likeButtonClicked() {
        if likeBtn.tag == 0 && likeButton.tag == 0 {
            likeBtn.tag = 1
            let originalImage = UIImage(systemName: "heart.fill")
            let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
            self.likeBtn.setImage(resizedImage, for: .normal)
            likeBtn.tintColor = .systemRed
            
            likeButton.tag = 1
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .systemRed
            
            viewModel.likeProduct(productID: product?.productID ?? "")
        } else {
            likeBtn.tag = 0
            let originalImage = UIImage(systemName: "heart")
            let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
            self.likeBtn.setImage(resizedImage, for: .normal)
            likeBtn.tintColor = .black
            
            likeButton.tag = 0
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .black
            
            viewModel.likeProduct(productID: product?.productID ?? "")
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.likeButton.transform = CGAffineTransform(rotationAngle: .pi / 4).scaledBy(x: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.likeButton.transform = CGAffineTransform.identity
            }
        })
    }
    
    func itemsSetting() {
        truckImageView.tintColor = .gray
        starImageView.tintColor = .systemOrange
        explanationImageView.tintColor = .systemOrange
        
        cargoLabel.layer.borderWidth = 1
        cargoLabel.layer.borderColor = CGColor(red: 224 / 255, green: 224 / 255, blue: 224 / 255, alpha: 1)
        cargoLabel.layer.cornerRadius = 10
        cargoLabel.textAlignment = .center
        
        productCategoryView.layer.cornerRadius = 5
        productBrandView.layer.cornerRadius = 5
        productColorView.layer.cornerRadius = 5
        
        likeButton.layer.shadowColor = UIColor.black.cgColor
        likeButton.layer.shadowOpacity = 0.8
        likeButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        likeButton.layer.shadowRadius = 5
        
        productNameLabel.numberOfLines = 0
        explanationLabel.numberOfLines = 3
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY > 100 {
                UIView.animate(withDuration: 0.3) {
                    self.likeBtn.isHidden = false
                    self.cartButton.transform = CGAffineTransform(translationX: -50, y: 0)
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.likeBtn.isHidden = true
                    self.cartButton.transform = .identity
                }
            }
    }
    
    func fillItems() {
        guard let product = product else { return }
        
        brandLabel.text = product.brand
        productNameLabel.text = product.productName
        
        starImageView.image = UIImage(systemName: "star.fill")
        truckImageView.image = UIImage(systemName: "truck.box")
        
        productBrandLabel.text = product.brand
        productColorLabel.text = product.color
        productCategoryLabel.text = product.category
        
        explanationImageView.image = UIImage(systemName: "circle.fill")
        explanationLabel.text = product.explanation
        
        priceLabel.text = "\(String(product.price)) TL"
        
        if product.price >= 200 {
            freeCargoLabel.isHidden = false
            cargoLabel.text = "200 TL ve Üzeri Kargo Bedava"
        } else {
            freeCargoLabel.isHidden = true
            cargoLabel.text = "Kampanya Bulunmamaktadır"
        }
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func readMoreButtonClicked() {
        isExpanded.toggle()
        explanationLabel.numberOfLines = isExpanded ? 0 : 3
        readMoreButton.setTitle(isExpanded ? "Daha az göster" : "Daha fazla göster", for: .normal)
        adjustContentViewHeight()
        view.layoutIfNeeded()
    }
    
    func configureImagesCollectionView() {
        imagesCollectionView.register(ProductDetailsImagesCollectionViewCell.self, forCellWithReuseIdentifier: ProductDetailsImagesCollectionViewCell.reuseID)
        imagesCollectionView.showsHorizontalScrollIndicator = false
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.isPagingEnabled = true
    }
    
    func configureReviewsCollectionView() {
        reviewsCollectionView.register(ProductDetailsReviewsCollectionViewCell.self, forCellWithReuseIdentifier: ProductDetailsReviewsCollectionViewCell.reuseID)
        reviewsCollectionView.showsHorizontalScrollIndicator = false
        reviewsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        reviewsCollectionView.delegate = self
        reviewsCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imagesCollectionView {
            return product?.imageUrls.count ?? 1
        } else if collectionView == reviewsCollectionView {
            return evaluates.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailsImagesCollectionViewCell.reuseID, for: indexPath) as! ProductDetailsImagesCollectionViewCell
            guard let product = product else { return UICollectionViewCell() }
            cell.configure(product: product, indexPath: indexPath)
            return cell
        } else if collectionView == reviewsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailsReviewsCollectionViewCell.reuseID, for: indexPath) as! ProductDetailsReviewsCollectionViewCell
            let evaluate = evaluates[indexPath.row]
            cell.configure(evaluate: evaluate)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imagesCollectionView {
            return CGSize(width: view.bounds.size.width, height: 500)
        } else if collectionView == reviewsCollectionView {
            return CGSize(width: view.bounds.size.width, height: 200)
        } else {
            return CGSize()
        }
    }

}
