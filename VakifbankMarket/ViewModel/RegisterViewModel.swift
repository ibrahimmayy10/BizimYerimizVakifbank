//
//  RegisterViewModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 23.07.2024.
//

import Foundation
import Firebase

class RegisterViewModel {
    
    func commercialRegister(nameSurname: String, email: String, telNo: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authData, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                guard let user = authData?.user else {
                    completion(false)
                    return
                }
                let currentUserID = user.uid
                
                let firestore = Firestore.firestore()
                
                let firestoreUser = ["userID": currentUserID, "nameSurname": nameSurname, "telNo": telNo]
                
                firestore.collection("SellerAccountOwners").document(currentUserID).setData(firestoreUser) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                    } else {
                        print("kayıt işlemi başarılı")
                        completion(true)
                    }
                }
            }
        }
    }
    
}
