//
//  TabBarViewController.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 24.07.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTabs()
        
    }
    
    func setup() {
        self.tabBar.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        self.tabBar.tintColor = .systemYellow
    }
    
    private func setupTabs() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true
        let home = self.createNav(with: "Anasayfa", and: UIImage(systemName: "house") ?? UIImage(), vc: HomePageVC())
        let searchVC = self.createNav(with: "Ara", and: UIImage(systemName: "magnifyingglass") ?? UIImage(), vc: SearchVC())
        let myProductVC = self.createNav(with: "Hesabım", and: UIImage(systemName: "person") ?? UIImage(), vc: AccountVC())
        let favoriteVC = self.createNav(with: "Favorilerim", and: UIImage(systemName: "heart") ?? UIImage(), vc: FavoriteVC())
        let cartVC = self.createNav(with: "Sepetim", and: UIImage(systemName: "cart") ?? UIImage(), vc: CartVC())
        setViewControllers([home, searchVC, favoriteVC, cartVC, myProductVC], animated: true)
    }
    
    func createNav(with title: String, and image: UIImage, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }

}
