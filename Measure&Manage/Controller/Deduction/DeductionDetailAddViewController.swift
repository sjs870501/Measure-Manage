//
//  DeductionDetailAddViewController.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 16/2/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit
import CoreData

protocol DeductionDetailAddViewControllerDelegate {
    func didSaveDeductionDetail(deductionDetail: DeductionDetail)
}

class DeductionDetailsAddViewController: UIViewController {
    
    let context = CoreDataManager.shared.persistantContainer.viewContext
    
    var delegate: DeductionDetailAddViewControllerDelegate?
    
    var viewStyle: Int? {
        didSet{
            if viewStyle == 0 {
                button1.setTitle("+", for: .normal)
                button2.setTitle("-", for: .normal)
                button3.setTitle("*", for: .normal)
                button4.setTitle("/", for: .normal)
            } else {
                button1.setTitle("<", for: .normal)
                button2.setTitle(">", for: .normal)
                button3.setTitle(">=", for: .normal)
                button4.setTitle("<=", for: .normal)
            }
        }
    }
    
    var deduction: Deduction?
    
    var navBartitle: String? {
        didSet{
            navigationItem.title = navBartitle
        }
    }
    
    var isFirstChunk = true
    
    
    let widthButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("OriginalWidth", for: .normal)
        bt.setTitleColor(.whiteBlue, for: .normal)
        bt.backgroundColor = .normalBlue
        return bt
    }()
    
    let heightButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("OriginalHeight", for: .normal)
        bt.setTitleColor(.whiteBlue, for: .normal)
        bt.backgroundColor = .normalBlue
        return bt
    }()
    
    let button1: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitleColor(.whiteBlue, for: .normal)
        bt.backgroundColor = .normalBlue
        return bt
    }()
    
    let button2: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitleColor(.whiteBlue, for: .normal)
        bt.backgroundColor = .normalBlue
        return bt
    }()
    
    let button3: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitleColor(.whiteBlue, for: .normal)
        bt.backgroundColor = .normalBlue
        return bt
    }()
    
    let button4: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitleColor(.whiteBlue, for: .normal)
        bt.backgroundColor = .normalBlue
        return bt
    }()
    
    lazy var toplabel: UILabel = {
        let lb = UILabel()
        lb.text = "Deducted \(navBartitle ?? "") ="
        lb.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        lb.textColor = .darkBlue
        return lb
    }()
    
    lazy var numberTextFeildStackView: UIStackView = {
        let submitBotton = UIButton(type: .system)
        submitBotton.setTitle("Submit", for: .normal)
        submitBotton.setTitleColor(.whiteBlue, for: .normal)
        submitBotton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        submitBotton.backgroundColor = .normalBlue
        submitBotton.clipsToBounds = true
        let sv = UIStackView(arrangedSubviews: [self.numberTextFeild, submitBotton])
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.layer.cornerRadius = 10
        sv.clipsToBounds = true
        return sv
    }()
    
    let numberTextFeild: CustumTextFieldInset = {
        let tf = CustumTextFieldInset()
        tf.backgroundColor = .whiteBlue
//        tf.layer.cornerRadius = 10
        tf.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        tf.textColor = .darkBlue
        tf.placeholder = "value to deduct"
        tf.keyboardType = .numberPad
        tf.clipsToBounds = true
        return tf
    }()
    
    let valueTextField: CustumTextFieldInset = {
        let tf = CustumTextFieldInset()
        tf.backgroundColor = .whiteBlue
        tf.layer.cornerRadius = 10
        tf.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        tf.textColor = .darkBlue
        tf.placeholder = "desired value"
        tf.keyboardType = .numberPad
        tf.clipsToBounds = true
        return tf
    }()
    
    @objc fileprivate func handleSubmit() {
        combinedText += " \(numberTextFeild.text ?? "")"
        numberTextFeild.text = nil
        displayLable.text = combinedText
        isFirstChunk = false
    }
    
    lazy var stackView: UIStackView = {
        
        let fourButtonsStackView = UIStackView(arrangedSubviews: [button1, button2, button3, button4])
        fourButtonsStackView.axis = .horizontal
        fourButtonsStackView.distribution = .fillEqually
        fourButtonsStackView.spacing = 1
        
        let widthHeightStackView = UIStackView(arrangedSubviews: [widthButton, heightButton])
        widthHeightStackView.axis = .horizontal
        widthHeightStackView.distribution = .fillEqually
        widthHeightStackView.spacing = 1

        let sv = UIStackView(arrangedSubviews: [widthHeightStackView, fourButtonsStackView])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 1
        return sv
    }()
    
    let displayLable: UILabel = {
        let lb = UILabel()
        lb.textColor = .darkBlue
        lb.isUserInteractionEnabled = true
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.numberOfLines = 0
        lb.layer.cornerRadius = 10
        lb.clipsToBounds = true
        lb.backgroundColor = .lightBlue
        lb.layer.borderColor = UIColor.darkBlue.cgColor
        lb.layer.borderWidth = 0.5
        
        let clearButton = UIButton(type: .system)
        clearButton.setImage(#imageLiteral(resourceName: "icons8-clear-symbol-90").withRenderingMode(.alwaysOriginal), for: .normal)
        clearButton.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
        lb.addSubview(clearButton)
        clearButton.anchor(top: lb.topAnchor, leading: nil, bottom: lb.bottomAnchor, trailing: lb.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15), size: CGSize(width: 30, height: 30))
        
        return lb
    }()
    
    @objc fileprivate func handleClear() {
        combinedText = ""
        displayLable.text = nil
        isFirstChunk = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotification()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        createOneAction(target: self, selector: #selector(buttonAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc fileprivate func handleSave() {
        let deductionDetail = DeductionDetail(context: context)
        deductionDetail.deduction = self.deduction
        deductionDetail.deductionDetailValue = displayLable.text
        deductionDetail.deductionDetailTitle = navBartitle
        deductionDetail.viewStyle = Int16(viewStyle ?? 0)
        if viewStyle != 0 {
            deductionDetail.desiredValue = Int16(valueTextField.text ?? "") ?? 0
            if viewStyle == 1 {
                deductionDetail.deductionDetailValue = "\(valueTextField.text ?? "") if \(displayLable.text ?? "")"
            } else {
                deductionDetail.deductionDetailValue = valueTextField.text
            }
            
        }
        delegate?.didSaveDeductionDetail(deductionDetail: deductionDetail)
        
        print(deductionDetail)
        
        do {
            try context.save()
        } catch let err {
            print("failed to save: ", err)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    var combinedText = ""
    
    @objc fileprivate func buttonAction(button: UIButton) {
        guard let currentTitle = button.currentTitle else { return }
        
        if isFirstChunk {
            combinedText = currentTitle
            isFirstChunk = false
        } else {
            if numberTextFeild.text != nil || numberTextFeild.text != "" {
                combinedText += " \(numberTextFeild.text ?? "")"
                combinedText += "\(currentTitle)"
            } else {
                combinedText += currentTitle
            }
        }
        
                displayLable.text = combinedText
        numberTextFeild.text = ""
        
        
//        if topTextView.text == nil {
//            displayLable.text = currentTitle
//        } else {
//            guard let text = displayLable.text else { return }
//            displayLable.text = text + topTextView.text + currentTitle
//        }
        
    }
    
    @objc fileprivate func handleTap() {
        view.endEditing(true)
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .lightBlue
        
            view.addSubview(toplabel)
            toplabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 25, left: 25, bottom: 0, right: 0), size: .init(width: 85, height: 0))
        
        if viewStyle != 2 {
            view.addSubview(stackView)
            stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 70))
        }
        
        if viewStyle == 0 {
            view.addSubview(displayLable)
            displayLable.anchor(top: toplabel.bottomAnchor, leading: toplabel.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 25), size: .init(width: 0, height: 100))
            
            view.addSubview(numberTextFeildStackView)
            numberTextFeildStackView.anchor(top: displayLable.bottomAnchor, leading: toplabel.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 25), size: .init(width: 0, height: 50))
        } else {
            view.addSubview(valueTextField)
            valueTextField.anchor(top: toplabel.bottomAnchor, leading: toplabel.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 25), size: .init(width: 0, height: 50))
            
            if viewStyle == 1 {
                view.addSubview(displayLable)
                displayLable.anchor(top: valueTextField.bottomAnchor, leading: valueTextField.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 25), size: .init(width: 0, height: 100))
                
                view.addSubview(numberTextFeildStackView)
                numberTextFeildStackView.anchor(top: displayLable.bottomAnchor, leading: toplabel.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 25), size: .init(width: 0, height: 50))
            }
        }
    }
    
    fileprivate func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShowNotification(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
//        view.transform =
        stackView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
    }
    
    func createOneAction(target: Any?, selector: Selector) {
        [button1, button2, button3, button4, widthButton, heightButton].forEach { (button) in
            button.addTarget(target, action: selector, for: .touchUpInside)
        }
    }
    
    @objc fileprivate func keyboardWillHideNotification(notification: Notification) {
        stackView.transform = CGAffineTransform.identity
    }
    
}
