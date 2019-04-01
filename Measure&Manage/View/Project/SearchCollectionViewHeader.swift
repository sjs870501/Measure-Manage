//
//  SearchHeader.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 16/3/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit

class SearchCollectionViewHeader: UICollectionViewCell {
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter location name"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .whiteBlue
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(searchBar)
        searchBar.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
