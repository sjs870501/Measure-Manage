//
//  ProjectItemsCell.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 25/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit

class ProjectItemsCell: UICollectionViewCell {
    
    var stackView: StackView?
    
    var projectDetail: ProjectItem? {
        didSet {
            guard let deductedValues = projectDetail?.deductedValues?.allObjects as? [DeductedValueForItem] else { return }
            let sortedDeductedValues = deductedValues.sorted { (p1, p2) -> Bool in
                return p1.partName ?? "" > p2.partName ?? ""
            }
//            setupStackView(deductedValues: sortedDeductedValues)
            if stackView?.isAdded == false {
                setupStackView(deductedValues: sortedDeductedValues)
            } else {
                if let stackView = stackView?.stackView {
                    addSubview(stackView)
                    stackView.anchor(top: topContainerView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 5, bottom: 5, right: 5))
                }
            }
            
            
            guard let locationName = projectDetail?.location else { return }
            
            locationNameLabel.text = "\(locationName)"
            guard let width = projectDetail?.width, let height = projectDetail?.height else { return }
            widthAndHeightLabel.text = "\(width)\n\(height)"
            
            let isMemoExist = projectDetail?.memo != nil
            
            if isMemoExist {
                memoButton.isHidden = false
                memoLabel.text = projectDetail?.memo
                memoButton.addTarget(self, action: #selector(handleMemoExist), for: .touchUpInside)
            } else {
                memoButton.isHidden = true
            }
        }
    }
    
    let locationNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        lb.textColor = .darkBlue
        return lb
    }()
    
    let widthAndHeightLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .darkBlue
        lb.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        lb.numberOfLines = 0
        return lb
    }()
    
    let numberLabel = UILabel()
    
    let memoButton: UIButton = {
        let vt = UIButton(type: .system)
        vt.backgroundColor = .normalBlue
        vt.setTitleColor(.normalBlue, for: .normal)
        vt.layer.cornerRadius = 7
        vt.isHidden = true
        return vt
    }()
    
    lazy var topContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = .whiteBlue
        numberLabel.textColor = .darkBlue
        numberLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        v.addSubview(numberLabel)
        numberLabel.anchor(top: nil, leading: v.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), size: CGSize(width: 0, height: 15))
        numberLabel.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        
        v.addSubview(memoButton)
        memoButton.anchor(top: v.topAnchor, leading: v.leadingAnchor, bottom: numberLabel.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 3, left: 3, bottom: 0, right: 0), size: CGSize(width: 25, height: 14))

        let widthHeightLabel = UILabel()
        widthHeightLabel.text = "W:\nH:"
        widthHeightLabel.numberOfLines = 0
        widthHeightLabel.textColor = .darkBlue
        widthHeightLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        v.addSubview(locationNameLabel)
        locationNameLabel.anchor(top: numberLabel.topAnchor, leading: numberLabel.trailingAnchor, bottom: numberLabel.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
    
        v.addSubview(widthAndHeightLabel)
        widthAndHeightLabel.anchor(top: v.topAnchor, leading: nil, bottom: v.bottomAnchor, trailing: v.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10), size: CGSize(width: 0, height: 0))
        v.addSubview(widthHeightLabel)
        widthHeightLabel.anchor(top: widthAndHeightLabel.topAnchor, leading: nil, bottom: widthAndHeightLabel.bottomAnchor, trailing: widthAndHeightLabel.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 2))
        
        return v
    }()
    
    let memoLabel: UILabel = {
        let lb = UILabel()
        lb.layer.cornerRadius = 10
        lb.layer.masksToBounds = true
        lb.backgroundColor = .whiteBlue
        lb.textColor = .darkBlue
        lb.isUserInteractionEnabled = true
        lb.layer.borderColor = UIColor.darkBlue.cgColor
        lb.layer.borderWidth = 0.5
        return lb
    }()
    
    @objc fileprivate func handleMemoExist() {
        
        memoLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissLabel)))
        addSubview(memoLabel)
        memoLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: 5, bottom: 0, right: 0), size: .init(width: 200, height: 120))
        memoLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.memoLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.memoLabel.alpha = 1
        })
    }
    
    @objc fileprivate func handleDismissLabel() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.memoLabel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            self.memoLabel.alpha = 0
        }) { (_) in
            self.memoLabel.removeFromSuperview()

        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        clipsToBounds = true
        backgroundColor = .whiteBlue
        addSubview(topContainerView)
        topContainerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 60))
        
    }
    
    func setupStackView(deductedValues: [DeductedValueForItem]) {
        
        let firstStackView = UIStackView()
        firstStackView.axis = .vertical
        firstStackView.distribution = .fillEqually
        firstStackView.spacing = 1
        
        let secontStackView = UIStackView()
        secontStackView.axis = .vertical
        secontStackView.distribution = .fillEqually
        secontStackView.spacing = 1
        
        let thirdStackView = UIStackView()
        thirdStackView.axis = .vertical
        thirdStackView.distribution = .fillEqually
        thirdStackView.spacing = 1
        
        for (index, deductedValue) in deductedValues.enumerated() {
            guard let partName = deductedValue.partName else { return }
            let width = deductedValue.width
            let height = deductedValue.height
            let partLabel = UILabel()
            partLabel.text = partName
            partLabel.font = UIFont.boldSystemFont(ofSize: 18)
            partLabel.backgroundColor = .lightBlue
            partLabel.textAlignment = .center
            partLabel.textColor = .darkBlue
            
            let widthLabel = UILabel()
            widthLabel.text = "Width"
            widthLabel.textAlignment = .center
            widthLabel.backgroundColor = .lightBlue
            widthLabel.textColor = .darkBlue
            
            let heightLabel = UILabel()
            heightLabel.text = "Height"
            heightLabel.textAlignment = .center
            heightLabel.backgroundColor = .lightBlue
            heightLabel.textColor = .darkBlue

            let widthValueLabel = UILabel()
            widthValueLabel.text = String(width)
            widthValueLabel.textAlignment = .center
            widthValueLabel.backgroundColor = .lightBlue
            widthValueLabel.textColor = .darkBlue

            let heightValueLabel = UILabel()
            heightValueLabel.text = String(height)
            heightValueLabel.textAlignment = .center
            heightValueLabel.backgroundColor = .lightBlue
            heightValueLabel.textColor = .darkBlue
            
            let topStackView = UIStackView(arrangedSubviews: [partLabel])
            topStackView.distribution = .fillEqually
            
            let midStackView = UIStackView(arrangedSubviews: [widthLabel, heightLabel])
            midStackView.axis = .horizontal
            midStackView.distribution = .fillEqually
            midStackView.spacing = 1
            
            let bottomStackView = UIStackView(arrangedSubviews: [widthValueLabel, heightValueLabel])
            bottomStackView.axis = .horizontal
            bottomStackView.distribution = .fillEqually
            bottomStackView.spacing = 1
            
            if index == 0 {
                firstStackView.addArrangedSubview(topStackView)
                firstStackView.addArrangedSubview(midStackView)
                firstStackView.addArrangedSubview(bottomStackView)
            } else if index == 1 {
                secontStackView.addArrangedSubview(topStackView)
                secontStackView.addArrangedSubview(midStackView)
                secontStackView.addArrangedSubview(bottomStackView)
            } else {
                thirdStackView.addArrangedSubview(topStackView)
                thirdStackView.addArrangedSubview(midStackView)
                thirdStackView.addArrangedSubview(bottomStackView)
            }
            
            self.stackView?.stackView = UIStackView(arrangedSubviews: [firstStackView, secontStackView, thirdStackView])
            if let stackView = stackView?.stackView {
                stackView.distribution = .fillEqually
                stackView.axis = .horizontal
                stackView.spacing = 1
                addSubview(stackView)
                stackView.anchor(top: topContainerView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 5, bottom: 5, right: 5))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
