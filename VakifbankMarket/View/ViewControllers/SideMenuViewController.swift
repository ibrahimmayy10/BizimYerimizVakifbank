//
//  SideMenuViewController.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 12.08.2024.
//

import UIKit
import Firebase

class SideMenuViewController: UIViewController {
    
    lazy var nameLabel = CustomLabels(text: "", font: .systemFont(ofSize: 18), color: .black)
    lazy var emailLabel = CustomLabels(text: "", font: .systemFont(ofSize: 16), color: .gray)
    lazy var vakifLabel = CustomLabels(text: "Bizim Yerimiz", font: .boldSystemFont(ofSize: 24), color: .black)
    
    lazy var imageView = CustomImageViews()
    
    lazy var signOutButton = CustomButtons(title: "Çıkış Yap", textColor: .white, buttonColor: .systemRed, radius: 5, imageName: "", buttonTintColor: .white)
    
    lazy var activityIndicator = ActivityIndicators(indicatorColor: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
        
        getDataUserInfo()
        configureUI()
        
        signOutButton.addTarget(self, action: #selector(signOutButtonClicked), for: .touchUpInside)
                
    }
    
    func getDataUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
        let currentUserID = user.uid
        
        let email = user.email
        
        let firestore = Firestore.firestore()
        
        firestore.collection("SellerAccountOwners").whereField("userID", isEqualTo: currentUserID).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else if let documents = snapshot?.documents {
                for document in documents {
                    guard let name = document.get("nameSurname") as? String else { return }
                    self.nameLabel.text = name
                    self.emailLabel.text = email
                }
            }
        }
    }
    
    @objc func signOutButtonClicked() {
        signOutButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        do {
            try Auth.auth().signOut()
            
            let loginVC = LoginVC()
            
            let navigationController = UINavigationController(rootViewController: loginVC)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = navigationController
                    window.makeKeyAndVisible()
                    self.activityIndicator.stopAnimating()
                    self.signOutButton.setTitle("Çıkış Yap", for: .normal)
                }
            }
        } catch {
            print("çıkış başarısız")
            self.activityIndicator.stopAnimating()
            self.signOutButton.setTitle("Çıkış Yap", for: .normal)
            
        }
    }
    
    func configureUI() {
        view.addSubviewsFromExt(vakifLabel, imageView, nameLabel, emailLabel, signOutButton, activityIndicator)
        
        imageView.image = UIImage(named: "vakif")
        
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20, width: 60, height: 50)
        vakifLabel.anchor(left: imageView.rightAnchor, centerY: imageView.centerYAnchor, paddingLeft: 10)
        nameLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        emailLabel.anchor(top: nameLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 5, paddingLeft: 20)
        
        signOutButton.anchor(left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 15, paddingRight: 15, paddingBottom: 10, height: 50)
        activityIndicator.anchor(centerX: signOutButton.centerXAnchor, centerY: signOutButton.centerYAnchor)
    }

}
