//
//  ProjectItemDetailDeductionCell.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 16/3/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit

class ProjectItemDetailDeductionCell: UITableViewCell {
    
    let titleLabel: UILabel = {
       let lb = UILabel()
        lb.text = "Fabric"
        return lb
    }()
    
    let widthLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Width:"
        return lb
    }()
    
    let heightLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Height:"
        return lb
    }()
    
    var widthTextField: ProjectDetailAndItemTextField = {
        let tf = ProjectDetailAndItemTextField()
        tf.text = "1111"
        return tf
    }()
    
    var heightTextField: ProjectDetailAndItemTextField = {
        let tf = ProjectDetailAndItemTextField()
        tf.text = "1111"
        return tf
    }()
        
    func setupUI() {
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: 5, bottom: 0, right: 0))
        
        addSubview(widthLabel)
        widthLabel.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 10, bottom: 0, right: 0), size: CGSize(width: 0, height: 20))
        
        addSubview(widthTextField)
        widthTextField.anchor(top: widthLabel.topAnchor, leading: widthLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 100, height: 20))
        
        
        addSubview(heightLabel)
        heightLabel.anchor(top: widthLabel.topAnchor, leading: widthTextField.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 50, bottom: 0, right: 0), size: CGSize(width: 0, height: 20))
        
        addSubview(heightTextField)
        heightTextField.anchor(top: widthLabel.topAnchor, leading: heightLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 100, height: 20))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .whiteBlue
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
