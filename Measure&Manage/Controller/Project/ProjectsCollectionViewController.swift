//
//  ResultTableViewCotroller.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 9/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit
import CoreData



class ProjectsCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let context = CoreDataManager.shared.persistantContainer.viewContext
    let cellId = "cellId"
    let headerId = "headerId"
    
    var isFromAddItem = false
    var isFiltered = false
    
    var project: Project? {
        didSet{
            if isFromAddItem {
                if let project = project {
                    guard let index = projects.firstIndex(of: project) else { return }
                    projects.insert(project, at: 0)
                    projects.remove(at: index + 1)
                }
            } else {
                if let project = project {
                    projects.insert(project, at: 0)
                }
            }
            
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            filteredProjects = projects
            collectionView.reloadData()
        }
    }
    
    var projects = [Project]()
    var filteredProjects = [Project]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionAndNavigation()
        fetchProjects()
    }
    
    fileprivate func setupCollectionAndNavigation() {
        collectionView.backgroundColor = .whiteBlue
        navigationItem.title = "Projects"
        collectionView.register(ProjectsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(SearchCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    fileprivate func fetchProjects() {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        do {
            projects = try context.fetch(request)
        } catch let err {
            print("failed to fetch: ", err)
        }
        
        self.projects = projects.sorted { (p1, p2) -> Bool in
            Int(p1.creationDate?.timeIntervalSince1970 ?? 0) > Int(p2.creationDate?.timeIntervalSince1970 ?? 0)
        }
        filteredProjects = projects
    }
    
    @objc fileprivate func handleImage(button: CustomUIButton) {
        let project = button.project
        let imageCollectionViewController = ImageCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        imageCollectionViewController.project = project
        let navController = UINavigationController(rootViewController: imageCollectionViewController)
            present(navController, animated: true, completion: nil)
    }
    
    @objc fileprivate func hadnleDetail(button: CustomUIButton) {
        let project = button.project
        let projectDetailsTableViewController = ProjectDetailsTableViewController()
        projectDetailsTableViewController.project = project
        let navController = UINavigationController(rootViewController: projectDetailsTableViewController)
        present(navController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleDelete(button: CustomUIButton) {
        
        let alert = UIAlertController(title: "Delete", message: "This project will be deleted.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .destructive) { (action) in
            guard let project = button.project, let indexFromProjects = self.projects.firstIndex(of: project), let indexFromFilteredProjects = self.filteredProjects.firstIndex(of: project) else { return }
            
            self.context.delete(project)
            
            if self.isFiltered {
                self.filteredProjects.remove(at: indexFromFilteredProjects)
                self.projects.remove(at: indexFromProjects)
                let indexPath = IndexPath(item: indexFromFilteredProjects, section: 0)
                self.collectionView.deleteItems(at: [indexPath])
            } else {
                self.projects.remove(at: indexFromProjects)
                self.filteredProjects = self.projects
                let indexPath = IndexPath(item: indexFromProjects, section: 0)
                self.collectionView.deleteItems(at: [indexPath])
            }
            
            do {
                try self.context.save()
            } catch let err {
                print("failed to save: ", err)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredProjects.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProjectsCell
        cell.project = filteredProjects[indexPath.row]
        cell.deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        cell.detailButton.addTarget(self, action: #selector(hadnleDetail), for: .touchUpInside)
        cell.imageButton.addTarget(self, action: #selector(handleImage), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 310)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let projectItemsCollectionViewController = ProjectItemsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        projectItemsCollectionViewController.project = filteredProjects[indexPath.row]
        navigationController?.pushViewController(projectItemsCollectionViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SearchCollectionViewHeader
        header.searchBar.delegate = self
        header.searchBar.placeholder = "Enter project name or number"
        return header
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}


extension ProjectsCollectionView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            filteredProjects = projects
            isFiltered = false
            searchBar.resignFirstResponder()
            collectionView.reloadData()
        } else {
            isFiltered = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filteredProjects = projects.filter({ (project) -> Bool in
            if let projectName = project.projectName, let projectNumber = project.projectNumber, let text = searchBar.text {
                return projectName.lowercased().contains(text.lowercased()) || projectNumber.lowercased().contains(text.lowercased())
            }
            return false
        })
        collectionView?.reloadData()
    }
}
