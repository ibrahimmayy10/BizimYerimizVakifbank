//
//  ProductModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 25.07.2024.
//

import Foundation

struct ProductModel: Codable {
    let productID: String
    let productName: String
    let explanation: String
    let category: String
    let brand: String
    let color: String
    let price: Double
    let stockQuantity: Int
    let imageUrls: [String]
    let userID: String
    let likes: [String]
    
    static func createFrom(_ data: [String: Any]) -> ProductModel? {
        let productID = data["productID"] as? String
        let productName = data["productName"] as? String
        let explanation = data["explanation"] as? String
        let category = data["category"] as? String
        let brand = data["brand"] as? String
        let color = data["color"] as? String
        let price = data["price"] as? Double
        let stockQuantity = data["stockQuantity"] as? Int
        let imageUrls = data["imageUrls"] as? [String]
        let userID = data["userID"] as? String
        let likes = data["likes"] as? [String]
        
        return ProductModel(productID: productID ?? "", productName: productName ?? "", explanation: explanation ?? "", category: category ?? "", brand: brand ?? "", color: color ?? "", price: price ?? 0, stockQuantity: stockQuantity ?? 0, imageUrls: imageUrls ?? [], userID: userID ?? "", likes: likes ?? [])
    }
}
