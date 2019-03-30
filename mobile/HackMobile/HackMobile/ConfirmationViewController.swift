//
//  ConfirmationViewController.swift
//  HackMobile
//
//  Created by Ирина Улитина on 30/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ConfirmationTableViewController: UITableViewController {
    
    private var onEditButtonTapped = ReplaySubject<Bool>.create(bufferSize: 1)
    
    private var credentials: [String: String] = [:]
    
    private var credentialsArray: [(String, String)] = []
    
    init(credential: [String: String]) {
        self.credentials = credential
        self.credentialsArray = credential.sorted(by: { (lhs, rhs) -> Bool in
            lhs.key < rhs.key
        }).map({ (key, val) -> (String, String) in
            return (key, val)
        })
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var editBarButton: UIBarButtonItem = {
        let bar = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onEditTapped(_:)))
        
        return bar
    }()
    
    @objc func onEditTapped(_ sender: UIBarButtonItem) {
        onEditButtonTapped.onNext(sender.title == "Edit")
        if sender.title == "Edit" {
            sender.title = "Save"
        } else {
            sender.title = "Edit"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Credentials"
        self.navigationItem.rightBarButtonItem = editBarButton
        self.tableView.register(ConfirmationViewCell.self, forCellReuseIdentifier: ConfirmationViewCell.cellId)
        self.tableView.rowHeight = 70
        self.onEditButtonTapped.onNext(false)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credentials.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ConfirmationViewCell.cellId, for: indexPath) as! ConfirmationViewCell
        
        cell.configure(credentialName: credentialsArray[indexPath.row].0, credentialValue: credentialsArray[indexPath.row].1, editListener: self.onEditButtonTapped)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = ConfirmationFooterView()
        return view
    }
    
}
