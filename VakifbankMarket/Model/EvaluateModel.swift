//
//  EvaluateModel.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 9.08.2024.
//

import Foundation

struct EvaluateModel {
    let evaluateID: String
    let commenterID: String
    let comment: String
    let point: Int
    let name: String
    
    static func createFrom(_ data: [String: Any]) -> EvaluateModel? {
        let evaluateID = data["evaluateID"] as? String
        let commenterID = data["commenterID"] as? String
        let comment = data["comment"] as? String
        let point = data["point"] as? Int
        let name = data["name"] as? String
        
        return EvaluateModel(evaluateID: evaluateID ?? "", commenterID: commenterID ?? "", comment: comment ?? "", point: point ?? 1, name: name ?? "")
    }
}
