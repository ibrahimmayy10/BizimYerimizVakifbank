//
//  AddAddressViewModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 5.08.2024.
//

import Foundation
import Firebase

class AddAddressViewModel {
    func addAddress(province: String, district: String, address: String) {
        guard let user = Auth.auth().currentUser else { return }
        let currentUserID = user.uid
        
        let firestore = Firestore.firestore()
        
        let firestoreAddress = ["province": province, "district": district, "address": address] as [String: Any]
        
        firestore.collection("SellerAccountOwners").document(currentUserID).collection("Address").document(currentUserID).setData(firestoreAddress) { error in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("adres eklendi")
            }
        }
    }
}
