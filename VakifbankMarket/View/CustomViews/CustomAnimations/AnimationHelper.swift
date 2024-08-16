//
//  VC+Ext.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 2.08.2024.
//

import UIKit

class AnimationHelper {
    static func animateCell(cell: UIView, in view: UIView, completion: @escaping () -> Void) {
        let originalFrame = cell.convert(cell.bounds, to: nil)
        let zoomedFrame = CGRect(x: originalFrame.origin.x - 20, y: originalFrame.origin.y - 20, width: originalFrame.size.width + 40, height: originalFrame.size.height + 40)
        
        let snapshot = cell.snapshotView(afterScreenUpdates: false)
        snapshot?.frame = originalFrame
        view.addSubview(snapshot!)
        
        UIView.animate(withDuration: 0.3, animations: {
            snapshot?.frame = zoomedFrame
            snapshot?.alpha = 0
        }, completion: { _ in
            snapshot?.removeFromSuperview()
            completion()
        })
    }
    
    static func navigateToProductDetailsVC(product: ProductModel, from navigationController: UINavigationController?) {
        let productDetailsVC = ProductDetailsVC()
        productDetailsVC.product = product
        navigationController?.pushViewController(productDetailsVC, animated: false)
    }
    
    static func addProductToCartAnimate(view: UIView) {
        let successImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        successImageView.tintColor = .systemOrange
        successImageView.alpha = 0.0
        successImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(successImageView)
        
        NSLayoutConstraint.activate([
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            successImageView.widthAnchor.constraint(equalToConstant: 100),
            successImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        UIView.animate(withDuration: 0.5, animations: {
            successImageView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
                successImageView.alpha = 0.0
            }, completion: { _ in
                successImageView.removeFromSuperview()
            })
        }
    }
    
    static func animateLabel(label: UILabel, moveUp: Bool) {
        UIView.animate(withDuration: 0.3) {
            label.transform = moveUp ? CGAffineTransform(translationX: 0, y: -30) : .identity
            label.font = moveUp ? UIFont.systemFont(ofSize: 12) : UIFont.systemFont(ofSize: 17)
        }
    }
}
