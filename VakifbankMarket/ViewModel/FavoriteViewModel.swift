//
//  FavoriteViewModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 31.07.2024.
//

import Foundation
import Firebase

class FavoriteViewModel {
    func getLikeProduct(completion: @escaping ([ProductModel]?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion([])
            return
        }
        let currentUserID = user.uid
        
        let firestore = Firestore.firestore()
        
        firestore.collection("Product").whereField("likes", arrayContains: currentUserID).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion([])
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
    
    func removeUserFromLikes(productID: String, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }
        let currentUserID = user.uid
        
        let firestore = Firestore.firestore()
        let productRef = firestore.collection("Product").document(productID)
        
        productRef.updateData([
            "likes": FieldValue.arrayRemove([currentUserID])
        ]) { error in
            if let error = error {
                print("Error removing user from likes: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
