//
//  Protocols.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 1.08.2024.
//

import Foundation

protocol SelectedColorDelegate: AnyObject {
    func didChooseColor(colorName: String)
}

protocol FavoriteTableViewCellDelegate: AnyObject {
    func didTapAddBasketButton(product: ProductModel)
    func didTapBuyNowButton(product: ProductModel)
}

protocol EvaluateProductDelegate: AnyObject {
    func didTapEvaluateButton(product: ProductModel)
}
