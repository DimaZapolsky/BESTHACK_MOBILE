//
// Created by Ирина Улитина on 2019-03-30.
// Copyright (c) 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CardTableViewCell: UITableViewCell {

    lazy var cardNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        return label
    }()

    lazy var bankNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.setContentHuggingPriority(UILayoutPriority(252), for: .horizontal)
        return label
    }()

    lazy var bankAndDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [bankNameLabel, dateLabel])
        sv.axis = .horizontal
        sv.distribution = .fill

        sv.spacing = 8
        return sv
    }()

    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [bankAndDateStackView, cardNameLabel])
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            self.mainStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.mainStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.mainStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.mainStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(card: CardEntity) {
        self.bankNameLabel.text = "Bank: " + (card.bankName ?? "Undefined")
        let formatter = DateFormatter()
        formatter.dateFormat = "mm/yy"
        if let expDate = card.expirationDate {
            self.dateLabel.text = "Exp.Date: " + formatter.string(from: expDate)
        } else {
            self.dateLabel.text = "Exp.Date: " + "Undefined"
        }
        self.cardNameLabel.text = "Card: " + (card.cardNumber ?? "Undefined")
    }
}
