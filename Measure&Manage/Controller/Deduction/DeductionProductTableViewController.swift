//
//  DeductionTableViewController.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 5/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit
import CoreData

class DeductionProductTableViewController: CustomTableView {
    
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Product"
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            products = try context.fetch(request)
        } catch let err {
            print("failed to fetch: ", err)
        }
    }
    
    override func haddleAdd() {
        alert(title: "Product Name", message: "what is your product you'll make?") { (action) in
            guard let productName = self.tempTextField.text else { return }
                let indexPath = IndexPath(row: self.products.count, section: 0)
                let product = Product(context: self.context)
                product.productName = productName
                self.save()
                self.products.append(product)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = products[indexPath.row].productName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = super.tableView(tableView, viewForFooterInSection: section) as? UILabel else { return UILabel() }
        if products.count == 0 {
            footerView.text = "Add products you will make\ne.g if you make roller blind, \nproduct will be roller blind \nand parts will be tube"
        } else {
            footerView.text = ""
        }
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return products.count == 0 ? 200 : 0
    }
    
    override func deleteRowAction(indexPath: IndexPath) {
        context.delete(products[indexPath.row])
        save()
        products.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deductionPartTableViewController = DeductionPartTableViewController()
        deductionPartTableViewController.product = self.products[indexPath.row]
        navigationController?.pushViewController(deductionPartTableViewController, animated: true)
    }
    
}
