//
//  EvaluateViewModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 9.08.2024.
//

import Foundation
import Firebase

class EvaluateViewModel {
    func getDataName(completion: @escaping (String) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion("")
            return
        }
        
        let currentUserID = user.uid
        
        let firestore = Firestore.firestore()
        
        firestore.collection("SellerAccountOwners").document(currentUserID).getDocument { document, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion("")
            } else if let document = document {
                guard let name = document.get("nameSurname") as? String else { return }
                completion(name)
            }
        }
    }
    
    func evaluateTheProduct(productID: String, comment: String, point: Int, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }
        
        let currentUserID = user.uid
        
        let firestore = Firestore.firestore()
        
        let evaluateRef = firestore.collection("Product").document(productID).collection("Evaluate").document()
        
        getDataName { name in
            let firestoreEvaluate = ["comment": comment, "evaluateID": evaluateRef.documentID, "point": point, "commenterID": currentUserID, "name": name] as [String: Any]
            
            evaluateRef.setData(firestoreEvaluate) { error in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    completion(false)
                } else {
                    print("değerlendirme başarılı")
                    completion(true)
                }
            }
            
        }
    }
}
