//
//  ProjectDetailsTableViewController.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 27/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit
import CoreData


extension ProjectDetailsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return projectDetails.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        handleTap()
        let title = projectDetails[row].presetTitle
        navigationItem.title = title
        
        guard let projectInfo = project?.projectInfos?.allObjects as? [ProjectInfo] else { return }
        
        let sameTitle = projectInfo.first(where: { (projectInfo) -> Bool in
            projectInfo.presetTitle == title
        })
        guard let projectDetails = projectDetails[row].detailTitles?.allObjects as? [ProjectDetailTitle] else { return }
        selectedDetailNames = projectDetails
        
        let sortedSelectedDetailNames = selectedDetailNames.sorted(by: { (p1, p2) -> Bool in
            return p1.index < p2.index
        })
        
        if sameTitle == nil {
            projectInfos = []
            project?.projectInfos = nil
            for (index, value) in sortedSelectedDetailNames.enumerated() {
                let projectInfoTemp = ProjectInfo(context: context)
                projectInfoTemp.detailTitle = value.detailTitle
                projectInfoTemp.infoText = ""
                projectInfoTemp.index = Int16(index)
                projectInfoTemp.presetTitle = title
                projectInfoTemp.project = self.project
                projectInfos.append(projectInfoTemp)
            }
        } else {
            let projectInfos = project?.projectInfos?.allObjects as? [ProjectInfo]
            guard let filteredProjectInfos = projectInfos?.filter({ (projectInfo) -> Bool in
                projectInfo.presetTitle == title
            }).sorted(by: { (p1, p2) -> Bool in
                return p1.index < p2.index
            }) else { return }
            
            self.projectInfos = filteredProjectInfos
        }
        
        tableView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = NSAttributedString(string: projectDetails[row].presetTitle ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.whiteBlue])
        return title
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}


extension ProjectDetailsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            tableView.deleteRows(at: [indexPath], with: .automatic)
            let item = self.projectInfos[indexPath.section]
            let detail = self.selectedDetailNames.filter({ (projectDetail) -> Bool in
                projectDetail.detailTitle == item.detailTitle
            }).first
            self.context.delete(detail ?? ProjectDetailTitle())
            self.context.delete(item)
            do {
                try self.context.save()
            } catch let err {
                print("Failed to save: ", err)
            }
            self.projectInfos.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ProjectDetailTextFieldCell
        let projectInfo = projectInfos[indexPath.section]
        cell.textField.projectInfo = projectInfo
        cell.textField.placeholder = "Enter \(projectInfo.detailTitle ?? "")"
        cell.textField.addTarget(self, action: #selector(handleProjectDetailTextField), for: .editingChanged)
        cell.textField.text = projectInfo.infoText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return projectInfos.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        headerLabels.removeAll()
        
        projectInfos.forEach { (projectInfo) in
            let lb = UILabel()
            lb.textColor = .darkBlue
            lb.backgroundColor = .lightBlue
            lb.text = "   \(projectInfo.detailTitle ?? "")"
            headerLabels.append(lb)
        }
        
        return headerLabels[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}


class ProjectDetailsTableViewController: UIViewController, UITextFieldDelegate {
    
    let context = CoreDataManager.shared.persistantContainer.viewContext
    
    var projectDetails = [ProjectDetail]()
    var selectedDetailNames = [ProjectDetailTitle]()
    var headerLabels = [UILabel]()
    var projectInfos = [ProjectInfo]()
    
    var project: Project? {
        didSet{
            
            fetchProjectDetail()
            
            guard let projectInfos = project?.projectInfos?.allObjects as? [ProjectInfo] else { return }
            
            guard let presetTitle = projectInfos.first?.presetTitle else { return }
            print(presetTitle)
            navigationItem.title = presetTitle
            
            self.projectInfos = projectInfos.filter { (projectInfo) -> Bool in
                projectInfo.presetTitle == presetTitle
                }.sorted { (p1, p2) -> Bool in
                    return p1.index < p2.index
            }
            tableView.reloadData()
        }
    }

    let tableView = UITableView()

    let pickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.backgroundColor = .normalBlue
        return pv
    }()
    
    let bottomView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        
        setupNavigation()
        setupUI()
    }
    
    fileprivate func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        if navigationItem.title == nil {
            navigationItem.title = "Touch for a preset"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-plus-30").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleHeaderAdd))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-delete-filled-60 (1)").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(headleDismiss))
    }
    
    @objc fileprivate func headleDismiss() {
        
        do {
            try context.save()
        } catch let err {
            print("Failed to save: ", err)
        }
        
        tableView.endEditing(true)
        dismiss(animated: true, completion: nil)
        
    }
    
    fileprivate func fetchProjectDetail() {
        let request: NSFetchRequest<ProjectDetail> = ProjectDetail.fetchRequest()
        do {
            projectDetails = try context.fetch(request)
        } catch let err {
            print("fetch err ", err)
        }
    }
    
    fileprivate func setupUI() {
        bottomView.isHidden = true
        view.backgroundColor = .darkBlue
        tableView.separatorStyle = .none
        tableView.backgroundColor = .lightBlue
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.register(ProjectDetailTextFieldCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(bottomView)
        bottomView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 100))
        
        bottomView.addSubview(pickerView)
        pickerView.anchor(top: bottomView.topAnchor, leading: bottomView.leadingAnchor, bottom: bottomView.bottomAnchor, trailing: bottomView.trailingAnchor)
        
        bottomView.addSubview(addButton)
        addButton.anchor(top: bottomView.topAnchor, leading: nil, bottom: nil, trailing: bottomView.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 10))
    }
    
    @objc fileprivate func handleHeaderAdd() {
        
        var tempTextField = UITextField()
        
        let alert = UIAlertController(title: "Detail title", message: "Add project detail title", preferredStyle: .alert)
        alert.addTextField { (textField) in
            tempTextField = textField }
        
        let action = UIAlertAction(title: "OK", style: .destructive) { (action) in
            
            let projectDetailTitle = ProjectDetailTitle(context: self.context)
            projectDetailTitle.detailTitle = tempTextField.text
            
            let projectDetail = self.projectDetails.first(where: {$0.presetTitle == self.navigationItem.title})
            projectDetailTitle.projectDetail = projectDetail
            
            let projectInfo = ProjectInfo(context: self.context)
            projectInfo.detailTitle = tempTextField.text
            projectInfo.infoText = ""
            projectInfo.presetTitle = projectDetail?.presetTitle
            projectInfo.project = self.project
            
            self.projectInfos.append(projectInfo)
            
            guard let index = self.projectInfos.firstIndex(of: projectInfo) else { return }
            self.projectInfos[index].index = Int16(index)
            projectDetailTitle.index = Int16(index)
            let indexSet = IndexSet(arrayLiteral: index)
            
            do {
                try self.context.save()
            } catch let err {
                print("Failed to save: ", err)
            }
            
            self.tableView.insertSections(indexSet, with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleAdd() {
        
        var tempTextField = UITextField()
        
        let alert = UIAlertController(title: "Add project detail preset title", message: "Detail preset title", preferredStyle: .alert)
        alert.addTextField { (textField) in
            tempTextField = textField }
        let action = UIAlertAction(title: "OK", style: .destructive) { (action) in
            let detail = ProjectDetail(context: self.context)
            detail.presetTitle = tempTextField.text
            
            self.projectDetails.append(detail)
            
            do {
                try self.context.save()
            } catch let err {
                print("save err:" ,err)
            }
            
            self.pickerView.reloadComponent(0)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    let addButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "icons8-plus-30").withRenderingMode(.alwaysOriginal), for: .normal)
        bt.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return bt
    }()
    
    @objc fileprivate func handleTap() {
        if bottomView.isHidden {
            bottomView.isHidden = false
            bottomView.transform = CGAffineTransform(translationX: 0, y: 300)
            bottomView.alpha = 0
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.bottomView.alpha = 1
                self.bottomView.transform = CGAffineTransform.identity
            }) { (_) in
                if self.projectDetails.count == 0 {
                    self.handleAdd()
                }
            }
        } else {
            
            UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.bottomView.alpha = 0
                self.bottomView.transform = CGAffineTransform(translationX: 0, y: 300)
            }) { (_) in
                self.bottomView.isHidden = true
            }
        }
    }
    
    @objc fileprivate func handleProjectDetailTextField(textField: ProjectDetailAndItemTextField) {
        
        let projectInfo = projectInfos.first { (projecInfo) -> Bool in
            projecInfo == textField.projectInfo
        }
        
        projectInfo?.infoText = textField.text
    }
}
