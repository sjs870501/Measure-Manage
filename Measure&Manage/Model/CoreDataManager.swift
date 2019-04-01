//
//  CoreDataManager.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 11/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let persistantContainer: NSPersistentContainer = {
        let ps = NSPersistentContainer(name: "Measure&Manage")
        ps.loadPersistentStores(completionHandler: { (storeDescription, err) in
            if let err = err {
                fatalError("loading of store filed: \(err)")
            }
        })
        return ps
    }()
    
}
