//
//  HomePageViewModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 13.08.2024.
//

import Foundation
import Firebase

class HomePageViewModel {
    let currentUserID = Auth.auth().currentUser?.uid
    let firestore = Firestore.firestore()
    
    func getRandomCategoryProducts(completion: @escaping ([ProductModel]?) -> Void) {
        let categories = ["Giyim", "Elektronik", "Ayakkabı", "Saat"]
        let randomCategory = categories.randomElement() ?? "Giyim"
        
        firestore.collection("Product")
            .whereField("category", isEqualTo: randomCategory)
            .getDocuments { snapshot, error in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    completion(nil)
                } else if let documents = snapshot?.documents {
                    var products = [ProductModel]()
                    
                    for document in documents {
                        let data = document.data()
                        
                        if let product = ProductModel.createFrom(data) {
                            products.append(product)
                        }
                    }
                    
                    completion(products)
                }
            }
    }
    
    func getTop10MostLikedProducts(completion: @escaping ([ProductModel]?) -> Void) {
        firestore.collection("Product")
            .order(by: "likes", descending: true)
            .limit(to: 10)
            .getDocuments { snapshot, error in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    completion(nil)
                } else if let documents = snapshot?.documents {
                    var products = [ProductModel]()
                    
                    for document in documents {
                        let data = document.data()
                        
                        guard let product = ProductModel.createFrom(data) else {
                            completion(nil)
                            return
                        }
                        
                        products.append(product)
                    }
                    
                    completion(products)
                }
            }
    }
    
    func getDataSpecialProducts(completion: @escaping ([ProductModel]?) -> Void) {
        firestore.collection("Product")
    }
}
