//
//  NotificationsTableViewCell.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 12.08.2024.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    static let reuseID = "cellID"
    
    lazy var orderImageView = CustomImageViews()
    
    lazy var confirmLabel = CustomLabels(text: "Onay bekleyen bir yeni siparişiniz bulunmaktadır. Hemen tıklayın, siparişinizi onaylayın!", font: .systemFont(ofSize: 16), color: .gray)
    lazy var notificationLabel = CustomLabels(text: "Bir yeni siparişiniz var", font: .systemFont(ofSize: 18), color: .black)
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTableViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureTableViewCell() {
        contentView.addSubviewsFromExt(orderImageView, confirmLabel, notificationLabel)
        
        contentView.backgroundColor = .white
        
        orderImageView.image = UIImage(systemName: "shippingbox.circle.fill")
        orderImageView.tintColor = .systemGreen
        
        confirmLabel.numberOfLines = 0
        
        orderImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 10, width: 50, height: 50)
        notificationLabel.anchor(left: orderImageView.rightAnchor, centerY: orderImageView.centerYAnchor, paddingLeft: 10)
        confirmLabel.anchor(top: orderImageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
    }

}
