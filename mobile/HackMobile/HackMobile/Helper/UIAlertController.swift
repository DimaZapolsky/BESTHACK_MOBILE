//
//  UIAlertController.swift
//  HackMobile
//
//  Created by Ирина Улитина on 30/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertAction {
    static let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
}

extension UIAlertController {
    static func genAlertController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.okAction)
        return alertController
    }
    
    static func genAlertController(title: String, message: String, okActionCompletion:  @escaping (UIAlertAction) -> ()) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: okActionCompletion))
        return alertController
    }
}
