//
//  CartViewModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 1.08.2024.
//

import Foundation
import Firebase

class CartViewModel {
    let firestore = Firestore.firestore()
    
    func removeProductFromCarts(productID: String, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }
        let currentUserID = user.uid
        
        firestore.collection("MyCart").whereField("productID", isEqualTo: productID).whereField("userID", isEqualTo: currentUserID).getDocuments { snapshot, error in
            if let error = error {
                print("Error removing product: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(false)
                return
            }
            
            let batch = self.firestore.batch()
            for document in documents {
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { error in
                if let error = error {
                    print("Error committing batch: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    func getDataProductID(completion: @escaping ([String: Int]) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion([:])
            return
        }
        let currentUserID = user.uid
        
        firestore.collection("MyCart").whereField("userID", isEqualTo: currentUserID).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching cart data: \(error.localizedDescription)")
                completion([:])
            } else if let documents = snapshot?.documents {
                var productQuantities = [String: Int]()
                for document in documents {
                    let data = document.data()
                    if let productID = data["productID"] as? String, let quantity = data["quantity"] as? Int {
                        productQuantities[productID] = quantity
                    }
                }
                completion(productQuantities)
            } else {
                completion([:])
            }
        }
    }
    
    func getDataProductsInTheCart(completion: @escaping ([CartModel]?) -> Void) {
        self.getDataProductID { productQuantities in
            var productList = [CartModel]()
            let group = DispatchGroup()
            
            for (productID, quantity) in productQuantities {
                group.enter()
                self.firestore.collection("Product").document(productID).getDocument { document, error in
                    if let error = error {
                        print("Error fetching document: \(error.localizedDescription)")
                        group.leave()
                    } else if let document = document, document.exists {
                        if let data = document.data(), let productModel = ProductModel.createFrom(data) {
                            let productWithQuantity = CartModel(product: productModel, quantity: quantity)
                            productList.append(productWithQuantity)
                        }
                        group.leave()
                    } else {
                        print("Document does not exist")
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                completion(productList)
            }
        }
    }
    
}
