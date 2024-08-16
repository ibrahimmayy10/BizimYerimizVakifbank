//
//  AdDetailsViewModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 30.07.2024.
//

import Foundation
import Firebase

class AdDetailsViewModel {
    func getDataAdProducts(brand: String, completion: @escaping ([ProductModel]?) -> Void) {
        let firestore = Firestore.firestore()
        
        firestore.collection("Product").whereField("brand", isEqualTo: brand).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(nil)
            } else if let documents = snapshot?.documents, !documents.isEmpty {
                
                var productList = [ProductModel]()
                
                for document in documents {
                    let data = document.data()
                    
                    if let productModel = ProductModel.createFrom(data) {
                        productList.append(productModel)
                    }
                }
                completion(productList)
            }
        }
    }
    
    func getDataSelectedCategoryProducts(category: String, completion: @escaping ([ProductModel]?) -> Void) {
        let firestore = Firestore.firestore()
        
        firestore.collection("Product").whereField("category", isEqualTo: category).getDocuments { snapshot, error in
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
}
