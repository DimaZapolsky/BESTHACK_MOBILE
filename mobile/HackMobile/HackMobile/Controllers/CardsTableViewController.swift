//
//  CardsTableViewController.swift
//  HackMobile
//
//  Created by Ирина Улитина on 30/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CardsTableViewController: UITableViewController {
    
    private var fetchedResultController: NSFetchedResultsController<CardEntity>! {
        didSet {
            fetchedResultController.delegate = self
            do {
                try fetchedResultController.performFetch()
                self.tableView.reloadData()
            } catch let err {
                print(err)
            }
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.navigationItem.title = "Your Cards"
        self.tableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.cellId)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Card", style: .plain, target: self, action: #selector(handleAddButtonTap(_:)))
        self.fetchedResultController = StorageManager.shared.generateFRC()
        self.tableView.rowHeight = UIScreen.main.bounds.width / 2.3


    }

    @objc func handleAddButtonTap(_ sender: Any?) {
        let alertController = UIAlertController(title: "Choose Add Method", message: "", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertController.dismiss(animated: true)
        }
        let byPhotoAction = UIAlertAction(title: "By Photo", style: .default) { action in
            self.navigationController?.pushViewController(ViewController(), animated: true)
        }

        alertController.addAction(byPhotoAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.fetchedResultController = StorageManager.shared.generateFRC()
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardsTableViewController: NSFetchedResultsControllerDelegate {
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                           at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .automatic)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.cellId, for: indexPath) as! CardTableViewCell
        cell.configure(card: fetchedResultController.object(at: indexPath))
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ValidationFormController(card: self.fetchedResultController.object(at: indexPath))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            StorageManager.shared.eraseCard(card: self.fetchedResultController.object(at: indexPath))
        }
        return [action]
    }
}
