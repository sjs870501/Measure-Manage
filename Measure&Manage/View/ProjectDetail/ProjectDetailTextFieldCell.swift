//
//  ProjectDetailTextFieldCell.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 28/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit

class ProjectDetailAndItemTextField: UITextField {
    
    var projectInfo: ProjectInfo?
    var senderTitle: String?
    var senderSubTitle: String?
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 44)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 24, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return  bounds.insetBy(dx: 24, dy: 0)
    }
}

class ProjectDetailTextFieldCell: UITableViewCell {
    
    let textField: ProjectDetailAndItemTextField = {
        let tf = ProjectDetailAndItemTextField()
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
