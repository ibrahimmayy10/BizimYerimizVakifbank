//
//  MyProductsViewModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 25.07.2024.
//

import Foundation
import Firebase

class AccountViewModel {
    
    let currentUserID = Auth.auth().currentUser?.uid
    let firestore = Firestore.firestore()
        
    func getDataConfirmedOrders(completion: @escaping ([ProductModel]?) -> Void) {
        guard let currentUserID = currentUserID else { return }
        
        firestore.collection("Sales").whereField("salesID", isEqualTo: currentUserID).whereField("confirm", isEqualTo: false).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(nil)
            } else if let documents = snapshot?.documents {
                var products = [ProductModel]()
                let group = DispatchGroup()
                
                for document in documents {
                    group.enter()
                    let data = document.data()
                    
                    guard let productID = data["productID"] as? String else {
                        group.leave()
                        continue
                    }
                                        
                    self.getDataProduct(productID: productID) { product in
                        if let product = product {
                            products.append(product)
                        }
                        
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(products)
                }
            }
        }
    }
    
    func getDataProductsSold(completion: @escaping ([ProductModel]?) -> Void) {
        guard let currentUserID = currentUserID else { return }
        
        firestore.collection("Sales").whereField("salesID", isEqualTo: currentUserID).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(nil)
            } else if let documents = snapshot?.documents {
                var products = [ProductModel]()
                let group = DispatchGroup()
                
                for document in documents {
                    group.enter()
                    let data = document.data()
                    
                    guard let productID = data["productID"] as? String else {
                        group.leave()
                        continue
                    }
                    
                    self.getDataProduct(productID: productID) { product in
                        if let product = product {
                            products.append(product)
                        }
                        
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(products)
                }
            }
        }
    }
    
    func getDataOrder(completion: @escaping ([OrderModel]?) -> Void) {
        guard let currentUserID = currentUserID else {
            completion(nil)
            return
        }
        
        firestore.collection("Orders").whereField("buyerID", isEqualTo: currentUserID).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(nil)
            } else if let documents = snapshot?.documents {
                var orderModel = [OrderModel]()
                
                for document in documents {
                    let data = document.data()
                    
                    guard let order = OrderModel.createFrom(data) else {
                        completion(nil)
                        return
                    }
                    
                    orderModel.append(order)
                }
                
                completion(orderModel)
            }
        }
    }
    
    func getDataProduct(productID: String, completion: @escaping (ProductModel?) -> Void) {
        firestore.collection("Product").document(productID).getDocument { document, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(nil)
            } else if let document = document, document.exists {
                let data = document.data()
                
                guard let product = ProductModel.createFrom(data ?? [:]) else {
                    completion(nil)
                    return
                }
                
                completion(product)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchProductsForOrders(completion: @escaping ([ProductModel]?) -> Void) {
        getDataOrder { orders in
            guard let orders = orders else {
                completion(nil)
                return
            }
            
            var productModels = [ProductModel]()
            let dispatchGroup = DispatchGroup()
            
            for order in orders {
                dispatchGroup.enter()
                self.getDataProduct(productID: order.productID) { product in
                    if let product = product {
                        productModels.append(product)
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(productModels.isEmpty ? nil : productModels)
            }
        }
    }
    
    func getDataMyProduct(completion: @escaping ([ProductModel]?) -> Void) {
        guard let currentUserID = currentUserID else {
            completion(nil)
            return
        }
        
        firestore.collection("Product").whereField("userID", isEqualTo: currentUserID).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(nil)
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(nil)
                return
            }
            
            var productModel = [ProductModel]()
            
            for document in documents {
                let data = document.data()
                
                guard let product = ProductModel.createFrom(data) else {
                    completion(nil)
                    return
                }
                
                productModel.append(product)
                
            }
            
            completion(productModel)
        }
    }
    
    func getDataSoldOutProductList(completion: @escaping ([ProductModel]?) -> Void) {
        guard let currentUserID = currentUserID else {
            completion(nil)
            return
        }
        
        firestore.collection("SoldOutProducts").whereField("userID", isEqualTo: currentUserID).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(nil)
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(nil)
                return
            }
            
            var productModel = [ProductModel]()
            
            for document in documents {
                let data = document.data()
                
                guard let product = ProductModel.createFrom(data) else {
                    completion(nil)
                    return
                }
                
                productModel.append(product)
                
            }
            
            completion(productModel)
        }
    }
    
    func getDataLikedProduct(completion: @escaping (Int) -> Void) {
        getDataMyProduct { products in
            guard let products = products else {
                completion(0)
                return
            }
            
            var likedProductCount = 0
            
            for product in products {
                if !product.likes.isEmpty {
                    likedProductCount += 1
                }
            }
            
            completion(likedProductCount)
        }
    }
    
    func getDataEarning(completion: @escaping (Double) -> Void) {
        guard let currentUserID = currentUserID else {
            completion(0)
            return
        }
        
        firestore.collection("Sales").whereField("salesID", isEqualTo: currentUserID).whereField("delivery", isEqualTo: true).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(0)
            } else if let documents = snapshot?.documents {
                var totalEarning: Double = 0.0
                
                for document in documents {
                    guard let earning = document.get("price") as? Double else { return }
                    totalEarning += earning
                }
                
                completion(totalEarning)
            }
        }
    }
    
}
