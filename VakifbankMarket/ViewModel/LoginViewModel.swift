//
//  LoginViewModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 23.07.2024.
//

import Foundation
import Firebase

class LoginViewModel {
    
    func commercialLogin(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authdata, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(false)
            } else {
                let firestore = Firestore.firestore()
                
                firestore.collection("SellerAccountOwners").whereField("userID", isEqualTo: Auth.auth().currentUser?.uid ?? "").getDocuments { snapshot, error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                        return
                    }
                    
                    if let snapshot = snapshot, !snapshot.isEmpty {
                        print("Giriş işlemi başarılı")
                        completion(true)
                    } else {
                        print("Customer number not found")
                        completion(false)
                    }
                }
            }
        }
    }
    
}
