//
//  ConfirmCartViewModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 5.08.2024.
//

import Foundation
import Firebase

class ConfirmCartViewModel {
    let currentUserID = Auth.auth().currentUser?.uid
    let firestore = Firestore.firestore()
    
    func fetchAddresses(completion: @escaping ([String]) -> Void) {
        guard let currentUserID = currentUserID else { return }
        
        firestore.collection("SellerAccountOwners").document(currentUserID).collection("Address").getDocuments { snapshot, error in
            if error != nil {
                completion([])
            } else {
                var addresses = [String]()
                snapshot?.documents.forEach { document in
                    if let address = document.data()["address"] as? String {
                        addresses.append(address)
                    }
                }
                completion(addresses)
            }
        }
    }
    
    func saveCardInfo(cardNo: String, month: String, year: String) {
        guard let currentUserID = currentUserID else { return }
        
        let firestoreCardInfo = ["cardNo": cardNo, "month": month, "year": year] as [String: Any]
        
        firestore.collection("SellerAccountOwners").document(currentUserID).collection("CardInfo").document(currentUserID).setData(firestoreCardInfo) { error in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("kart eklendi")
            }
        }
    }
    
    func fetchCardInfo(completion: @escaping ([String]) -> Void) {
        guard let currentUserID = currentUserID else { return }
        
        firestore.collection("SellerAccountOwners").document(currentUserID).collection("CardInfo").getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion([])
            } else {
                var cardInfo = [String]()
                
                snapshot?.documents.forEach { document in
                    if let cardNo = document.data()["cardNo"] as? String {
                        cardInfo.append(cardNo)
                    }
                }
                
                completion(cardInfo)
            }
        }
    }
    
    func confirmOrder(productID: String, salesID: String, quantity: Int, price: Double, completion: @escaping (Bool) -> Void) {
        guard let currentUserID = currentUserID else {
            completion(false)
            return
        }
        
        let firestoreOrder = ["productID": productID, "buyerID": currentUserID, "salesID": salesID, "confirm": false, "delivery": false, "quantity": quantity, "price": price, "time": FieldValue.serverTimestamp()] as [String: Any]
        
        firestore.collection("Orders").addDocument(data: firestoreOrder) { error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(false)
            } else {
                let salesRef = self.firestore.collection("Sales").document()
                let firestoreSales = ["productID": productID, "salesID": salesID, "price": price, "buyerID": currentUserID, "saleID": salesRef.documentID, "confirm": false, "delivery": false] as [String: Any]
                
                salesRef.setData(firestoreSales) { error in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                        completion(false)
                    } else {
                        let productRef = self.firestore.collection("Product").document(productID)
                        
                        productRef.getDocument { document, error in
                            if error != nil {
                                print(error?.localizedDescription ?? "")
                                completion(false)
                            } else if let document = document, document.exists {
                                let data = document.data()
                                
                                guard var stockQuantity = data?["stockQuantity"] as? Int else { return }
                                stockQuantity = stockQuantity - quantity
                                
                                if stockQuantity == 0 {
                                    let soldOutProductData = data
                                    
                                    productRef.delete { error in
                                        if error != nil {
                                            print(error?.localizedDescription ?? "")
                                            completion(false)
                                        } else {
                                            self.firestore.collection("SoldOutProducts").document(productID).setData(soldOutProductData ?? [:]) { error in
                                                if error != nil {
                                                    print(error?.localizedDescription ?? "")
                                                    completion(false)
                                                } else {
                                                    print("Ürün TükenenÜrünler tablosuna eklendi")
                                                    completion(true)
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    productRef.updateData(["stockQuantity": stockQuantity]) { error in
                                        if error != nil {
                                            print(error?.localizedDescription ?? "")
                                            completion(false)
                                        } else {
                                            self.firestore.collection("MyCart").document(productID).delete { error in
                                                if error != nil {
                                                    print(error?.localizedDescription ?? "")
                                                    completion(false)
                                                } else {
                                                    print("sipariş onaylandı")
                                                    completion(true)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
