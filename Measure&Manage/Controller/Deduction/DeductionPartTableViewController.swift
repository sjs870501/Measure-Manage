//
//  PartsTableView.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 5/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit
import CoreData

class DeductionPartTableViewController: CustomTableView {
    
    var product: Product? {
        didSet {
            navigationItem.title = "Parts in \(product?.productName ?? "")"
            if let parts = product?.parts {
                guard let allpartsObjects = parts.allObjects as? [Part] else { return }
                self.parts = allpartsObjects
            }
        }
    }
    
    var parts = [Part]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func haddleAdd() {
        
        alert(title: "Part Name", message: "What is the part in this product?") { (action) in
            guard let partName = self.tempTextField.text else { return }
                let indexPath = IndexPath(row: self.parts.count, section: 0)
                let part = Part(context: self.context)
                part.partName = partName
                part.product = self.product
            
                self.save()
            
                self.parts.append(part)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let footerView = super.tableView(tableView, viewForFooterInSection: section) as! UILabel
        
        if parts.count == 0 {
            footerView.text = "Add parts in the product that will need deduction\ne.g if you make roller blind, parts will be tube"
        } else {
            footerView.text = ""
        }
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = parts[indexPath.row].partName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deductionTableViewcontroller = DeductionTableViewController()
        deductionTableViewcontroller.part = parts[indexPath.row]
        navigationController?.pushViewController(deductionTableViewcontroller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return parts.count == 0 ? 200 : 0
    }
    
    override func deleteRowAction(indexPath: IndexPath) {
        context.delete(parts[indexPath.row])
        save()
        self.parts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
