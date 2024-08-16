//
//  ProductDetailsViewModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 31.07.2024.
//

import Foundation
import Firebase

class ProductDetailsViewModel {
    let currentUserID = Auth.auth().currentUser?.uid
    let firestore = Firestore.firestore()
    
    func likeProduct(productID: String) {
        guard let currentUserID = currentUserID else { return }
        
        firestore.collection("Product").document(productID).getDocument { document, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                var likeList = document?.data()?["likes"] as? [String] ?? []
                
                if !likeList.contains(currentUserID) {
                    likeList.append(currentUserID)
                } else {
                    likeList.removeAll { $0 == currentUserID }
                }
                
                self.firestore.collection("Product").document(productID).updateData(["likes": likeList]) { error in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                    } else {
                        print("ürün favorilere eklendi")
                    }
                }
            }
        }
    }
    
    func isProductLiked(productID: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserID = currentUserID else {
            completion(false)
            return
        }
        
        firestore.collection("Product").document(productID).getDocument { document, error in
            if let document = document, document.exists {
                let likeList = document.data()?["likes"] as? [String] ?? []
                completion(likeList.contains(currentUserID))
            } else {
                completion(false)
            }
        }
    }
    
    func addProductToCart(productID: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserID = currentUserID else {
            completion(false)
            return
        }
        
        let cartDocument = firestore.collection("MyCart").document(productID)
            
        cartDocument.getDocument { document, error in
            if let document = document, document.exists {
                print("Bu ürün zaten sepette")
                completion(false)
            } else {
                let firestoreProduct = ["productID": productID, "userID": currentUserID, "quantity": 1] as [String: Any]
                
                cartDocument.setData(firestoreProduct) { error in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                        completion(false)
                    } else {
                        print("Ürün sepete eklendi")
                        completion(true)
                    }
                }
            }
        }
    }
    
    func getDataEvaluate(productID: String, completion: @escaping ([EvaluateModel]?) -> Void) {
        firestore.collection("Product").document(productID).collection("Evaluate").getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(nil)
            } else if let documents = snapshot?.documents {
                var evaluateModel = [EvaluateModel]()
                
                for document in documents {
                    let data = document.data()
                    
                    guard let evaluate = EvaluateModel.createFrom(data) else {
                        completion(nil)
                        return
                    }
                    
                    evaluateModel.append(evaluate)
                }
                
                completion(evaluateModel)
            }
        }
    }
    
    func getAverageRating(productID: String, completion: @escaping (Double?) -> Void) {
        getDataEvaluate(productID: productID) { evaluateModels in
            guard let evaluateModels = evaluateModels, !evaluateModels.isEmpty else {
                completion(nil)
                return
            }
            
            let totalPoints = evaluateModels.reduce(0) { $0 + $1.point }
            let average = Double(totalPoints) / Double(evaluateModels.count)
            completion(average)
        }
    }
}
