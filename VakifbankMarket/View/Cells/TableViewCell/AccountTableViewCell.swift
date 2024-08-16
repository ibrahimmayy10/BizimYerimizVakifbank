//
//  AccountTableViewCell.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 8.08.2024.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    
    static let reuseID = "cellID"
    
    lazy var cellBarView = CustomViews(color: .white)
    lazy var separatorLine = CustomViews(color: .systemGray4)
    
    lazy var orderImageView = CustomImageViews()
    
    lazy var dateLabel = CustomLabels(text: "", font: .systemFont(ofSize: 16), color: .gray)
    lazy var totalLabel = CustomLabels(text: "Toplam:", font: .systemFont(ofSize: 16), color: .gray)
    lazy var priceLabel = CustomLabels(text: "", font: .systemFont(ofSize: 16), color: .systemYellow)
    
    lazy var detailsButton = CustomButtons(title: "Detaylar", textColor: .systemYellow, buttonColor: .white, radius: 0, imageName: "", buttonTintColor: .white)
    lazy var evaluateButton = CustomButtons(title: "Değerlendir", textColor: .black, buttonColor: .white, radius: 5, imageName: "star.fill", buttonTintColor: .systemYellow)
    
    weak var delegate: EvaluateProductDelegate?
    var product: ProductModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTableView()
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
    
    @objc func evaluateButtonClicked() {
        guard let product = product else { return }
        delegate?.didTapEvaluateButton(product: product)
    }
    
    func configureTableView() {
        contentView.addSubview(cellBarView)
        cellBarView.addSubviewsFromExt(orderImageView, dateLabel, totalLabel, priceLabel, separatorLine, detailsButton, evaluateButton)
        
        contentView.backgroundColor = .white
        
        evaluateButton.layer.borderWidth = 2
        evaluateButton.layer.borderColor = UIColor.systemYellow.cgColor
        
        cellBarView.layer.cornerRadius = 10
        cellBarView.layer.shadowColor = UIColor.black.cgColor
        cellBarView.layer.shadowOpacity = 0.2
        cellBarView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cellBarView.layer.shadowRadius = 5
        cellBarView.backgroundColor = .white
                
        orderImageView.contentMode = .scaleAspectFit
        orderImageView.layer.cornerRadius = 10
        orderImageView.clipsToBounds = true
        
        cellBarView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, bottom: contentView.bottomAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, paddingBottom: 10)
        
        dateLabel.anchor(top: cellBarView.topAnchor, left: cellBarView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        totalLabel.anchor(top: dateLabel.bottomAnchor, left: cellBarView.leftAnchor, paddingTop: 5, paddingLeft: 10)
        priceLabel.anchor(top: dateLabel.bottomAnchor, left: totalLabel.rightAnchor, paddingTop: 5, paddingLeft: 5)
        detailsButton.anchor(top: cellBarView.topAnchor, right: cellBarView.rightAnchor, paddingTop: 10, paddingRight: 10)
        separatorLine.anchor(top: totalLabel.bottomAnchor, left: cellBarView.leftAnchor, right: cellBarView.rightAnchor, paddingTop: 20, height: 1)
        orderImageView.anchor(top: separatorLine.bottomAnchor, left: cellBarView.leftAnchor, bottom: cellBarView.bottomAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, width: 100)
        evaluateButton.anchor(right: cellBarView.rightAnchor, centerY: orderImageView.centerYAnchor, paddingRight: 10, width: 150, height: 30)
    }
    
    func configure(product: ProductModel, order: OrderModel) {
        let date = order.time.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: date)
        
        dateLabel.text = formattedDate
        
        let price = product.price
        
        if price.truncatingRemainder(dividingBy: 1) == 0 {
            priceLabel.text = "\(Int(price)) TL"
        } else {
            priceLabel.text = String(format: "%.2f TL", price)
        }
        
        orderImageView.sd_setImage(with: URL(string: product.imageUrls.first ?? ""))
        
        self.product = product
        
        evaluateButton.addTarget(self, action: #selector(evaluateButtonClicked), for: .touchUpInside)
    }

}
