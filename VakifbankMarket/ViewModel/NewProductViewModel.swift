//
//  AddProductViewModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 24.07.2024.
//

import Foundation
import Firebase
import UIKit

class NewProductViewModel {
    func addProduct(productName: String, 
                    explanation: String,
                    category: String,
                    brand: String,
                    color: String,
                    price: Double,
                    stockQuantity: Int,
                    image1: UIImage,
                    image2: UIImage,
                    image3: UIImage,
                    completion: @escaping (Bool) -> Void) {
        
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }
        
        let currentUserID = user.uid
        
        let firestore = Firestore.firestore()
        
        let productRef = firestore.collection("Product").document()
        
        let imageStorageRef = Storage.storage().reference().child("product_images/\(productRef.documentID)")
                
        let uploadGroup = DispatchGroup()
        var imageUrls: [String] = []
        let images: [UIImage] = [image1, image2, image3]
        
        for (index, image) in images.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 0.75) else { continue }
            
            let imageRef = imageStorageRef.child("image\(index + 1).jpg")
            
            uploadGroup.enter()
            
            imageRef.putData(imageData, metadata: nil) { (_, error) in
                if error != nil {
                    uploadGroup.leave()
                    completion(false)
                    return
                }
                
                imageRef.downloadURL { (url, error) in
                    if let url = url {
                        imageUrls.append(url.absoluteString)
                    }
                    uploadGroup.leave()
                }
            }
            
            uploadGroup.notify(queue: .main) {
                let firestoreProduct = ["productName": productName,
                                        "explanation": explanation,
                                        "category": category,
                                        "brand": brand,
                                        "color": color,
                                        "price": price,
                                        "stockQuantity": stockQuantity,
                                        "imageUrls": imageUrls,
                                        "userID": currentUserID,
                                        "productID": productRef.documentID] as [String: Any]
                
                productRef.setData(firestoreProduct) { error in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                        completion(false)
                    } else {
                        print("ürün başarıyla yüklendi")
                        completion(true)
                    }
                }
            }
            
        }
    }
}
