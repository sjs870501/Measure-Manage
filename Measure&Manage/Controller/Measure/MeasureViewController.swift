//
//  MeasureController.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 4/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MeasureViewController: UIViewController, UITextViewDelegate {
    
    let context = CoreDataManager.shared.persistantContainer.viewContext
    var delegate: DeductionCollectionViewControllerDelegate?
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    let projectTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Project Name:"
        lb.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        lb.textColor = .darkBlue
        return lb
    }()
    
    let projectNumberLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Project No:"
        lb.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        lb.textColor = .darkBlue
        return lb
    }()
    
    let projectNameTextView: CustomTextView = {
        let tv = CustomTextView()
        tv.backgroundColor = .whiteBlue
        tv.layer.cornerRadius = 10
        tv.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        tv.textColor = .darkBlue
        return tv
    }()
    
    let projectNumberTextView: CustomTextView = {
        let tv = CustomTextView()
        tv.backgroundColor = .whiteBlue
        tv.layer.cornerRadius = 10
        tv.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        tv.textColor = .darkBlue
        tv.keyboardType = .numberPad
        return tv
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Measurement"
        projectNumberTextView.delegate = self
        projectNameTextView.delegate = self
        
        setupNavigationBar()
        setupAnimation()
        setupUI()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        setupNotification()
        
    }
    
    @objc fileprivate func haddleSubmit() {
        view.endEditing(true)
        let project = Project(context: context)
        project.projectName = projectNameTextView.text ?? ""
        project.projectNumber = projectNumberTextView.text ?? ""
        project.creationDate = Date()
        
        projectNameTextView.text = nil
        projectNumberTextView.text = nil
        checkFormValidation()
        
        let locationNameCollectionView = LocationNameCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        locationNameCollectionView.project = project
        locationNameCollectionView.delegate = delegate
        let navCotroller = UINavigationController(rootViewController: locationNameCollectionView)
        present(navCotroller, animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkFormValidation()
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
    
    
    @objc fileprivate func handleTap() {
        view.endEditing(true)
    }
    
    fileprivate func setupAnimation() {
        
        projectNumberLabel.transform = CGAffineTransform(translationX: 0, y: 300)
        projectNumberLabel.alpha = 0
        projectNumberTextView.transform = CGAffineTransform(translationX: 0, y: 300)
        projectNumberTextView.alpha = 0
        
        projectTitleLabel.transform = CGAffineTransform(translationX: 0, y: 300)
        projectTitleLabel.alpha = 0
        projectNameTextView.transform = CGAffineTransform(translationX: 0, y: 300)
        projectNameTextView.alpha = 0
        
        submitButton.transform = CGAffineTransform(translationX: 0, y: 300)
        submitButton.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.projectNumberLabel.transform = CGAffineTransform.identity
            self.projectNumberLabel.alpha = 1
            self.projectNumberTextView.transform = CGAffineTransform.identity
            self.projectNumberTextView.alpha = 1
            
        }) { (_) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.projectTitleLabel.transform = CGAffineTransform.identity
                self.projectTitleLabel.alpha = 1
                self.projectNameTextView.transform = CGAffineTransform.identity
                self.projectNameTextView.alpha = 1
                self.submitButton.transform = CGAffineTransform.identity
                self.submitButton.alpha = 1
            })
        }
    }
    
    fileprivate func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    fileprivate func setupUI() {
        
        view.backgroundColor = .lightBlue
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(projectNumberLabel)
        projectNumberLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 25, bottom: 0, right: 0), size: .init(width: 100, height: 0))
        
        scrollView.addSubview(projectNumberTextView)
        projectNumberTextView.anchor(top: projectNumberLabel.bottomAnchor, leading: projectNumberLabel.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 25), size: .init(width: 0, height: 50))
        
        scrollView.addSubview(projectTitleLabel)
        projectTitleLabel.anchor(top: projectNumberTextView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 25, left: 25, bottom: 0, right: 0), size: .init(width: 85, height: 0))
        
        
        scrollView.addSubview(projectNameTextView)
        projectNameTextView.anchor(top: projectTitleLabel.bottomAnchor, leading: projectTitleLabel.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 25), size: .init(width: 0, height: 100))
        
        view.addSubview(submitButton)
        submitButton.anchor(top: projectNameTextView.bottomAnchor, leading: projectNameTextView.leadingAnchor, bottom: nil, trailing: projectNameTextView.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
    }
    
    fileprivate func checkFormValidation() {
        if projectNameTextView.text != nil && projectNameTextView.text.isEmpty == false && projectNumberTextView.text != nil && projectNumberTextView.text.isEmpty == false {
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
