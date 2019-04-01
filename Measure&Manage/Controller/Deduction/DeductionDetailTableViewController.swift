//
//  DeductionDetailTableView.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 16/2/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit

class DeductionDetailTableViewController: UITableViewController, DeductionDetailAddViewControllerDelegate {
    
//    var deductionDetails = [[DeductionDetail]]()
    var widthDetails = [DeductionDetail]()
    var heightDetails = [DeductionDetail]()
    
    let cellId = "CellId"
    
    func didSaveDeductionDetail(deductionDetail: DeductionDetail) {
        
        if deductionDetail.deductionDetailTitle == "Width" {
            widthDetails.append(deductionDetail)
        } else {
            heightDetails.append(deductionDetail)
        }
        
        tableView.reloadData()
    }
    
    
    var deduction: Deduction? {
        didSet{
            navigationItem.title = deduction?.deductionName
            let deductionDetails = deduction?.deductionDetails?.allObjects as? [DeductionDetail]
            guard let widthDetails = deductionDetails?.filter({ (detail) -> Bool in
                detail.deductionDetailTitle == "Width" }) else { return }
            guard let heightDetails = deductionDetails?.filter({ (detail) -> Bool in
                detail.deductionDetailTitle == "Height" }) else { return }
            self.widthDetails = widthDetails
            self.heightDetails = heightDetails
        }
    }
    
    let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["+,-,..", ">,<=,..", "2,3,.."])
        sc.tintColor = .white
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(segmentControl)
        tableView.separatorStyle = .none
//        segmentControl.anchor(top: nil, leading: navBar.leadingAnchor, bottom: navBar.bottomAnchor, trailing: navBar.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 5, right: 20), size: .init(width: 0, height: 50))
        tableView.backgroundColor = .whiteBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-delete-filled-60 (1)").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(hadleDismiss))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc fileprivate func hadleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = LocationHeaderView()
        header.minusButton.isHidden = true
        header.plusButton.addTarget(self, action: #selector(handlePlus), for: .touchUpInside)
        
        if section == 0 {
            let headerSegment = UIView()
            headerSegment.backgroundColor = .darkBlue
            headerSegment.addSubview(segmentControl)
            segmentControl.anchor(top: headerSegment.topAnchor, leading: headerSegment.leadingAnchor, bottom: headerSegment.bottomAnchor, trailing: headerSegment.trailingAnchor, padding: .init(top: 5, left: 30, bottom: 15, right: 30))
            return headerSegment
        } else if section == 1 {
            header.locationTitleLabel.text = "Width"
            header.plusButton.sender = "Width"
            return header
        } else {
            header.locationTitleLabel.text = "Height"
            header.plusButton.sender = "Height"
            return header
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .whiteBlue
        if indexPath.section == 1 {
            cell.textLabel?.text = widthDetails[indexPath.row].deductionDetailValue
        } else if indexPath.section == 2 {
            cell.textLabel?.text = heightDetails[indexPath.row].deductionDetailValue
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return widthDetails.count
        } else {
            return heightDetails.count
        }
    }
    
    @objc fileprivate func handlePlus(button: CustomUIButton) {
        let deductionDetailAddViewController = DeductionDetailsAddViewController()
        deductionDetailAddViewController.deduction = self.deduction
        deductionDetailAddViewController.delegate = self
        deductionDetailAddViewController.viewStyle = segmentControl.selectedSegmentIndex
        deductionDetailAddViewController.navBartitle = button.sender
        navigationController?.pushViewController(deductionDetailAddViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60
        } else {
            return 50
        }
    }
}
