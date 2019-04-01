//
//  ProjectItemDetailViewController.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 27/2/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit


class ProjectItemDetailViewController: UITableViewController {
    var projectItem: ProjectItem? {
        didSet{
            navigationItem.title = projectItem?.location
            guard let deductedValues = projectItem?.deductedValues?.allObjects as? [DeductedValueForItem] else { return }
            let sortedDeductedValues = deductedValues.sorted { (p1, p2) -> Bool in
                return p1.partName ?? "" > p2.partName ?? ""
            }
            self.deductedValues = sortedDeductedValues
        }
    }
    
    let context = CoreDataManager.shared.persistantContainer.viewContext
    let cellId = "cellId"
    let deductionCellId = "deductionCellId"
    var textHasChanged = false
    var stackViewHasChanged = false
    let headerNames = ["Location Name", "Width", "Height", "Memo", "Deductions"]
    
    var deductedValues = [DeductedValueForItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .lightBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(ProjectItemDetailDeductionCell.self, forCellReuseIdentifier: deductionCellId)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.alwaysBounceVertical = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return headerNames.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return deductedValues.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerNames[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return 70
        }
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true
        )
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .whiteBlue
        
        let textField = ProjectDetailAndItemTextField()
        cell.addSubview(textField)
        textField.fillSuperview()
        textField.addTarget(self, action: #selector(handleTextChaged), for: .editingChanged)
        
        if indexPath.section == 0 {
            textField.text = projectItem?.location
            textField.senderTitle = headerNames[0]
        } else if indexPath.section == 1 {
            textField.keyboardType = .numberPad
            textField.text = projectItem?.width
            textField.senderTitle = headerNames[1]
        } else if indexPath.section == 2 {
            textField.keyboardType = .numberPad
            textField.text = projectItem?.height
            textField.senderTitle = headerNames[2]
        } else if indexPath.section == 3 {
            textField.text = projectItem?.memo
            textField.senderTitle = headerNames[3]
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: deductionCellId, for: indexPath) as! ProjectItemDetailDeductionCell
            cell.titleLabel.text = deductedValues[indexPath.row].partName
            cell.widthTextField.text = String(deductedValues[indexPath.row].width)
            cell.widthTextField.senderTitle = deductedValues[indexPath.row].partName
            cell.widthTextField.addTarget(self, action: #selector(handleWidthTextField), for: .editingChanged)
            
            cell.heightTextField.text = String(deductedValues[indexPath.row].height)
            cell.heightTextField.senderTitle = deductedValues[indexPath.row].partName
            cell.heightTextField.addTarget(self, action: #selector(handleHeightTextField), for: .editingChanged)
            
            return cell
        }
        return cell
    }
    
    @objc fileprivate func handleTextChaged(textField: ProjectDetailAndItemTextField) {
        if textField.senderTitle == headerNames[0] {
            projectItem?.location = textField.text
        } else if textField.senderTitle == headerNames[1] {
            projectItem?.width = textField.text
        } else if textField.senderTitle == headerNames[2] {
            projectItem?.height = textField.text
        } else if textField.senderTitle == headerNames[3] {
            projectItem?.memo = textField.text
        }
        textHasChanged = true
    }
    
    @objc fileprivate func handleWidthTextField(textField: ProjectDetailAndItemTextField) {
        let deductedValue = deductedValues.first(where: {$0.partName == textField.senderTitle})
        deductedValue?.width = Int16(textField.text ?? "") ?? 0
        textHasChanged = true
        stackViewHasChanged = true
    }
    
    @objc fileprivate func handleHeightTextField(textField: ProjectDetailAndItemTextField) {
        let deductedValue = deductedValues.first(where: {$0.partName == textField.senderTitle})
        deductedValue?.height = Int16(textField.text ?? "") ?? 0
        textHasChanged = true
        stackViewHasChanged = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if textHasChanged  {
            let projectItemsCollectionViewController = navigationController?.viewControllers[1] as? ProjectItemsCollectionViewController
            if stackViewHasChanged {
                projectItemsCollectionViewController?.setupStackView()
                projectItemsCollectionViewController?.collectionView.reloadData()
            }
            projectItemsCollectionViewController?.collectionView.reloadData()
            
            do {
                try context.save()
            } catch let err {
                print("failed to Save: ", err)
            }
        }
    }
}
