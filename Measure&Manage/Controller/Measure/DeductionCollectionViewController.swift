//
//  DeductionViewController.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 5/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit
import CoreData

protocol DeductionCollectionViewControllerDelegate {
    func didFinishProject(project: Project, fromAddItem: Bool)
    
}

class DeductionCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var isFromAddItem = false
    var isFirstCycle = true
    
    let context = CoreDataManager.shared.persistantContainer.viewContext
    
    var delegate: DeductionCollectionViewControllerDelegate?
    
    var project: Project?
    var projectItem: ProjectItem?
    
    
    let headerId = "headerId"
    let cellId = "cellId"
    
    var deductionsByProduct = [Deduction]()
    var products = [Product]()
    var parts = [Part]()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBlue

        let memoButton = custumBotton(title: nil, image: #imageLiteral(resourceName: "icons8-edit-property-filled-90"), selector: #selector(handleMemo))
        let nextButton = custumBotton(title: nil, image: #imageLiteral(resourceName: "icons8-more-than-90"), selector: #selector(handleNext))
        let finishButton = custumBotton(title: "Finish", image: nil, selector: #selector(handleFinish))
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        
        let stackView = UIStackView(arrangedSubviews: [memoButton, UIView(), finishButton, UIView(), nextButton])
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        
        return view
    }()
    
    fileprivate func custumBotton(title: String?, image: UIImage?, selector: Selector) -> UIButton {
        let bt = UIButton(type: .system)
        if title == nil {
            bt.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            bt.setTitle(title, for: .normal)
            bt.setTitleColor(.darkBlue, for: .normal)
        }
        bt.addTarget(self, action: selector, for: .touchUpInside)
        
        return bt
    }
    
    @objc fileprivate func handleFinish() {
        saveProjectAndItem()
        handleCancel()
    }
    
    let memoTextView: UITextView = {
        let memoTextView = UITextView()
        memoTextView.layer.cornerRadius = 5
        memoTextView.backgroundColor = .whiteBlue
        memoTextView.textColor = .darkBlue
        memoTextView.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        memoTextView.textContainerInset = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
        return memoTextView
    }()
    
    lazy var memoView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = .whiteBlue
        view.layer.cornerRadius = 5
        
        view.addSubview(memoTextView)
        memoTextView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 150))
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .normalBlue
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true

        let saveButton = custumBotton(title: "Save", image: nil, selector: #selector(handleMemoSaveButton))
        saveButton.setTitleColor(.normalBlue, for: .normal)
        
        let cancelButton = custumBotton(title: "Cancel", image: nil, selector: #selector(handleMemoCancel))
        cancelButton.setTitleColor(.normalBlue, for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: [UIView(), cancelButton, seperatorView, saveButton, UIView()])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15), size: CGSize(width: 0, height: 30))
        
        return view
    }()
    
    @objc fileprivate func handleMemoSaveButton() {
        projectItem?.memo = memoTextView.text
        handleMemoCancel()
    }
    
    @objc fileprivate func handleMemoCancel() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.memoView.transform = CGAffineTransform(translationX: 0, y: -200)
            self.memoView.alpha = 0
            self.visualEffect.alpha = 0
        }) { (_) in
            self.memoView.removeFromSuperview()
            self.visualEffect.removeFromSuperview()
        }
    }
    
    let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    @objc fileprivate func handleMemo() {
        view.addSubview(visualEffect)
        visualEffect.fillSuperview()
        visualEffect.alpha = 0
        
        view.addSubview(memoView)
        memoView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 30, bottom: 0, right: 30), size: .init(width: 0, height: 200))
        
        memoView.transform = CGAffineTransform(translationX: 0, y: -200)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.memoView.alpha = 1
            self.memoView.transform = CGAffineTransform.identity
            self.visualEffect.alpha = 1
        }) { (_) in
            
        }
    }
    
    
        
    fileprivate func saveProjectAndItem() {
            
        parts.forEach { (part) in
            let deductedValueForItem = DeductedValueForItem(context: context)
            deductedValueForItem.partName = part.partName
            deductedValueForItem.projectItem = self.projectItem
            
            guard let deductions = part.deductions?.allObjects as? [Deduction] else { return }
            
            guard let deductionDetails = deductions.first?.deductionDetails?.allObjects as? [DeductionDetail] else { return }
            
            
            
            deductionDetails.forEach({ (deductionDetail) in
                
                if deductionDetail.viewStyle == 0 {
        
                    let height = deductionDetail.deductionDetailValue
                    let array = height?.split(separator: " ")
                    var first = 0
                    var third = 0
        
                    switch array?.first {
                        case "OriginalHeight": first = Int(projectItem?.height ?? "") ?? 0
                        case "OriginalWidth": first = Int(projectItem?.width ?? "") ?? 0
                        default: first = Int(array?.first ?? "") ?? 0
                    }
        
                    switch array?[2] {
                    case "OriginalHeight": third = Int(projectItem?.height ?? "") ?? 0
                    case "OriginalWidth": third = Int(projectItem?.width ?? "") ?? 0
                    default: third = Int(array?[2] ?? "") ?? 0
                    }
        
                    print(first)
                    print(third)
        
                    switch array?[1] {
                    case "+": if deductionDetail.deductionDetailTitle == "Width" {
                        deductedValueForItem.width = Int16(first + third)
                    } else {
                        deductedValueForItem.height = Int16(first + third)
                        }
                    case "-": if deductionDetail.deductionDetailTitle == "Width" {
                        deductedValueForItem.width = Int16(first - third)
                    } else {
                        deductedValueForItem.height = Int16(first - third)
                        }
                    case "/": if deductionDetail.deductionDetailTitle == "Width" {
                        deductedValueForItem.width = Int16(first / third)
                    } else {
                        deductedValueForItem.height = Int16(first / third)
                        }
                    default: if deductionDetail.deductionDetailTitle == "Width" {
                        deductedValueForItem.width = Int16(first * third)
                    } else {
                        deductedValueForItem.height = Int16(first * third)
                        }
                    }
               
                } else if deductionDetail.viewStyle == 1 {
                    var array = deductionDetail.deductionDetailValue?.split(separator: " ")
                    array?.remove(at: 0)
                    array?.remove(at: 0)
                    
                    var firstValue: Int?
                    var originalWidthOrHeight: Int?
                    var lastValue: Int?
//                    var isOriginalWidth: Bool?
                    var combinedSign: String?
                    
                    if array?.count == 5 {
                        
                        firstValue = Int(array?[0] ?? "")
                        lastValue = Int(array?[4] ?? "")
                        
                        if array?[2] == "OriginalWidth" {
                            originalWidthOrHeight = Int(projectItem?.width ?? "") ?? 0
//                            isOriginalWidth = true
                        } else {
                            originalWidthOrHeight = Int(projectItem?.height ?? "") ?? 0
//                            isOriginalWidth = false
                        }
                        guard let firstSign = array?[1] else { return }
                        guard let secondSign = array?[3] else { return }
                        combinedSign = "\(firstSign)\(secondSign)"
                        
                        switch combinedSign {
                        case "<<":
                            if originalWidthOrHeight ?? 0 > firstValue ?? 0 && originalWidthOrHeight ?? 0 < lastValue ?? 0 {
                                if deductionDetail.deductionDetailTitle == "Width" {
                                    deductedValueForItem.width = deductionDetail.desiredValue
                                } else {
                                    deductedValueForItem.height = Int16(deductionDetail.desiredValue)
                                }
                            }
                            
                        case "<<=":
                            if originalWidthOrHeight ?? 0 > firstValue ?? 0 && originalWidthOrHeight ?? 0 <= lastValue ?? 0 {
                                if deductionDetail.deductionDetailTitle == "Width" {
                                    deductedValueForItem.width = deductionDetail.desiredValue
                                } else {
                                    deductedValueForItem.height = Int16(deductionDetail.desiredValue)
                                }
                            }
                        case ">>":
                            if originalWidthOrHeight ?? 0 < firstValue ?? 0 && originalWidthOrHeight ?? 0 > lastValue ?? 0 {
                                if deductionDetail.deductionDetailTitle == "Width" {
                                    deductedValueForItem.width = deductionDetail.desiredValue
                                } else {
                                    deductedValueForItem.height = Int16(deductionDetail.desiredValue)
                                }
                            }
                        case ">>=":
                            if originalWidthOrHeight ?? 0 < firstValue ?? 0 && originalWidthOrHeight ?? 0 >= lastValue ?? 0 {
                                if deductionDetail.deductionDetailTitle == "Width" {
                                    deductedValueForItem.width = deductionDetail.desiredValue
                                } else {
                                    deductedValueForItem.height = Int16(deductionDetail.desiredValue)
                                }
                            }
                        default: print("nothing matched")
                        }
                        
                    } else {
                        firstValue = Int(array?[0] ?? "")
                        if array?[0] == "OriginalWidth" {
                            originalWidthOrHeight = Int(projectItem?.width ?? "")
                        } else {
                            originalWidthOrHeight = Int(projectItem?.height ?? "")
                        }
                    }
                } else {
                    if deductionDetail.deductionDetailTitle == "Width" {
                        deductedValueForItem.width = Int16(deductionDetail.deductionDetailValue ?? "") ?? 0
                    } else {
                        deductedValueForItem.height = Int16(deductionDetail.deductionDetailValue ?? "") ?? 0
                    }
                }
            })
                print(deductedValueForItem.height)
        }
        
        
        
        let locationViewController = navigationController?.viewControllers[0] as! LocationNameCollectionViewController
        
        if locationViewController.isFirstCycle {
            if let project = project {
                project.creationDate = Date()
                if isFromAddItem {
                    delegate?.didFinishProject(project: project, fromAddItem: true)
                } else {
                    delegate?.didFinishProject(project: project, fromAddItem: false)
                }
                
                locationViewController.isFirstCycle = false
            }
        }
        
        self.projectItem?.project = self.project
        projectItem?.itemNumber = Int16(project?.projectItems?.count ?? 0 + 1)
        
        do {
            try context.save()
        } catch let err {
            print("failed to save: ", err)
        }
    }
    
    @objc fileprivate func handleNext() {
        saveProjectAndItem()
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetch()
        navigationItem.title = projectItem?.location
        
        setupCollectionView()
        setupAllDeductions()
        
        view.addSubview(bottomView)
        bottomView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
        
        visualEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMemoCancel)))
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .whiteBlue
        collectionView.alwaysBounceVertical = true
        collectionView.register(LocationHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(LocationNameCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-delete-filled-60 (1)").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(handleCancel))
    }
    
    @objc fileprivate func handleCancel() {
        if isFromAddItem == false && isFirstCycle {
            if let project = project {
                context.delete(project)
            }
        }
        dismiss(animated: true)
    }
    
    fileprivate func setupAllDeductions() {
        deductionsByProduct.removeAll()
        
        guard let parts = products.first?.parts?.allObjects as? [Part] else { return }
        self.parts = parts
        self.parts.forEach({ (part) in
            guard let deduction = part.deductions?.allObjects as? [Deduction] else { return }
            deductionsByProduct += deduction
        })
        
        self.collectionView.reloadData()
        
        print(deductionsByProduct)
        
        let indexPaths = (0..<deductionsByProduct.count).map {IndexPath(item: $0, section: 1)
        }
        collectionView.reloadItems(at: indexPaths)
    }
    
    fileprivate func fetch() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            products = try context.fetch(request)
        } catch let err {
            print("failed to fetch: ", err)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! LocationHeaderView
        header.minusButton.removeFromSuperview()
        header.plusButton.removeFromSuperview()
        
        if indexPath.section == 0 {
            header.locationTitleLabel.text = "Product"
        } else {
            header.locationTitleLabel.text = "Deduction"
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LocationNameCell
        if indexPath.section == 0 {
            cell.locationNameLable.text = products[indexPath.item].productName
        } else {
            cell.locationNameLable.text = deductionsByProduct[indexPath.item].deductionName
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return products.count
        } else {
            return deductionsByProduct.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width = view.frame.width / 2 - 1
            return CGSize(width: width, height: width)
        } else {
            let width = view.frame.width / 3 - 1
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let toIndexPath = IndexPath(item: 0, section: indexPath.section)
        collectionView.moveItem(at: indexPath, to: toIndexPath)
        
        if indexPath.section == 0 {
            let selectedProducts = products[indexPath.item]
            
            projectItem?.productName = selectedProducts.productName
            products.insert(selectedProducts, at: 0)
            products.remove(at: indexPath.item + 1)
            setupAllDeductions()
            
        } else {
            let selectedDeduction = deductionsByProduct[indexPath.item]
            selectedDeduction.projectItem = projectItem
            deductionsByProduct.insert(selectedDeduction, at: 0)
            deductionsByProduct.remove(at: indexPath.item + 1)
        }
    }
}
