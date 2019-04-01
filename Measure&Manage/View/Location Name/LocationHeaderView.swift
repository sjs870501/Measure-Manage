//
//  LocationNameCollectionHeaderView.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 7/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit

class CustomUIButton: UIButton {
    var sender: String?
    var project: Project?
}

class LocationHeaderView: UICollectionViewCell {
    
    let locationTitleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return lb
    }()
    
    let plusButton: CustomUIButton = {
        let bt = CustomUIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "icons8-plus-30").withRenderingMode(.alwaysOriginal), for: .normal)
        return bt
    }()
    
    let minusButton: UIButton = {
        let bt = CustomUIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "icons8-minus-30").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .normalBlue
        addSubview(locationTitleLabel)
        locationTitleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        addSubview(plusButton)
        plusButton.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 10), size: .init(width: 40, height: 40))
        addSubview(minusButton)
        minusButton.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: plusButton.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
