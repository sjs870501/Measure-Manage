//
//  ProjectCell.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 23/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit

class ProjectsCell: UICollectionViewCell {
    
    var project: Project? {
        didSet{
            deleteButton.project = project
            detailButton.project = project
            imageButton.project = project
            projectNumberLabel.text = project?.projectNumber
            let nameMutableAttributedString = NSMutableAttributedString(string: "Name:", attributes: [.foregroundColor: UIColor.darkBlue, .font: UIFont.systemFont(ofSize: 20, weight: .heavy)])
            
            let spaceAttributedString = NSAttributedString(string: "\n", attributes: [.foregroundColor: UIColor.darkBlue, .font: UIFont.systemFont(ofSize: 5)])
            
            guard let projectName = project?.projectName else { return }
            
            let nameAttributedString = NSAttributedString(string: " \(projectName)", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .medium)])
            
            nameMutableAttributedString.append(spaceAttributedString)
            nameMutableAttributedString.append(nameAttributedString)
            
            projectNameLabel.attributedText = nameMutableAttributedString
            
            
            let numberOfItemsMutableAttributedString = NSMutableAttributedString(string: "Number of Items:\n", attributes: [.foregroundColor: UIColor.darkBlue, .font: UIFont.systemFont(ofSize: 20, weight: .heavy)])
            
            guard let numberOfItems = project?.projectItems?.allObjects as? [ProjectItem] else { return }
            
            let numberOfItemsAttributedString = NSAttributedString(string: " \(numberOfItems.count)", attributes: [.foregroundColor: UIColor.darkBlue, .font: UIFont.systemFont(ofSize: 18, weight: .medium)])
            
            numberOfItemsMutableAttributedString.append(spaceAttributedString)
            numberOfItemsMutableAttributedString.append(numberOfItemsAttributedString)
            
            numberOfItemsLabel.attributedText = numberOfItemsMutableAttributedString
            
            guard let creationDate = project?.creationDate else { return }
            let dateFormmater = DateFormatter()
            dateFormmater.dateFormat = "dd/MM/yy"
            let dateString = dateFormmater.string(from: creationDate)
            
            let attributedString = NSMutableAttributedString(string: "Created Date:", attributes: [.foregroundColor: UIColor.whiteBlue, .font: UIFont.systemFont(ofSize: 14, weight: .light)])
            
            let creationDateAttributedString = NSAttributedString(string: " \(dateString)", attributes: [.foregroundColor: UIColor.whiteBlue, .font: UIFont.systemFont(ofSize: 14, weight: .medium)])
            
            attributedString.append(creationDateAttributedString)
            createdDateLabel.attributedText = attributedString
        }
    }
    
    let projectNumberLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .whiteBlue
        lb.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        return lb
    }()
    
    let projectNameLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        return lb
    }()
    
    let numberOfItemsLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        return lb
    }()
    
    let createdDateLabel: UILabel = {
       let lb = UILabel()
        lb.numberOfLines = 0
        return lb
    }()
    
    let dueDateLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        return lb
    }()
    
    let deleteButton: CustomUIButton = {
        let bt = CustomUIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "icons8-trash-can-filled-90").withRenderingMode(.alwaysOriginal), for: .normal)
        return bt
    }()
    
    let imageButton: CustomUIButton = {
        let bt = CustomUIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "icons8-picture-filled-90").withRenderingMode(.alwaysOriginal), for: .normal)
        return bt
    }()
    
    let detailButton: CustomUIButton = {
        let bt = CustomUIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "icons8-document-filled-90").withRenderingMode(.alwaysOriginal), for: .normal)
        return bt
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .normalBlue
        return view
    }()
    
    let topContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightBlue
        layer.cornerRadius = 10
        topContainer.backgroundColor = .normalBlue
        topContainer.layer.cornerRadius = 10
        addSubview(topContainer)
        topContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: frame.width, height: 80))
        topContainer.addSubview(projectNumberLabel)
        projectNumberLabel.anchor(top: topContainer.topAnchor, leading: topContainer.leadingAnchor, bottom: topContainer.bottomAnchor, trailing: nil, padding: .init(top: 25, left: 25, bottom: 25, right: 0))
        topContainer.addSubview(createdDateLabel)
        createdDateLabel.anchor(top: topContainer.topAnchor, leading: nil, bottom: nil, trailing: topContainer.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 10), size: .init(width: 0, height: 0))
        
        topContainer.addSubview(dueDateLabel)
        dueDateLabel.anchor(top: createdDateLabel.bottomAnchor, leading: nil, bottom: nil, trailing: topContainer.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 10), size: .init(width: 0, height: 0))
        
        
        
        
        
        let dueDatelabelAttributedString = NSMutableAttributedString(string: "Due Date:", attributes: [.foregroundColor: UIColor.whiteBlue, .font: UIFont.systemFont(ofSize: 14, weight: .light)])
        let dueDateAttributedString = NSAttributedString(string: "        11/11/11", attributes: [.foregroundColor: UIColor.whiteBlue, .font: UIFont.systemFont(ofSize: 14, weight: .medium)])
        
        dueDatelabelAttributedString.append(dueDateAttributedString)
        
        dueDateLabel.attributedText = dueDatelabelAttributedString
        
        addSubview(projectNameLabel)
        projectNameLabel.anchor(top: topContainer.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        addSubview(numberOfItemsLabel)
        numberOfItemsLabel.anchor(top: projectNameLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        
        let stackView = UIStackView(arrangedSubviews: [detailButton, imageButton, deleteButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 0))
        
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, leading: leadingAnchor, bottom: stackView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 25, bottom: 10, right: 25), size: .init(width: 0, height: 1))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
