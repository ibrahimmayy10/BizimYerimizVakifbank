//
//  TabBarController.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 7.08.2024.
//

import UIKit

class TabBarController: UIViewController {
    
    lazy var bottomBarView = CustomViews(color: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1))
    
    lazy var homePageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.text = "Anasayfa"
        return label
    }()
    
    lazy var homePageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .gray
        let originalImage = UIImage(systemName: "house")
        let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.setImage(resizedImage, for: .normal)
        return button
    }()
    
    lazy var homePageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [homePageButton, homePageLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.text = "Ara"
        return label
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .gray
        let originalImage = UIImage(systemName: "magnifyingglass")
        let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.setImage(resizedImage, for: .normal)
        return button
    }()
    
    lazy var searchStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchButton, searchLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var favoriteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.text = "Favorilerim"
        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .gray
        let originalImage = UIImage(systemName: "heart")
        let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.setImage(resizedImage, for: .normal)
        return button
    }()
    
    lazy var favoriteStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favoriteButton, favoriteLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var cartLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.text = "Sepetim"
        return label
    }()
    
    lazy var cartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .gray
        let originalImage = UIImage(systemName: "cart")
        let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.setImage(resizedImage, for: .normal)
        return button
    }()
    
    lazy var cartStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cartButton, cartLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var accountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.text = "Hesabım"
        return label
    }()
    
    lazy var accountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .gray
        let originalImage = UIImage(systemName: "person")
        let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.setImage(resizedImage, for: .normal)
        return button
    }()
    
    lazy var accountStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [accountButton, accountLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var stackViews: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [homePageStackView, searchStackView, favoriteStackView, cartStackView, accountStackView])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var selectedTab: String? {
        didSet {
            updateTabBarColors()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        homePageStackView.isUserInteractionEnabled = true
        let tapGestureHomePage = UITapGestureRecognizer(target: self, action: #selector(homePageClicked))
        homePageStackView.addGestureRecognizer(tapGestureHomePage)
        homePageButton.addTarget(self, action: #selector(homePageClicked), for: .touchUpInside)
        
        searchStackView.isUserInteractionEnabled = true
        let tapGestureSearch = UITapGestureRecognizer(target: self, action: #selector(searchClicked))
        searchStackView.addGestureRecognizer(tapGestureSearch)
        searchButton.addTarget(self, action: #selector(searchClicked), for: .touchUpInside)
        
        favoriteStackView.isUserInteractionEnabled = true
        let tapGestureFavorite = UITapGestureRecognizer(target: self, action: #selector(favoriteClicked))
        favoriteStackView.addGestureRecognizer(tapGestureFavorite)
        favoriteButton.addTarget(self, action: #selector(favoriteClicked), for: .touchUpInside)
        
        cartStackView.isUserInteractionEnabled = true
        let tapGestureCart = UITapGestureRecognizer(target: self, action: #selector(cartClicked))
        cartStackView.addGestureRecognizer(tapGestureCart)
        cartButton.addTarget(self, action: #selector(cartClicked), for: .touchUpInside)
        
        accountStackView.isUserInteractionEnabled = true
        let tapGestureAccount = UITapGestureRecognizer(target: self, action: #selector(accountClicked))
        accountStackView.addGestureRecognizer(tapGestureAccount)
        accountButton.addTarget(self, action: #selector(accountClicked), for: .touchUpInside)
        
    }
    
    func updateTabBarColors() {
        homePageButton.tintColor = selectedTab == "home" ? .systemYellow : .gray
        homePageButton.setImage(selectedTab == "home" ? UIImage(systemName: "house.fill") : UIImage(systemName: "house"), for: .normal)
        homePageLabel.textColor = selectedTab == "home" ? .systemYellow : .gray
        
        searchButton.tintColor = selectedTab == "search" ? .systemYellow : .gray
        searchLabel.textColor = selectedTab == "search" ? .systemYellow : .gray
        
        favoriteButton.tintColor = selectedTab == "favorite" ? .systemYellow : .gray
        favoriteButton.setImage(selectedTab == "favorite" ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        favoriteLabel.textColor = selectedTab == "favorite" ? .systemYellow : .gray
        
        cartButton.tintColor = selectedTab == "cart" ? .systemYellow : .gray
        cartButton.setImage(selectedTab == "cart" ? UIImage(systemName: "cart.fill") : UIImage(systemName: "cart"), for: .normal)
        cartLabel.textColor = selectedTab == "cart" ? .systemYellow : .gray
        
        accountButton.tintColor = selectedTab == "account" ? .systemYellow : .gray
        accountButton.setImage(selectedTab == "account" ? UIImage(systemName: "person.fill") : UIImage(systemName: "person"), for: .normal)
        accountLabel.textColor = selectedTab == "account" ? .systemYellow : .gray
    }
    
    @objc func homePageClicked() {
        navigationController?.pushViewController(HomePageVC(), animated: false)
    }
    
    @objc func searchClicked() {
        navigationController?.pushViewController(SearchVC(), animated: false)
    }
    
    @objc func favoriteClicked() {
        navigationController?.pushViewController(FavoriteVC(), animated: false)
    }
    
    @objc func cartClicked() {
        navigationController?.pushViewController(CartVC(), animated: false)
    }
    
    @objc func accountClicked() {
        navigationController?.pushViewController(AccountVC(), animated: false)
    }
    
    func configureBottomBar() {
        view.addSubview(bottomBarView)
        bottomBarView.addSubviewsFromExt(stackViews)
        
        bottomBarView.anchor(left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, height: view.bounds.size.height * 0.1)
        stackViews.anchor(top: bottomBarView.topAnchor, left: bottomBarView.leftAnchor, right: bottomBarView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
    }

}
