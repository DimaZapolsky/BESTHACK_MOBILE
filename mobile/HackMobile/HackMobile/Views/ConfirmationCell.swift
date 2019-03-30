//
//  ConfirmationCell.swift
//  HackMobile
//
//  Created by Ирина Улитина on 30/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension UIView {
    func blink() {
        self.alpha = 0.2
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear], animations: { self.alpha = 1.0 }, completion: nil)
    }
}

class UITextFieldWithInsets: UITextField {
    
    private var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.insets)
    }
    
    override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        let mySize = CGSize(width: superSize.width + 15, height: superSize.height)
        return mySize
    }
    
    init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)) {
        self.insets = insets
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class ConfirmationViewCell: UITableViewCell {
    
    private var disposeBag = DisposeBag()
    
    public static let cellId = "ConfirmationCellId"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func shouldEnableEditing(_ editing: Bool) {
        self.credentialNameTextField.isEnabled = editing
        self.credentialValueTextField.isEnabled = editing
    }
    
    
    let credentialNameTextField: UITextFieldWithInsets = {
        let tf = UITextFieldWithInsets()
        tf.font = UIFont.boldSystemFont(ofSize: 18)
        tf.isEnabled = false
        tf.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let credentialValueTextField: UITextFieldWithInsets = {
        let tf = UITextFieldWithInsets()
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.isEnabled = false;
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let sv = UIStackView(arrangedSubviews: [credentialNameTextField, credentialValueTextField])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(sv)
        
        NSLayoutConstraint.activate([
            sv.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15),
            sv.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -15),
            sv.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            sv.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
            ])
    }
    
    func configure(credentialName: String, credentialValue: String, editListener: ReplaySubject<Bool>) {
        self.credentialNameTextField.text = credentialName
        self.credentialValueTextField.text = credentialValue
        
        editListener.subscribe(onNext: { (val) in
            self.shouldEnableEditing(val)
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
