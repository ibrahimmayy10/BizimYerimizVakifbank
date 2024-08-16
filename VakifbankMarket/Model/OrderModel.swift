//
//  OrderModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 8.08.2024.
//

import Foundation
import Firebase

struct OrderModel {
    let productID: String
    let buyerID: String
    let quantity: Int
    let salesID: String
    let time: Timestamp
    
    static func createFrom(_ data: [String: Any]) -> OrderModel? {
        let productID = data["productID"] as? String
        let buyerID = data["buyerID"] as? String
        let quantity = data["quantity"] as? Int
        let salesID = data["salesID"] as? String
        let time = data["time"] as? Timestamp
        
        return OrderModel(productID: productID ?? "", buyerID: buyerID ?? "", quantity: quantity ?? 1, salesID: salesID ?? "", time: time ?? Timestamp())
    }
}
