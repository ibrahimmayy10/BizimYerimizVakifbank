//
//  CommercialHomePageVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 23.07.2024.
//

import UIKit
import Lottie

class HomePageVC: BaseHomePageVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var categories = [
        Category(text: "Giyim", imageName: "tshirt"),
        Category(text: "Ayakkabı", imageName: "ayakkabi"),
        Category(text: "Elektronik", imageName: "electronics"),
        Category(text: "Aksesuar", imageName: "jewellery"),
        Category(text: "Gözlük", imageName: "gozluk")
    ]
    
    var adverts = [
        Advert(imageName: "apple", brandName: "Apple"),
        Advert(imageName: "pullbear", brandName: "Pull & Bear"),
        Advert(imageName: "xiaomi", brandName: "Xiaomi"),
        Advert(imageName: "nike", brandName: "Nike"),
        Advert(imageName: "adidas", brandName: "Adidas")
    ]
    
    var adverts2 = [
        Advert(imageName: "samsung", brandName: "Samsung"),
        Advert(imageName: "converse", brandName: "Converse"),
        Advert(imageName: "avva", brandName: "Avva"),
        Advert(imageName: "puma", brandName: "Puma"),
        Advert(imageName: "bellona", brandName: "Bellona")
    ]
    
    let viewModel = AccountViewModel()
    let homeViewModel = HomePageViewModel()
    var products = [ProductModel]()
    var likedProducts = [ProductModel]()
    var randomProducts = [ProductModel]()
    private var animationView = LottieAnimationView(name: "loadingAnimation")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureTopBar()
        configureBottomBar()
        
        configureAnimationView()
        configureCategoryCollectionView()
        configureAdvertCollectionView()
        configurePopularProductsCollectionView()
        configureSpecialForYouProductsCollectionView()
        configureMostPopularCollectionView()
        configureAdvert2CollectionView()
        configureScrollView()
        
        toggleUIElementsVisibility(isHidden: true)
        getDataPopularProducts()
        getTop10MostLikedProducts()
        getRandomCategoryProducts()
        autoScrollAdvertCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedTab = "home"
        getDataPopularProducts()
        getTop10MostLikedProducts()
        configureAnimationView()
    }
    
    func configureAnimationView() {
        view.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 100, height: 100)
    }
    
    func getDataPopularProducts() {
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            viewModel.getDataMyProduct { products in
                self.products = products ?? []
                
                DispatchQueue.main.async {
                    self.specialForYouProductsCollectionView.reloadData()
                    self.mostPopularCollectionView.reloadData()
                    self.animationView.stop()
                    self.animationView.isHidden = true
                    
                    self.toggleUIElementsVisibility(isHidden: false)
                }
            }
        }
    }
    
    func getTop10MostLikedProducts() {
        homeViewModel.getTop10MostLikedProducts { products in
            self.likedProducts = products ?? []
            DispatchQueue.main.async {
                self.popularProductsCollectionView.reloadData()
            }
        }
    }
    
    func getRandomCategoryProducts() {
        homeViewModel.getRandomCategoryProducts { products in
            self.randomProducts = products ?? []
            DispatchQueue.main.async {
                self.specialForYouProductsCollectionView.reloadData()
            }
        }
    }
    
    func toggleUIElementsVisibility(isHidden: Bool) {
        scrollView.isHidden = isHidden
    }
    
    func autoScrollAdvertCollectionView() {
        advertCollectionView.isPagingEnabled = false
        let timer = Timer(timeInterval: 3, target: self, selector: #selector(autoScrollAdvert1CollectionView), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        
        advert2CollectionView.isPagingEnabled = false
        let timer2 = Timer(timeInterval: 3, target: self, selector: #selector(autoScrollAdvert2CollectionView), userInfo: nil, repeats: true)
        RunLoop.main.add(timer2, forMode: .common)
    }
    
    @objc func autoScrollAdvert1CollectionView() {
        guard let indexPath = advertCollectionView.indexPathsForVisibleItems.first else { return }
        var nextIndex = indexPath.item + 1
        if nextIndex >= adverts.count {
            nextIndex = 0
        }
        let nextIndexPath = IndexPath(item: nextIndex, section: 0)
        advertCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func autoScrollAdvert2CollectionView() {
        guard let indexPath = advert2CollectionView.indexPathsForVisibleItems.first else { return }
        var nextIndex = indexPath.item + 1
        if nextIndex >= adverts2.count {
            nextIndex = 0
        }
        let nextIndexPath = IndexPath(item: nextIndex, section: 0)
        advert2CollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    func configureMostPopularCollectionView() {
        mostPopularCollectionView.register(HomePageMostPopularProductsCollectionViewCell.self, forCellWithReuseIdentifier: HomePageMostPopularProductsCollectionViewCell.reuseID)
        mostPopularCollectionView.showsHorizontalScrollIndicator = false
        mostPopularCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mostPopularCollectionView.delegate = self
        mostPopularCollectionView.dataSource = self
    }
    
    func configureSpecialForYouProductsCollectionView() {
        specialForYouProductsCollectionView.register(HomePageForYouProductsCollectionViewCell.self, forCellWithReuseIdentifier: HomePageForYouProductsCollectionViewCell.reuseID)
        specialForYouProductsCollectionView.showsHorizontalScrollIndicator = false
        specialForYouProductsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        specialForYouProductsCollectionView.delegate = self
        specialForYouProductsCollectionView.dataSource = self
    }
    
    func configurePopularProductsCollectionView() {
        popularProductsCollectionView.register(HomePagePopularProductsCollectionViewCell.self, forCellWithReuseIdentifier: HomePagePopularProductsCollectionViewCell.reuseID)
        popularProductsCollectionView.showsHorizontalScrollIndicator = false
        popularProductsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        popularProductsCollectionView.delegate = self
        popularProductsCollectionView.dataSource = self
    }
    
    func configureAdvertCollectionView() {
        advertCollectionView.register(HomePageAdvertCollectionViewCell.self, forCellWithReuseIdentifier: HomePageAdvertCollectionViewCell.reuseID)
        advertCollectionView.showsHorizontalScrollIndicator = false
        advertCollectionView.translatesAutoresizingMaskIntoConstraints = false
        advertCollectionView.delegate = self
        advertCollectionView.dataSource = self
    }
    
    func configureAdvert2CollectionView() {
        advert2CollectionView.register(AdvertCollectionViewCell.self, forCellWithReuseIdentifier: AdvertCollectionViewCell.reuseID)
        advert2CollectionView.showsHorizontalScrollIndicator = false
        advert2CollectionView.translatesAutoresizingMaskIntoConstraints = false
        advert2CollectionView.delegate = self
        advert2CollectionView.dataSource = self
    }
    
    func configureCategoryCollectionView() {
        categoryCollectionView.register(HomePageCategoryCollectionViewCell.self, forCellWithReuseIdentifier: HomePageCategoryCollectionViewCell.reuseID)
        categoryCollectionView.register(HomePageAllCategoriesCollectionViewCell.self, forCellWithReuseIdentifier: HomePageAllCategoriesCollectionViewCell.reuseID)
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
    private func animateCell(cell: UIView, completion: @escaping () -> Void) {
        let originalFrame = cell.convert(cell.bounds, to: nil)
        let zoomedFrame = CGRect(x: originalFrame.origin.x - 20, y: originalFrame.origin.y - 20, width: originalFrame.size.width + 40, height: originalFrame.size.height + 40)
        
        let snapshot = cell.snapshotView(afterScreenUpdates: false)
        snapshot?.frame = originalFrame
        view.addSubview(snapshot!)
        
        UIView.animate(withDuration: 0.3, animations: {
            snapshot?.frame = zoomedFrame
            snapshot?.alpha = 0
        }, completion: { _ in
            snapshot?.removeFromSuperview()
            completion()
        })
    }

    private func navigateToProductDetailsVC(product: ProductModel) {
        let productDetailsVC = ProductDetailsVC()
        productDetailsVC.product = product
        navigationController?.pushViewController(productDetailsVC, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count + 1
        } else if collectionView == popularProductsCollectionView {
            return likedProducts.count
        } else if collectionView == advertCollectionView {
            return adverts.count
        } else if collectionView == specialForYouProductsCollectionView {
            return randomProducts.count
        } else if collectionView == mostPopularCollectionView {
            return products.count
        } else if collectionView == advert2CollectionView {
            return adverts2.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            if indexPath.row < categories.count {
                let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: HomePageCategoryCollectionViewCell.reuseID, for: indexPath) as! HomePageCategoryCollectionViewCell
                let category = categories[indexPath.row]
                cell.configure(with: category)
                return cell
            } else {
                let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: HomePageAllCategoriesCollectionViewCell.reuseID, for: indexPath) as! HomePageAllCategoriesCollectionViewCell
                return cell
            }
        } else if collectionView == popularProductsCollectionView {
            let cell = popularProductsCollectionView.dequeueReusableCell(withReuseIdentifier: HomePagePopularProductsCollectionViewCell.reuseID, for: indexPath) as! HomePagePopularProductsCollectionViewCell
            let product = likedProducts[indexPath.row]
            cell.configure(with: product)
            return cell
        } else if collectionView == advertCollectionView {
            let cell = advertCollectionView.dequeueReusableCell(withReuseIdentifier: HomePageAdvertCollectionViewCell.reuseID, for: indexPath) as! HomePageAdvertCollectionViewCell
            let design = adverts[indexPath.row]
            cell.configure(with: design)
            return cell
        } else if collectionView == specialForYouProductsCollectionView {
            let cell = specialForYouProductsCollectionView.dequeueReusableCell(withReuseIdentifier: HomePageForYouProductsCollectionViewCell.reuseID, for: indexPath) as! HomePageForYouProductsCollectionViewCell
            let product = randomProducts[indexPath.row]
            cell.configure(with: product)
            return cell
        } else if collectionView == mostPopularCollectionView {
            let cell = mostPopularCollectionView.dequeueReusableCell(withReuseIdentifier: HomePageMostPopularProductsCollectionViewCell.reuseID, for: indexPath) as! HomePageMostPopularProductsCollectionViewCell
            let product = products[indexPath.row]
            cell.configure(with: product)
            return cell
        } else if collectionView == advert2CollectionView {
            let cell = advert2CollectionView.dequeueReusableCell(withReuseIdentifier: AdvertCollectionViewCell.reuseID, for: indexPath) as! AdvertCollectionViewCell
            let advert = adverts2[indexPath.row]
            cell.configure(with: advert)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == popularProductsCollectionView {
            let product = likedProducts[indexPath.row]
            if let cell = collectionView.cellForItem(at: indexPath) {
                AnimationHelper.animateCell(cell: cell, in: self.view) {
                    AnimationHelper.navigateToProductDetailsVC(product: product, from: self.navigationController)
                }
            }
        } else if collectionView == specialForYouProductsCollectionView {
            let product = randomProducts[indexPath.row]
            if let cell = collectionView.cellForItem(at: indexPath) {
                AnimationHelper.animateCell(cell: cell, in: self.view) {
                    AnimationHelper.navigateToProductDetailsVC(product: product, from: self.navigationController)
                }
            }
        } else if collectionView == mostPopularCollectionView {
            let product = products[indexPath.row]
            if let cell = collectionView.cellForItem(at: indexPath) {
                AnimationHelper.animateCell(cell: cell, in: self.view) {
                    AnimationHelper.navigateToProductDetailsVC(product: product, from: self.navigationController)
                }
            }
        } else if collectionView == advertCollectionView {
            let advert = adverts[indexPath.row]
            let vc = AdDetailsVC()
            vc.advert = advert
            navigationController?.pushViewController(vc, animated: true)
        } else if collectionView == categoryCollectionView {
            if indexPath.row < categories.count {
                let category = categories[indexPath.row]
                let vc = AdDetailsVC()
                vc.category = category.text
                navigationController?.pushViewController(vc, animated: true)
            } else {
                navigationController?.pushViewController(AllCategoryListVC(), animated: true)
            }
        } else if collectionView == advert2CollectionView {
            let advert = adverts2[indexPath.row]
            let vc = AdDetailsVC()
            vc.advert = advert
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            return CGSize(width: 120, height: 120)
        } else if collectionView == popularProductsCollectionView {
            return CGSize(width: 180, height: 320)
        } else if collectionView == mostPopularCollectionView {
            return CGSize(width: 180, height: 320)
        } else if collectionView == specialForYouProductsCollectionView {
            return CGSize(width: 180, height: 320)
        } else if collectionView == advertCollectionView {
            let padding: CGFloat = 20
            let collectionViewSize = collectionView.frame.size.width - padding
            
            let itemWidth = collectionViewSize
            let itemHeight: CGFloat = 120
            
            return CGSize(width: itemWidth, height: itemHeight)
        } else if collectionView == advert2CollectionView {
            let padding: CGFloat = 20
            let collectionViewSize = collectionView.frame.size.width - padding
            
            let itemWidth = collectionViewSize
            let itemHeight: CGFloat = 120
            
            return CGSize(width: itemWidth, height: itemHeight)
        }
        
        return CGSize()
    }

}
