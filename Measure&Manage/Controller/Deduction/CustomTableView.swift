//
//  CustomTableView.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 14/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit
import CoreData

class CustomTableView: UITableViewController {
    
    let context = CoreDataManager.shared.persistantContainer.viewContext
    
    let cellId = "deductCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .lightBlue
        tableView.separatorStyle = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-plus-30").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(haddleAdd))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc func haddleAdd() {

    }
    
    var tempTextField = UITextField()
    
    func alert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            self.tempTextField = textField }
        let action = UIAlertAction(title: "OK", style: .destructive, handler: handler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .normalBlue
        cell.textLabel?.textColor = .whiteBlue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 24, weight: .light)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UILabel()
        footerView.textAlignment = .center
        footerView.numberOfLines = 0
        footerView.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteRowAction(indexPath: indexPath)
        }
        return [deleteRowAction]
    }
    
    func deleteRowAction(indexPath: IndexPath) {
        
    }
    
    func save() {
        do {
            try self.context.save()
        } catch let err {
            print("failed to save: ", err)
        }
    }
}
