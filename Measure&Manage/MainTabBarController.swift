//
//  ViewController.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 4/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate, DeductionCollectionViewControllerDelegate {
    
    func didFinishProject(project: Project, fromAddItem: Bool) {
        if fromAddItem {
            projectCollectionViewController.isFromAddItem = true
            projectCollectionViewController.project = project
        } else {
            projectCollectionViewController.project = project
        }
        
        
    }
    
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//
//        let index = viewControllers?.index(of: viewController)
//
//        if index == 2 {
//            let measureViewController = MeasureViewController()
//            measureViewController.delegate = self
//            let navController = UINavigationController(rootViewController: measureViewController)
//
//
//            present(navController, animated: true, completion: nil)
//            return false
//        }
//
//        return true
//    }
    
    let projectCollectionViewController = ProjectsCollectionView(collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteBlue
        delegate = self
        
        let measureController = MeasureViewController()
        measureController.delegate = self
        let measureNavController = UINavigationController(rootViewController: measureController)
        measureNavController.tabBarItem.title = "Measure"
        measureNavController.tabBarItem.image = #imageLiteral(resourceName: "icons8-sewing-tape-measure-filled-90 (1)").withRenderingMode(.alwaysOriginal)
        measureNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "icons8-sewing-tape-measure-filled-90").withRenderingMode(.alwaysOriginal)
        
        let deductionTableViewController = DeductionProductTableViewController()
        let navController = UINavigationController(rootViewController: deductionTableViewController)
        navController.tabBarItem.title = "Deduction"
        navController.tabBarItem.image = #imageLiteral(resourceName: "icons8-math-filled-90 (1)").withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "icons8-math-filled-90").withRenderingMode(.alwaysOriginal)
        
        
        let resultNavController = UINavigationController(rootViewController: projectCollectionViewController)
        
        
        resultNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "icons8-brief-filled-90").withRenderingMode(.alwaysOriginal)
        resultNavController.tabBarItem.image = #imageLiteral(resourceName: "icons8-brief-filled-90 (2)").withRenderingMode(.alwaysOriginal)
        resultNavController.tabBarItem.title = "Projects"
        
        viewControllers = [
            resultNavController,
            UIViewController(),
            measureNavController,
            UIViewController(),
            navController
        ]
        
        tabBar.items?.forEach({ (tabbarItem) in
        tabbarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.darkBlue], for: .selected)
        })
    }
}

