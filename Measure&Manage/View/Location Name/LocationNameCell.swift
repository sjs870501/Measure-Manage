//
//  LocationNameCell.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 7/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit

class LocationNameCell: UICollectionViewCell {
    
    let locationNameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        label.textAlignment = .center
        label.textColor = .darkBlue
        label.numberOfLines = 0
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "icons8-minus-30").withRenderingMode(.alwaysOriginal)
        iv.alpha = 0
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(locationNameLable)
        locationNameLable.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        backgroundColor = .lightBlue
        addSubview(imageView)
        imageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 5), size: .init(width: 30, height: 30))
        layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
