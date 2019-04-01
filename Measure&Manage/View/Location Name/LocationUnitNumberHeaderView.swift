//
//  LocationUnitNumberHeaderView.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 7/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit

class LocationUnitNumberHeaderView: UICollectionViewCell {
    
    let submitButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Submit", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.backgroundColor = .normalBlue
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: frame.width / 2, height: frame.height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
