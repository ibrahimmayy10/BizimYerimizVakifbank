//
//  ProvincesModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 5.08.2024.
//

import Foundation

struct ProvincesModel: Codable {
    let data: [ProvinceData]
}

struct ProvinceData: Codable {
    let name: String
    let districts: [Districts]
}

struct Districts: Codable {
    let name: String
}
