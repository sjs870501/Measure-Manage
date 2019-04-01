//
//  ResultDetailTableViewController.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 11/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit
// items and stackView dictionary
class ProjectItemsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var project: Project? {
        didSet{
            guard let details = project?.projectItems?.allObjects as? [ProjectItem] else { return }
            projectItems = details.sorted(by: { (p1, p2) -> Bool in
                p1.itemNumber < p2.itemNumber
            })
            fillteredProjectItems = projectItems
            setupStackView()
        }
    }
    
    var isSelectMode: Bool = false {
        didSet {
            collectionView.allowsMultipleSelection = isSelectMode
        }
    }
    
    let context = CoreDataManager.shared.persistantContainer.viewContext
    let cellId = "cellId"
    let headerId = "headerId"
    
    var projectItems = [ProjectItem]()
    var fillteredProjectItems = [ProjectItem]()
    var stackViews = [StackView]()
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    func setupStackView() {
        stackViews.removeAll()
        (0..<projectItems.count).forEach { (_) in
            let tempStackView = StackView()
            stackViews.append(tempStackView)
        }
    }
    
    let addItemButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("+", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bt.layer.cornerRadius = 25
        bt.backgroundColor = .darkBlue
        bt.addTarget(self, action: #selector(handleAddItem), for: .touchUpInside)
        bt.alpha = 0.85
        
        return bt
    }()
    
    @objc fileprivate func handleAddItem() {
        let locationCollectionViewController = LocationNameCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
            locationCollectionViewController.project = self.project
            locationCollectionViewController.isFromAddItem = true
        let navController = UINavigationController(rootViewController: locationCollectionViewController)
        present(navController, animated: true) {
            self.navigationController?.popToRootViewController(animated: true)
            let rootViewController = self.navigationController?.viewControllers[0] as? ProjectsCollectionView
            //???
            rootViewController?.collectionView.reloadData()
        }
    }
    
    let bottomView: UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .normalBlue
        
        let selectButton = UIButton(type: .system)
        selectButton.setTitle("Select Item", for: .normal)
        selectButton.setTitleColor(.whiteBlue, for: .normal)
        selectButton.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
        v.addSubview(selectButton)
        selectButton.anchor(top: v.topAnchor, leading: v.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0))
        
        let shareButton = UIButton(type: .system)
        shareButton.setTitle("Share" , for: .normal)
        shareButton.setTitleColor(.whiteBlue, for: .normal)
        shareButton.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        v.addSubview(shareButton)
        shareButton.anchor(top: selectButton.bottomAnchor, leading: selectButton.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(#imageLiteral(resourceName: "icons8-delete-filled-60 (1)").withRenderingMode(.alwaysOriginal), for: .normal)
        deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        v.addSubview(deleteButton)
        deleteButton.anchor(top: selectButton.topAnchor, leading: nil, bottom: nil, trailing: v.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
        
        return v
    }()
    
    @objc fileprivate func handleTapBottomView() {
        dismissButtomView()
    }
    
    @objc fileprivate func handleDelete() {
        guard let selectedItems = collectionView.indexPathsForSelectedItems else { return }
        var selectedProjectItems = [ProjectItem]()
        var selectedStackViewItems = [StackView]()
        
        selectedItems.forEach { (indexPath) in
            selectedProjectItems.append(projectItems[indexPath.row])
            selectedStackViewItems.append(stackViews[indexPath.row])
        }
        
        selectedProjectItems.forEach { (projectItem) in
            guard let index = projectItems.firstIndex(of: projectItem) else { return }
            projectItems.remove(at: index)
            context.delete(projectItem)
        }
        
        selectedStackViewItems.forEach { (selectedStackView) in
            if let index = stackViews.firstIndex(where: {$0.stackView == selectedStackView.stackView}) {
                stackViews.remove(at: index)
            }
        }
        
        fillteredProjectItems = projectItems
        collectionView.deleteItems(at: selectedItems)
        
        do {
            try context.save()
        } catch let err {
            print("failed to save :", err)
        }
    }
    
    @objc fileprivate func handleSelect() {
        isSelectMode = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizer()
        setupCollectionAndNavigation()
        setupUI()
    }
    
    fileprivate func setupGestureRecognizer() {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
        bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapBottomView)))
    }
    
    fileprivate func setupCollectionAndNavigation() {
        collectionView.backgroundColor = .whiteGray
        collectionView.register(ProjectItemsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(SearchCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        navigationItem.title = "\(project?.projectName ?? "")"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-menu-filled-90").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenu))
    }
    
    fileprivate func setupUI() {
        view.addSubview(addItemButton)
        addItemButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 50, height: 50))
        addItemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(bottomView)
        bottomView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 100))
    }
    
    @objc fileprivate func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { break }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    fileprivate func dismissButtomView() {
        
        self.isSelectMode = false
        
        guard let indexPathsForSelectedItems = self.collectionView.indexPathsForSelectedItems else { return }
        indexPathsForSelectedItems.forEach { (indexPath) in
            let cell = collectionView.cellForItem(at: indexPath) as? ProjectItemsCell
            cell?.stackView = nil
            cell?.backgroundColor = .whiteBlue
        }
        self.collectionView.reloadItems(at: indexPathsForSelectedItems)
        
        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.bottomView.alpha = 0
            self.bottomView.transform = CGAffineTransform(translationX: 0, y: 300)
        }) { (_) in
            self.bottomView.isHidden = true
        }
    }
    
    @objc fileprivate func handleMenu() {
        if bottomView.isHidden {
            bottomView.isHidden = false
            bottomView.transform = CGAffineTransform(translationX: 0, y: 300)
            bottomView.alpha = 0
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.bottomView.alpha = 1
                self.bottomView.transform = CGAffineTransform.identity
            })
        } else {
            dismissButtomView()
        }
    }
    
    @objc fileprivate func handleShare() {
        
        let fileName = "\(project?.projectNumber ?? "") - \(project?.projectName ?? "").csv"
        guard let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName) else { return }
        var csvText = "Location, width, Height, deduction, note\n"
        if projectItems.count > 0 {
            for projectItem in fillteredProjectItems {
                let newLine = "\(projectItem.location ?? ""), \(projectItem.width ?? ""), \(projectItem.height ?? ""), \(projectItem.deductions?.deductionName ?? ""), \(projectItem.memo ?? "")\n"
                csvText.append(contentsOf: newLine)
                
            }
            
            do {
                try csvText.write(to: path, atomically: true, encoding: String.Encoding.utf8)
                
                let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
                vc.excludedActivityTypes = [
                    UIActivity.ActivityType.assignToContact,
                    UIActivity.ActivityType.saveToCameraRoll,
                    UIActivity.ActivityType.postToFlickr,
                    UIActivity.ActivityType.postToVimeo,
                    UIActivity.ActivityType.postToTencentWeibo,
                    UIActivity.ActivityType.postToTwitter,
                    UIActivity.ActivityType.postToFacebook,
                    UIActivity.ActivityType.openInIBooks
                ]
                present(vc, animated: true, completion: nil)
                
            } catch {
                print("Failed to create file")
                print("\(error)")
            }
            
        } else {
//            showErrorAlert("Error", msg: "There is no data to export")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fillteredProjectItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 10, height: 150)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProjectItemsCell
        
        if isIndexChanged {
            cell.stackView = nil
        }
        
        cell.stackView = stackViews[indexPath.item]
        
        let projectDetail = fillteredProjectItems[indexPath.row]
        cell.projectDetail = projectDetail
        
        cell.numberLabel.text = "No.\(indexPath.row + 1)"
        
        if stackViews[indexPath.item].isAdded == false {
            stackViews[indexPath.item].stackView = cell.stackView?.stackView
            stackViews[indexPath.item].isAdded = true
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isSelectMode {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = .lightGray
        } else {
            let projectItemDetailViewController = ProjectItemDetailViewController()
            projectItemDetailViewController.projectItem = fillteredProjectItems[indexPath.item]
            navigationController?.pushViewController(projectItemDetailViewController, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isSelectMode {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = .whiteBlue
        }
    }

    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    var isIndexChanged = false
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceIndex = sourceIndexPath.item
        let destinationIndex = destinationIndexPath.item
        let item = projectItems.remove(at: sourceIndex)
        projectItems.insert(item, at: destinationIndex)
        let stackViewItem = stackViews.remove(at: sourceIndex)
        stackViews.insert(stackViewItem, at: destinationIndex)
        isIndexChanged = true
        
        var indexPaths = [IndexPath]()
        
        for (index, value) in projectItems.enumerated() {
            let indexPath = IndexPath(item: index, section: 0)
            value.itemNumber = Int16(index)
            indexPaths.append(indexPath)
        }
        
        do {
            try context.save()
        } catch let err {
            print("failed to save: ", err)
        }
        
        fillteredProjectItems = projectItems
        collectionView.reloadItems(at: indexPaths)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SearchCollectionViewHeader
        header.searchBar.delegate = self
        return header
    }
}



extension ProjectItemsCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            fillteredProjectItems = projectItems
            searchBar.resignFirstResponder()
            collectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("cliced")
        fillteredProjectItems = projectItems.filter({ (projectItem) -> Bool in
            if let locationName = projectItem.location, let text = searchBar.text {
                return locationName.lowercased().contains(text.lowercased())
            }
            return false
        })
        collectionView?.reloadData()
    }
}
