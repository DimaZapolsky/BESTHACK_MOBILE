//
//  FormController.swift
//  HackMobile
//
//  Created by Ирина Улитина on 30/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import RxSwift

class ValidationFormController: FormViewController {

    private var disposeBag = DisposeBag()

    private var card: CodableCard

    init(card: CodableCard) {
        self.card = card
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Main Info") { section in
            var footer = HeaderFooterView<ConfirmationFooterView>(.callback {
                let view = ConfirmationFooterView()
                //view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                
                view.confirmationButtonTap.subscribe(onNext: { (_) in
                    do {

                        StorageManager.shared.createCard(decodedCard: self.card)

                        DispatchQueue.main.async {
                            self.present(UIAlertController.genAlertController(title: "Success", message: "Successfully created new card", okActionCompletion: { (_) in
                                self.navigationController?.popViewController(animated: true)
                            }), animated: true, completion: nil)
                            //self.navigationController?.popViewController(animated: true)
                        }

                    } catch let err {
                        print(err)
                        fatalError()
                    }
                }).disposed(by: self.disposeBag)
                return view
            })
            footer.height = { 60 }
            section.footer = footer
        }
                <<< TextRow(){ row in
            row.title = "Card Number"
            row.placeholder = "Enter text here"
            row.value = card.cardNumber
        }
                <<< TextRow() {
            $0.title = "Bank Name"
            $0.value = card.bankName
        }
                <<< TextRow() {
            $0.title = "Holder Name"
            $0.value = card.cardHolderName
        }
                <<< DateRow() {
            $0.title = "Exp.Date"
            $0.value = card.expirationDate
        }

    }
}
