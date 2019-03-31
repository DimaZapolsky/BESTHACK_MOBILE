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

    private var card: CodableCard?
    
    private var cardCoreData: CardEntity?

    init(card: CodableCard) {
        self.card = card
        super.init(nibName: nil, bundle: nil)
    }
    
    init(card: CardEntity?) {
        self.cardCoreData = card
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func saveCardBank() {
        
        if (self.card != nil) {
            StorageManager.shared.createCard(decodedCard: self.card!)
            
            DispatchQueue.main.async {
                self.present(UIAlertController.genAlertController(title: "Success", message: "Successfully created new card", okActionCompletion: { (_) in
                    self.navigationController?.popViewController(animated: true)
                }), animated: true, completion: nil)
                //self.navigationController?.popViewController(animated: true)
            }
        } else {
            if let textColor = self.card?.color {
            self.cardCoreData?.textColor = NSKeyedArchiver.archivedData(withRootObject: textColor)
            }
            if let color = self.card?.bankInfo?.backgroundColor {
            self.cardCoreData?.color = NSKeyedArchiver.archivedData(withRootObject: color)
            }
            StorageManager.shared.save()
            self.present(UIAlertController.genAlertController(title: "Success", message: "Successfully created new card", okActionCompletion: { (_) in
                self.navigationController?.popViewController(animated: true)
            }), animated: true, completion: nil)
        }
            
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveCardBank))
        
        form +++ Section("Main Info")
            <<< TextRow(){ row in
            row.title = "Card Number"
            row.placeholder = "Enter text here"
            row.value = (card?.cardNumber ?? cardCoreData?.cardNumber) ?? ""
                    }.onChange({ (tr) in
                        if self.card != nil {
                            self.card!.cardNumber = tr.value
                        } else {
                            self.cardCoreData?.cardNumber = tr.value
                        }
                    })
                <<< TextRow() {
            $0.title = "Bank Name"
            $0.value = (card?.bankInfo?.name ?? cardCoreData?.bankName) ?? ""
                    }.onChange({ (tr) in
                        if self.card != nil {
                            self.card!.bankInfo?.name = tr.value
                        } else {
                            self.cardCoreData?.bankName = tr.value
                        }
                    })
                <<< TextRow() {
            $0.title = "Holder Name"
                $0.value = (card?.cardHolderName ?? cardCoreData?.cardHolderName) ?? ""
                    }.onChange({ (tr) in
                        if self.card != nil {
                            self.card!.cardHolderName = tr.value
                        } else {
                            self.cardCoreData?.cardHolderName = tr.value
                        }
                    })
                <<< DateRow() {
            $0.title = "Exp.Date"
                    $0.value = (card?.expirationDate ?? cardCoreData?.expirationDate) ?? Date()
                    }.onChange({ (tr) in
                        if self.card != nil {
                            self.card!.expirationDate = tr.value
                        } else {
                            self.cardCoreData?.expirationDate = tr.value
                        }
                    })
        
        /*form +++ Section("") { section in
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
        }*/
        
        /*var footer = HeaderFooterView<ConfirmationFooterView>(.callback {
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
        
        form.first?.footer = footer*/
    }
}
