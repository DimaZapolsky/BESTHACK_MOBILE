//
//  ConfirmationFooter.swift
//  HackMobile
//
//  Created by Ирина Улитина on 30/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ConfirmationFooterView: UIView {
    
    private var disposeBag = DisposeBag()
    
    private lazy var confirmationButton: UIButton = {
        let b = UIButton()
        b.clipsToBounds = true
        b.layer.cornerRadius = 10
        b.backgroundColor = .tealBlue
        b.layer.borderWidth = 0.5
        b.layer.borderColor = UIColor.gray.cgColor
        b.setTitle("Confirm", for: .normal)
        b.setTitleColor(UIColor.black, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    public var confirmationButtonTap: Observable<Void> {
        return confirmationButton.rx.tap.asObservable()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(confirmationButton)
        NSLayoutConstraint.activate([
            confirmationButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            confirmationButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            confirmationButton.heightAnchor.constraint(equalToConstant: 50),
            confirmationButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            confirmationButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4, constant: -10)
            ])
        self.confirmationButton.rx.tap.subscribe(onNext:{ (_) in
            self.confirmationButton.blink()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
