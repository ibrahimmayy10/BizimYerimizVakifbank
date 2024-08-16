//
//  AddProductVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 24.07.2024.
//

import UIKit
import SDWebImage
import Lottie

class AccountVC: TabBarController, EvaluateProductDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    lazy var allProductsLabel = CustomLabels(text: "Tüm Ürünler", font: .boldSystemFont(ofSize: 16), color: .black)
    lazy var allProductsCountLabel = CustomLabels(text: "321", font: .boldSystemFont(ofSize: 20), color: .black)
    lazy var productsSoldLabel = CustomLabels(text: "Satılan Ürünler", font: .boldSystemFont(ofSize: 15), color: .systemYellow)
    lazy var soldOutProductsLabel = CustomLabels(text: "Tükenen Ürünler", font: .boldSystemFont(ofSize: 15), color: .systemOrange)
    lazy var popularProductsLabel = CustomLabels(text: "Beğenilen Ürünler", font: .boldSystemFont(ofSize: 15), color: .systemRed)
    lazy var productsSoldCountLabel = CustomLabels(text: "", font: .boldSystemFont(ofSize: 15), color: .black)
    lazy var soldOutProductsCountLabel = CustomLabels(text: "", font: .boldSystemFont(ofSize: 15), color: .black)
    lazy var popularProductsCountLabel = CustomLabels(text: "", font: .boldSystemFont(ofSize: 15), color: .black)
    lazy var earningTextLabel = CustomLabels(text: "Kazanç", font: .boldSystemFont(ofSize: 16), color: .black)
    lazy var earningBizimYerimizLabel = CustomLabels(text: "Bizim Yerimiz ile Elde Ettiğiniz Kazanç", font: .boldSystemFont(ofSize: 16), color: .gray)
    lazy var earningLabel = CustomLabels(text: "", font: .boldSystemFont(ofSize: 18), color: .systemYellow)
    lazy var productsOnSaleLabel = CustomLabels(text: "Satıştaki Ürünlerin", font: .boldSystemFont(ofSize: 18), color: .black)
    lazy var soldOutProductsLabel2 = CustomLabels(text: "Tükenen Ürünlerin", font: .boldSystemFont(ofSize: 18), color: .black)
    lazy var notificationLabel = CustomLabels(text: "Bildirimler", font: .systemFont(ofSize: 18), color: .black)
    lazy var notificationCountLabel = CustomLabels(text: "", font: .systemFont(ofSize: 12), color: .white)
    lazy var orderLabel = CustomLabels(text: "Henüz siparişin yok, hemen alışverişe başla!", font: .boldSystemFont(ofSize: 20), color: .black)
    lazy var vakifbankLabel = CustomLabels(text: "Bizim Yerimiz İş Ortağım", font: .boldSystemFont(ofSize: 20), color: .white)
    lazy var alertLabel = CustomLabels(text: "Henüz satışta ürününüz bulunamamaktadır", font: .boldSystemFont(ofSize: 18), color: .black)
    
    lazy var addButton = CustomButtons(title: "Ürün Ekle", textColor: .white, buttonColor: .systemYellow, radius: 20, imageName: "camera", buttonTintColor: .white)
    lazy var optionsButton = CustomButtons(title: "", textColor: .white, buttonColor: .darkGray, radius: 0, imageName: "line.3.horizontal", buttonTintColor: .white)

    lazy var topBarView = CustomViews(color: .darkGray)
    lazy var salesView = CustomViews(color: .systemGray5)
    lazy var actionView = CustomViews(color: .white)
    lazy var earningView = CustomViews(color: .white)
    lazy var notificationView = CustomViews(color: .white)
    lazy var notificationCountView = CustomViews(color: .systemRed)
    lazy var contentView = CustomViews(color: .systemGray5)
    
    lazy var imageView = CustomImageViews()
    lazy var vakifImageView = CustomImageViews()
    lazy var notificationImageView = CustomImageViews()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, vakifbankLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let productCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let soldOutCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let segmentedControl: UISegmentedControl = {
        let items = ["Satışların", "Siparişlerin"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let orderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var animationView = LottieAnimationView(name: "bellAnimation")
    private var loadingAnimationView = LottieAnimationView(name: "loadingAnimation")
    
    lazy var tableView = UITableView()
    
    let productsSoldLayer = CAShapeLayer()
    let soldOutProductsLayer = CAShapeLayer()
    let popularProductsLayer = CAShapeLayer()
    
    var totalProducts = 0.0
    var productsSold = 0.0
    var soldOutProducts = 0.0
    var popularProducts = 0.0
    
    var viewModel = AccountViewModel()
    var products = [ProductModel]()
    var soldOutProductsList = [ProductModel]()
    var orders = [ProductModel]()
    var times = [OrderModel]()
    var soldProducts = [ProductModel]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray5
        
        configureAnimationView()
        getDataSoldOutProductList()
        getDataOrder()
        getDataOrderTime()
        getDataEarning()
        getDataProductsSold()
        getDataConfirmedOrders()
        configureTopBar()
        configureBottomBar()
        configureSegmentedControl()
        configureScrollView()
        configureOrderView()
        configureActionView()
        configureNotificationView()
        configureEarningView()
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        drawPieChart()
        addTarget()
        configureCollectionView()
        configureSoldOutProductsCollectionView()
        configureTableView()
        
        toggleUIElementsVisibility(isHidden: true)
        getDataProducts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedTab = "account"
        getDataProducts()
        getDataSoldOutProductList()
        getDataOrder()
        getDataOrderTime()
        getDataEarning()
        getDataProductsSold()
        getDataConfirmedOrders()
    }
    
    func configureAnimationView() {
        view.addSubview(loadingAnimationView)
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.play()
        loadingAnimationView.translatesAutoresizingMaskIntoConstraints = false
        loadingAnimationView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 100, height: 100)
    }
    
    func toggleUIElementsVisibility(isHidden: Bool) {
        salesView.isHidden = isHidden
    }
    
    func didTapEvaluateButton(product: ProductModel) {
        let vc = EvaluateVC()
        vc.product = product
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func getDataEarning() {
        viewModel.getDataEarning { earning in
            self.earningLabel.text = String(format: "%.2f TL", earning)
        }
    }
    
    private func configureSegmentedControl() {
        view.addSubviewsFromExt(segmentedControl)
        orderView.isHidden = true
        segmentedControl.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
    }
    
    func configureScrollView() {
        view.addSubview(salesView)
        salesView.addSubviewsFromExt(scrollView, alertLabel, addButton)
        scrollView.addSubview(contentView)
        
        alertLabel.numberOfLines = 0
        
        salesView.anchor(top: segmentedControl.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: bottomBarView.topAnchor)
        alertLabel.anchor(top: salesView.topAnchor, left: salesView.leftAnchor, right: salesView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        scrollView.anchor(top: salesView.topAnchor, left: salesView.leftAnchor, right: salesView.rightAnchor, bottom: salesView.bottomAnchor)
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, bottom: scrollView.bottomAnchor, width: view.bounds.size.width, height: 850)
        addButton.anchor(right: salesView.rightAnchor, bottom: salesView.bottomAnchor, paddingRight: 10, paddingBottom: 10, width: 130, height: 40)
        
        salesView.bringSubviewToFront(alertLabel)
        salesView.bringSubviewToFront(addButton)
    }
    
    func configureActionView() {
        contentView.addSubviewsFromExt(actionView)
        actionView.addSubviewsFromExt(allProductsLabel, allProductsCountLabel, productsSoldLabel, productsSoldCountLabel, soldOutProductsLabel, soldOutProductsCountLabel, popularProductsLabel, popularProductsCountLabel)
        
        actionView.layer.cornerRadius = 10
        actionView.layer.shadowColor = UIColor.black.cgColor
        actionView.layer.shadowOpacity = 0.2
        actionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        actionView.layer.shadowRadius = 4
        
        actionView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 200)
        
        allProductsLabel.anchor(top: actionView.topAnchor, left: actionView.leftAnchor, paddingTop: 20, paddingLeft: 20)
        allProductsCountLabel.anchor(top: actionView.topAnchor, right: actionView.rightAnchor, paddingTop: 20, paddingRight: 20)
        
        productsSoldCountLabel.anchor(top: allProductsCountLabel.bottomAnchor, right: actionView.rightAnchor, paddingTop: 20, paddingRight: 20)
        productsSoldLabel.anchor(top: allProductsCountLabel.bottomAnchor, right: productsSoldCountLabel.leftAnchor, paddingTop: 20, paddingRight: 30, width: 140)
        
        soldOutProductsCountLabel.anchor(top: productsSoldCountLabel.bottomAnchor, right: actionView.rightAnchor, paddingTop: 20, paddingRight: 20)
        soldOutProductsLabel.anchor(top: productsSoldLabel.bottomAnchor, right: productsSoldCountLabel.leftAnchor, paddingTop: 20, paddingRight: 30, width: 140)
        
        popularProductsCountLabel.anchor(top: soldOutProductsCountLabel.bottomAnchor, right: actionView.rightAnchor, paddingTop: 20, paddingRight: 20)
        popularProductsLabel.anchor(top: soldOutProductsLabel.bottomAnchor, right: productsSoldCountLabel.leftAnchor, paddingTop: 20, paddingRight: 30, width: 140)
    }
    
    func configureNotificationView() {
        contentView.addSubview(notificationView)
        notificationView.addSubviewsFromExt(notificationLabel, notificationImageView, animationView)
        notificationImageView.addSubview(notificationCountView)
        notificationCountView.addSubview(notificationCountLabel)
        
        notificationView.layer.cornerRadius = 10
        notificationView.layer.shadowColor = UIColor.black.cgColor
        notificationView.layer.shadowOpacity = 0.2
        notificationView.layer.shadowOffset = CGSize(width: 0, height: 2)
        notificationView.layer.shadowRadius = 4
        
        notificationCountView.layer.cornerRadius = 9
        notificationCountView.isHidden = true
        
        notificationImageView.image = UIImage(systemName: "chevron.right.circle")
        notificationImageView.tintColor = .black
        
        animationView.loopMode = .loop
        animationView.play()
        
        notificationView.anchor(top: actionView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 80)
        notificationLabel.anchor(left: notificationView.leftAnchor, centerY: notificationView.centerYAnchor, paddingLeft: 10)
        notificationImageView.anchor(right: notificationView.rightAnchor, centerY: notificationView.centerYAnchor, paddingRight: 10, width: 30, height: 30)
        animationView.anchor(right: notificationImageView.leftAnchor, centerY: notificationView.centerYAnchor, width: 60, height: 60)
        notificationCountView.anchor(top: notificationImageView.topAnchor, right: notificationImageView.rightAnchor, paddingTop: -5, paddingRight: -5, width: 18, height: 18)
        notificationCountLabel.anchor(centerX: notificationCountView.centerXAnchor, centerY: notificationCountView.centerYAnchor)
    }
    
    func configureEarningView() {
        contentView.addSubview(earningView)
        earningView.addSubviewsFromExt(earningTextLabel, vakifImageView, earningBizimYerimizLabel, earningLabel)
        
        earningView.layer.cornerRadius = 10
        earningView.layer.shadowColor = UIColor.black.cgColor
        earningView.layer.shadowOpacity = 0.2
        earningView.layer.shadowOffset = CGSize(width: 0, height: 2)
        earningView.layer.shadowRadius = 4
        
        vakifImageView.layer.shadowColor = UIColor.systemYellow.cgColor
        vakifImageView.layer.shadowOpacity = 0.8
        vakifImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        vakifImageView.layer.shadowRadius = 5
        
        vakifImageView.image = UIImage(named: "vakif")
        
        earningView.anchor(top: notificationView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 200)
        earningTextLabel.anchor(top: earningView.topAnchor, left: earningView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        vakifImageView.anchor(top: earningTextLabel.bottomAnchor, centerX: earningView.centerXAnchor, paddingTop: 20, width: 50, height: 40)
        earningBizimYerimizLabel.anchor(top: vakifImageView.bottomAnchor, centerX: earningView.centerXAnchor, paddingTop: 10)
        earningLabel.anchor(top: earningBizimYerimizLabel.bottomAnchor, centerX: earningView.centerXAnchor, paddingTop: 10)
    }
    
    func configureCollectionView() {
        contentView.addSubviewsFromExt(productCollectionView, productsOnSaleLabel)
        
        productsOnSaleLabel.anchor(top: earningView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 15, paddingLeft: 10)
        
        productCollectionView.register(AccountVCCollectionViewCell.self, forCellWithReuseIdentifier: AccountVCCollectionViewCell.reuseID)
        
        productCollectionView.showsHorizontalScrollIndicator = false
        productCollectionView.translatesAutoresizingMaskIntoConstraints = false
        productCollectionView.anchor(top: productsOnSaleLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingRight: 5, paddingBottom: 5, height: 290)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.backgroundColor = .clear
    }
    
    func configureSoldOutProductsCollectionView() {
        contentView.addSubviewsFromExt(soldOutProductsLabel2, soldOutCollectionView)
        
        soldOutProductsLabel2.isHidden = true
        
        soldOutProductsLabel2.anchor(top: productCollectionView.bottomAnchor, left: contentView.leftAnchor, paddingTop: 15, paddingLeft: 10)
        
        soldOutCollectionView.register(SoldOutCollectionViewCell.self, forCellWithReuseIdentifier: SoldOutCollectionViewCell.reuseID)
        
        soldOutCollectionView.showsHorizontalScrollIndicator = false
        soldOutCollectionView.translatesAutoresizingMaskIntoConstraints = false
        soldOutCollectionView.anchor(top: soldOutProductsLabel2.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingRight: 5, paddingBottom: 5, height: 290)
        soldOutCollectionView.delegate = self
        soldOutCollectionView.dataSource = self
        soldOutCollectionView.backgroundColor = .clear
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            salesView.isHidden = false
            orderView.isHidden = true
            
            if products.isEmpty {
                scrollView.isHidden = true
                alertLabel.isHidden = false
                addButton.isHidden = false
            } else {
                scrollView.isHidden = false
                alertLabel.isHidden = true
                addButton.isHidden = false
            }
            
        } else {
            salesView.isHidden = true
            orderView.isHidden = false
        }
    }
    
    func drawPieChart() {
        view.layoutIfNeeded()
        
        let radius = CGFloat(50)
        let lineWidth = CGFloat(10)
        
        let centerX = radius + 20
        let centerY = actionView.bounds.height * 0.6
        
        let totalUsed = productsSold + soldOutProducts + popularProducts
        
        guard totalUsed > 0 else { return }
        
        let productsSoldEndAngle = (productsSold / totalUsed) * 2 * .pi
        let soldOutProductsEndAngle = productsSoldEndAngle + (soldOutProducts / totalUsed) * 2 * .pi
        let popularProductsEndAngle = soldOutProductsEndAngle + (popularProducts / totalUsed) * 2 * .pi
        
        let productsSoldPath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: 0, endAngle: productsSoldEndAngle, clockwise: true)
        productsSoldLayer.path = productsSoldPath.cgPath
        productsSoldLayer.strokeColor = UIColor.systemYellow.cgColor
        productsSoldLayer.fillColor = UIColor.clear.cgColor
        productsSoldLayer.lineWidth = lineWidth
        
        let soldOutProductsPath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: productsSoldEndAngle, endAngle: soldOutProductsEndAngle, clockwise: true)
        soldOutProductsLayer.path = soldOutProductsPath.cgPath
        soldOutProductsLayer.strokeColor = UIColor.systemOrange.cgColor
        soldOutProductsLayer.fillColor = UIColor.clear.cgColor
        soldOutProductsLayer.lineWidth = lineWidth
        
        let popularProductsPath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: soldOutProductsEndAngle, endAngle: popularProductsEndAngle, clockwise: true)
        popularProductsLayer.path = popularProductsPath.cgPath
        popularProductsLayer.strokeColor = UIColor.red.cgColor
        popularProductsLayer.fillColor = UIColor.clear.cgColor
        popularProductsLayer.lineWidth = lineWidth
        
        actionView.layer.addSublayer(productsSoldLayer)
        actionView.layer.addSublayer(soldOutProductsLayer)
        actionView.layer.addSublayer(popularProductsLayer)
    }
    
    func configureOrderView() {
        view.addSubview(orderView)
        
        orderView.anchor(top: segmentedControl.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: bottomBarView.topAnchor)
    }
    
    func configureTableView() {
        orderView.addSubviewsFromExt(tableView, orderLabel)
        
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: AccountTableViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        orderLabel.numberOfLines = 0
        
        orderLabel.anchor(top: orderView.topAnchor, left: orderView.leftAnchor, right: orderView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        tableView.anchor(top: orderView.topAnchor, left: orderView.leftAnchor, right: orderView.rightAnchor, bottom: orderView.bottomAnchor)
    }
    
    func getDataOrder() {
        viewModel.fetchProductsForOrders { [weak self] product in
            guard let self = self else { return }
            self.orders = product ?? []
            
            if orders.isEmpty {
                orderLabel.isHidden = false
                tableView.isHidden = true
            } else {
                orderLabel.isHidden = true
                tableView.isHidden = false
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func getDataOrderTime() {
        viewModel.getDataOrder { [weak self] order in
            guard let self = self else { return }
            self.times = order ?? []
        }
    }
    
    func getDataConfirmedOrders() {
        viewModel.getDataConfirmedOrders { products in
            if let products = products, !products.isEmpty {
                self.notificationCountView.isHidden = false
                self.notificationCountLabel.text = String(products.count)
                self.animationView.play()
            } else {
                self.notificationCountView.isHidden = true
                self.animationView.stop()
            }
        }
    }
    
    func getDataProductsSold() {
        viewModel.getDataProductsSold { products in
            self.soldProducts = products ?? []
            self.productsSold = Double(products?.count ?? 0)
            self.productsSoldCountLabel.text = String(products?.count ?? 0)
            
            DispatchQueue.main.async {
                self.drawPieChart()
            }
        }
    }
    
    func getDataLikes() {
        viewModel.getDataLikedProduct { like in
            self.popularProducts = Double(like)
            self.popularProductsCountLabel.text = String(like)
            DispatchQueue.main.async {
                self.drawPieChart()
            }
        }
    }
    
    func getDataSoldOutProductList() {
        viewModel.getDataSoldOutProductList { [weak self] products in
            guard let self = self else { return }
            guard let products = products else {
                self.soldOutProductsCountLabel.text = "0"
                return
            }
            
            self.soldOutProductsList = products
            self.soldOutProducts = products.isEmpty ? 0 : Double(products.count)
            self.soldOutProductsCountLabel.text = products.isEmpty ? "0" : String(products.count)
            
            if soldOutProductsList.isEmpty {
                updateViewHeights(contentHeight: 850)
                soldOutProductsLabel2.isHidden = true
            } else {
                updateViewHeights(contentHeight: 1190)
                soldOutProductsLabel2.isHidden = false
            }
            
            DispatchQueue.main.async {
                self.soldOutCollectionView.reloadData()
                self.drawPieChart()
            }
        }
    }
    
    func updateViewHeights(contentHeight: CGFloat) {
        contentView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = contentHeight
            }
        }
    }
    
    func getDataProducts() {
        loadingAnimationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            viewModel.getDataMyProduct { products in
                if let products = products {
                    self.products = products
                    
                    if products.isEmpty {
                        self.scrollView.isHidden = true
                        self.alertLabel.isHidden = false
                    } else {
                        self.scrollView.isHidden = false
                        self.alertLabel.isHidden = true
                    }
                    
                    self.totalProducts = products.isEmpty ? 0 : Double(products.count)
                    self.allProductsCountLabel.text = products.isEmpty ? "0" : String(products.count)
                    
                    DispatchQueue.main.async {
                        self.productCollectionView.reloadData()
                        self.loadingAnimationView.stop()
                        self.getDataLikes()
                        self.drawPieChart()
                        self.loadingAnimationView.isHidden = true
                        
                        self.toggleUIElementsVisibility(isHidden: false)
                        self.addButton.isHidden = false
                    }
                } else {
                    self.loadingAnimationView.stop()
                    self.loadingAnimationView.isHidden = true
                    self.scrollView.isHidden = true
                    self.alertLabel.isHidden = false
                    self.addButton.isHidden = false
                }
            }
        }
    }
    
    func configureTopBar() {
        view.addSubviewsFromExt(topBarView)
        topBarView.addSubviewsFromExt(stackView, optionsButton)
        
        imageView.image = UIImage(named: "vakif")
        
        let originalImage = UIImage(systemName: "line.3.horizontal")
        let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        optionsButton.setImage(resizedImage, for: .normal)
        
        vakifbankLabel.numberOfLines = 2
        
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.bounds.size.height * 0.155)
        stackView.anchor(left: topBarView.leftAnchor, bottom: topBarView.bottomAnchor, paddingLeft: 10, paddingBottom: 25, width: 200)
        optionsButton.anchor(right: topBarView.rightAnchor, bottom: topBarView.bottomAnchor, paddingRight: 10, paddingBottom: 25)
        
        imageView.anchor(width: 30, height: 20)
    }
    
    func addTarget() {
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        optionsButton.addTarget(self, action: #selector(optionsButtonClicked), for: .touchUpInside)
        
        notificationView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(notificationTapGesture))
        notificationView.addGestureRecognizer(tapGesture)
    }
    
    @objc func optionsButtonClicked() {
        let vc = SideMenuViewController()
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        self.present(vc, animated: true)
    }
    
    @objc func notificationTapGesture() {
        let vc = NotificationVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func addButtonClicked() {
        let vc = NewProductVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.reuseID, for: indexPath) as! AccountTableViewCell
        let order = orders[indexPath.row]
        let time = times[indexPath.row]
        cell.configure(product: order, order: time)
        cell.delegate = self    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = orders[indexPath.row]
        let order = times[indexPath.row]
        let vc = OrderDetailsVC()
        vc.product = product
        vc.order = order
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollectionView {
            return products.count
        } else if collectionView == soldOutCollectionView {
            return soldOutProductsList.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productCollectionView {
            let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: AccountVCCollectionViewCell.reuseID, for: indexPath) as! AccountVCCollectionViewCell
            let product = products[indexPath.row]
            cell.configure(with: product)
            return cell
        } else if collectionView == soldOutCollectionView {
            let cell = soldOutCollectionView.dequeueReusableCell(withReuseIdentifier: SoldOutCollectionViewCell.reuseID, for: indexPath) as! SoldOutCollectionViewCell
            guard !soldOutProductsList.isEmpty else {
                return UICollectionViewCell()
            }
            let product = soldOutProductsList[indexPath.row]
            cell.configure(with: product)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productCollectionView {
            let product = products[indexPath.row]
            if let cell = collectionView.cellForItem(at: indexPath) {
                AnimationHelper.animateCell(cell: cell, in: self.view) {
                    AnimationHelper.navigateToProductDetailsVC(product: product, from: self.navigationController)
                }
            }
        } else if collectionView == soldOutCollectionView {
            let product = soldOutProductsList[indexPath.row]
            if let cell = collectionView.cellForItem(at: indexPath) {
                AnimationHelper.animateCell(cell: cell, in: self.view) {
                    let vc = ProductDetailsVC()
                    vc.addProductToCartButton.isEnabled = false
                    vc.addProductToCartButton.backgroundColor = .lightGray
                    vc.buyNowButton.isEnabled = false
                    vc.buyNowButton.isHidden = true
                    vc.buyNowButton.setTitleColor(.lightGray, for: .normal)
                    vc.product = product
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productCollectionView {
            return CGSize(width: 180, height: 280)
        } else if collectionView == soldOutCollectionView {
            return CGSize(width: 180, height: 280)
        }
        
        return CGSize()
    }
    
}
