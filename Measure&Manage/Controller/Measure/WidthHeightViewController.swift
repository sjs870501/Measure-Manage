//
//  WidthAndHeightViewController.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 5/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit

class CustumTextFieldInset: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
}

class WidthHeightViewController: UIViewController {
    
    let context = CoreDataManager.shared.persistantContainer.viewContext
    var isFromAddItem = false
    var isFirstCycle = true
    
    var delegate: DeductionCollectionViewControllerDelegate?
    
    var project: Project?
    var projectItem: ProjectItem?
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.keyboardDismissMode = .interactive
        return sv
    }()
    
    let widthLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Width"
        lb.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        lb.textColor = .darkBlue
        return lb
    }()
    
    let heightLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Height"
        lb.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        lb.textColor = .darkBlue
        return lb
    }()
    
    let widthTextField: CustumTextFieldInset = {
        let tf = CustumTextFieldInset()
        tf.backgroundColor = .whiteBlue
        tf.layer.cornerRadius = 10
        tf.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        tf.textColor = .darkBlue
        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(checkFormValidation), for: .editingChanged)
        return tf
    }()
    
    let heightTextField: CustumTextFieldInset = {
        let tf = CustumTextFieldInset()
        tf.backgroundColor = .whiteBlue
        tf.layer.cornerRadius = 10
        tf.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        tf.textColor = .darkBlue
        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(checkFormValidation), for: .editingChanged)
        return tf
    }()
    
    let submitButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.backgroundColor = .lightGray
        bt.isEnabled = false
        bt.setTitleColor(.darkGray, for: .normal)
        bt.setTitle("Submit", for: .normal)
        bt.layer.cornerRadius = 10
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        bt.addTarget(self, action: #selector(haddleSubmit), for: .touchUpInside)
        return bt
    }()
    
    @objc fileprivate func haddleSubmit() {
        let deductionCollectionViewController = DeductionCollectionController(collectionViewLayout: UICollectionViewFlowLayout())
        deductionCollectionViewController.delegate = delegate
        if isFromAddItem {
            deductionCollectionViewController.isFromAddItem = true
        }
        deductionCollectionViewController.isFirstCycle = isFirstCycle
        projectItem?.width = widthTextField.text ?? ""
        projectItem?.height = heightTextField.text ?? ""
        deductionCollectionViewController.project = self.project
        deductionCollectionViewController.projectItem = self.projectItem
        navigationController?.pushViewController(deductionCollectionViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = projectItem?.location
        navigationController?.navigationBar.isTranslucent = false
        setupUI()
        setupNotification()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-delete-filled-60 (1)").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(handdleCancel))
    }
    
    @objc fileprivate func handdleCancel() {
        if isFromAddItem == false && isFirstCycle {
            if let project = project {
                context.delete(project)
            }
        }
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleTap() {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    fileprivate func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - submitButton.frame.origin.y - submitButton.frame.height
        let difference = keyboardFrame.height - bottomSpace
        
        if difference > 0 {
            view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: Notification) {
        view.transform = CGAffineTransform.identity
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .lightBlue
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(widthLabel)
        widthLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 25, bottom: 0, right: 0), size: .init(width: 100, height: 0))
        
        scrollView.addSubview(widthTextField)
        widthTextField.anchor(top: widthLabel.bottomAnchor, leading: widthLabel.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 25), size: .init(width: 0, height: 50))
        
        scrollView.addSubview(heightLabel)
        heightLabel.anchor(top: widthTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 25, bottom: 0, right: 0), size: .init(width: 85, height: 0))
        
        
        scrollView.addSubview(heightTextField)
        heightTextField.anchor(top: heightLabel.bottomAnchor, leading: heightLabel.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 25), size: .init(width: 0, height: 50))
        
        view.addSubview(submitButton)
        submitButton.anchor(top: heightTextField.bottomAnchor, leading: heightTextField.leadingAnchor, bottom: nil, trailing: heightTextField.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
    }
    
    @objc fileprivate func checkFormValidation() {
        if widthTextField.text != nil && widthTextField.text?.isEmpty == false && heightTextField.text != nil && heightTextField.text?.isEmpty == false {
            submitButton.isEnabled = true
            submitButton.backgroundColor = .darkBlue
            submitButton.setTitleColor(.whiteBlue, for: .normal)
        } else {
            submitButton.isEnabled = false
            submitButton.backgroundColor = .lightGray
            submitButton.setTitleColor(.darkGray, for: .normal)
        }
    }
}
