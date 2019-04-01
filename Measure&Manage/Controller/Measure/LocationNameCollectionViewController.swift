//
//  LocationName.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 7/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit
import CoreData

class LocationNameCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var isFromAddItem = false
    
    let context = CoreDataManager.shared.persistantContainer.viewContext
    var project: Project?
    lazy var locationNames = [Location]()
    var sortedNames = [[Location]]()
    
    var delegate: DeductionCollectionViewControllerDelegate?
    
    var isFirstCycle = true
    var isMinus = false
    var combinedLocationNameString = ""

    let headerId = "headerId"
    let cellId = "cellId"
    let locationNumberheaderId = "locationNumberheaderId"
    
    let headerNames = [LocationTitles.block.rawValue,
                       LocationTitles.layer.rawValue,
                       "",
                       LocationTitles.detail1.rawValue,
                       LocationTitles.detail2.rawValue]
    
    let numberDisplayLable: UILabel = {
        let numberDisplayLable = UILabel()
        numberDisplayLable.isUserInteractionEnabled = true
        numberDisplayLable.textAlignment = .center
        numberDisplayLable.textColor = .darkBlue
        numberDisplayLable.font = UIFont.boldSystemFont(ofSize: 24)
        numberDisplayLable.backgroundColor = .lightBlue
        
        let clearButton = UIButton(type: .system)
            clearButton.setImage(#imageLiteral(resourceName: "icons8-clear-symbol-90").withRenderingMode(.alwaysOriginal), for: .normal)
            clearButton.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
        numberDisplayLable.addSubview(clearButton)
        clearButton.anchor(top: numberDisplayLable.topAnchor, leading: numberDisplayLable.leadingAnchor, bottom: numberDisplayLable.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0), size: CGSize(width: 30, height: 30))
        
        let nextButton = UIButton(type: .system)
            nextButton.setImage(#imageLiteral(resourceName: "icons8-more-than-90").withRenderingMode(.alwaysOriginal), for: .normal)
            nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        numberDisplayLable.addSubview(nextButton)
        nextButton.anchor(top: numberDisplayLable.topAnchor, leading: nil, bottom: numberDisplayLable.bottomAnchor, trailing: numberDisplayLable.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15), size: CGSize(width: 30, height: 30))
        
        return numberDisplayLable
    }()
    
    let unitNumberTextField: CustumTextFieldInset = {
        let tf = CustumTextFieldInset()
        tf.placeholder = "Touch for Unit Number"
        tf.keyboardType = .numberPad
        tf.backgroundColor = .whiteBlue
        tf.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        return tf
    }()
    
    @objc fileprivate func handleNext() {
        let widthHeightViewController = WidthHeightViewController()
        widthHeightViewController.delegate = delegate
        if isFromAddItem {
            widthHeightViewController.isFromAddItem = true
        }
        widthHeightViewController.isFirstCycle = isFirstCycle
        let projectItem = ProjectItem(context: context)
        projectItem.location = combinedLocationNameString
        widthHeightViewController.projectItem = projectItem
        widthHeightViewController.project = self.project
        navigationController?.pushViewController(widthHeightViewController, animated: true)
        handleClear()
        for item in 0..<sortedNames.count {
            let item = sortedNames[item]
            for more in 0..<item.count {
                let index = more
                item[more].index = Int32(index)
            }
        }
    }
    
    @objc fileprivate func handleClear() {
        numberDisplayLable.text = ""
        combinedLocationNameString = ""
        lastLayerString = ""
        scrollToNextSection(section: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchLocation()
        setupCollectionView()
        setupSortedNames()
        setupNavigaionItem()

        view.addSubview(numberDisplayLable)
        numberDisplayLable.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
    }
    
    fileprivate func setupNavigaionItem() {
        navigationItem.title = "Location Name"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-delete-filled-60 (1)").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(handdleCancel))
    }
    
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .whiteBlue
        collectionView.register(LocationHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView.register(LocationNameCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.register(LocationUnitNumberHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: locationNumberheaderId)
        
        collectionView.alwaysBounceVertical = true
    }
    
    fileprivate func setupSortedNames() {
        let layer = self.locationNames.filter{$0.locationTitle == LocationTitles.layer.rawValue}
        let namesInLayer = layer.sorted { (p1, p2) -> Bool in
            return p1.index < p2.index
        }
        
        let detail1 = self.locationNames.filter{$0.locationTitle == LocationTitles.detail1.rawValue}
        let namesInDetail1 = detail1.sorted { (p1, p2) -> Bool in
            return p1.index < p2.index
        }
        let detail2 = self.locationNames.filter{$0.locationTitle == LocationTitles.detail2.rawValue}
        let namesInDetail2 = detail2.sorted { (p1, p2) -> Bool in
            return p1.index < p2.index
        }
        let block = self.locationNames.filter{$0.locationTitle == LocationTitles.block.rawValue}
        let namesInBlock = block.sorted { (p1, p2) -> Bool in
            return p1.index < p2.index
        }
        let empty = [Location]()
        
        self.sortedNames = [
            namesInBlock,
            namesInLayer,
            empty,
            namesInDetail1,
            namesInDetail2
        ]
    }
    
    fileprivate func fetchLocation() {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        do {
            locationNames = try context.fetch(request)
        } catch let err {
            print("failed to fetch: ", err)
        }
    }
    
    @objc fileprivate func handdleCancel() {
        if isFromAddItem == false && isFirstCycle {
            if let project = project {
                context.delete(project)
            }
        }
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 2 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: locationNumberheaderId, for: indexPath) as! LocationUnitNumberHeaderView
            
            header.submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
            header.addSubview(unitNumberTextField)
            unitNumberTextField.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: header.frame.width / 2, height: 0))
            
            return header
            
        } else {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! LocationHeaderView
            
            header.locationTitleLabel.text = headerNames[indexPath.section]
            header.plusButton.sender = header.locationTitleLabel.text
            
            header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeMinus)))
            
            header.plusButton.addTarget(self, action: #selector(handlePlus), for: .touchUpInside)
            header.minusButton.addTarget(self, action: #selector(handleMinus), for: .touchUpInside)
            
            return header
        }
    }
    
    @objc fileprivate func removeMinus() {
        if isMinus {
            isMinus = false
            collectionView.reloadData()
        }
    }
    
    fileprivate func locationNameAlert(title: String) {
        var textFieldtext = UITextField()
        let alert = UIAlertController(title: "What's the name?", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textFieldtext = textField
        }
        let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let location = Location(context: self.context)
            location.locationTitle = title
            if let locationName = textFieldtext.text {
                location.locationName = locationName
            }
            
            guard let section = self.headerNames.firstIndex(of: title) else { return }
            let row = self.sortedNames[section].count
            location.index = Int32(row)
            let indexPath = IndexPath(row: row, section: section)
            self.sortedNames[section].append(location)
            self.collectionView.insertItems(at: [indexPath])
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        self.collectionView.reloadData()
        present(alert, animated: true, completion: nil)
    }
    
    @objc fileprivate func handlePlus(button: CustomUIButton) {
        
        if isMinus {
            isMinus = false
        }
        
        switch button.sender {
        case headerNames[0]:
            locationNameAlert(title: LocationTitles.block.rawValue)
        case headerNames[1]:
            locationNameAlert(title: LocationTitles.layer.rawValue)
        case headerNames[3]:
            locationNameAlert(title: LocationTitles.detail1.rawValue)
        default:
            locationNameAlert(title: LocationTitles.detail2.rawValue)
        }
    }
    
    @objc fileprivate func handleMinus() {
        isMinus = !isMinus
        collectionView.reloadData()
    }

    fileprivate func scrollToNextSection(section: Int = 2) {
        if let attributes = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section)) {
            var offsetY = attributes.frame.origin.y - collectionView.contentInset.top
            if #available(iOS 11.0, *) {
                offsetY -= collectionView.safeAreaInsets.top
            }
            collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true) // or animated: false
        }
    }
    
    @objc fileprivate func handleSubmit() {
        view.endEditing(true)

        combinedLocationNameString = combinedLocationNameString == "" ? unitNumberTextField.text ?? "" : "\(combinedLocationNameString) \(unitNumberTextField.text ?? "")"

        numberDisplayLable.text = combinedLocationNameString
        scrollToNextSection()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LocationNameCell
        
        cell.locationNameLable.text = sortedNames[indexPath.section][indexPath.item].locationName
        
        if isMinus {
            UIView.animate(withDuration: 0.5) {
                cell.imageView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                cell.imageView.alpha = 0
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedNames[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    var lastLayerString = ""
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isMinus {
            context.delete(sortedNames[indexPath.section][indexPath.item])
            sortedNames[indexPath.section].remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        } else {
            let toSection = min(sortedNames.count - 1, indexPath.section + 1)
            scrollToNextSection(section: toSection)
            let toIndexPath = IndexPath(item: 0, section: indexPath.section)
            collectionView.moveItem(at: indexPath, to: toIndexPath)
            
            guard let locationNameString = sortedNames[indexPath.section][indexPath.item].locationName else { return }
            
            if indexPath.section == 3 && combinedLocationNameString == lastLayerString && unitNumberTextField.text?.isEmpty == false {
                view.endEditing(true)
                combinedLocationNameString = "\(combinedLocationNameString) \(unitNumberTextField.text ?? "") \(locationNameString)"
            } else {
                combinedLocationNameString = combinedLocationNameString == "" ? locationNameString : "\(combinedLocationNameString) \(locationNameString)"
            }
            lastLayerString = lastLayerString == "" ? locationNameString : lastLayerString + " \(locationNameString)"
            
            let selectedItem = sortedNames[indexPath.section][indexPath.item]
            sortedNames[indexPath.section].insert(selectedItem, at: 0)
            sortedNames[indexPath.section].remove(at: indexPath.item + 1)
            
            numberDisplayLable.text = combinedLocationNameString
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
    }
}
