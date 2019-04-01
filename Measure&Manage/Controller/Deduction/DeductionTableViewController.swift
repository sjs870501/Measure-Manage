//
//  DeductionTableViewController.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 11/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit
import CoreData

class DeductionTableViewController: CustomTableView {
    
    var part: Part? {
        didSet {
            navigationItem.title = "Deduction in \(part?.partName ?? "")"
            if let deductions = part?.deductions {
                guard let allpartsObjects = deductions.allObjects as? [Deduction] else { return }
                self.deductions = allpartsObjects
            }
        }
    }
    
    var deductions = [Deduction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func haddleAdd() {
        alert(title: "Deduction name", message: "what is the deduction in this part?") { (action) in
            guard let deductionName = self.tempTextField.text else { return }
            let indexPath = IndexPath(row: self.deductions.count, section: 0)
            let deduction = Deduction(context: self.context)
                deduction.deductionName = deductionName
                deduction.part = self.part
            
                self.save()
            
                self.deductions.append(deduction)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = deductions[indexPath.row].deductionName
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deductions.count
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = super.tableView(tableView, viewForFooterInSection: section) as! UILabel
        
        if deductions.count == 0 {
            footerView.text = "Add parts in the product that will need deduction\ne.g if you make roller blind, parts will be tube"
        } else {
            footerView.text = ""
        }
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return deductions.count == 0 ? 200 : 0
    }
    
    override func deleteRowAction(indexPath: IndexPath) {
        context.delete(deductions[indexPath.row])
        save()
        self.deductions.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deduction = deductions[indexPath.row]
        let deductionDetailTableView = DeductionDetailTableViewController()
        let navViewController = UINavigationController(rootViewController: deductionDetailTableView)
        deductionDetailTableView.deduction = deduction
        present(navViewController, animated: true, completion: nil)
    }
}
