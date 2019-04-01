//
//  ImageViewController.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 21/3/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit

protocol ImageViewControllerDelegate {
    func didDeleteButtonClicked(image: UIImage)
}

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var delegate: ImageViewControllerDelegate?
    let gradientLayer = CAGradientLayer()
    var isGradient = true
    
    let doneButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Done", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bt.addTarget(self, action: #selector(handlDone), for: .touchUpInside)
        return bt
    }()
    
    let deleteButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Delete", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bt.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return bt
    }()
    
    @objc fileprivate func handleDelete() {
        guard let image = imageView.image else { return }
        delegate?.didDeleteButtonClicked(image: image)
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handlDone() {
        dismiss(animated: true, completion: nil)
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.maximumZoomScale = 4.0
        sv.minimumZoomScale = 1.0
        sv.alwaysBounceVertical = true
        sv.alwaysBounceHorizontal = true
        return sv
    }()
    
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        scrollView.delegate = self
        setupUI()
        setupGradient()
        setupButtons()
        hadleTap()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupUI() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hadleTap)))
        
        scrollView.addSubview(imageView)
        imageView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor, size: CGSize(width: view.frame.width, height: view.frame.height))
    }
    
    fileprivate func setupButtons() {
        view.addSubview(doneButton)
        doneButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 20))
        
        view.addSubview(deleteButton)
        deleteButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 0))
    }
    
    @objc fileprivate func hadleTap() {
        if isGradient {
            gradientLayer.isHidden = true
            doneButton.isHidden = true
            deleteButton.isHidden = true
            isGradient = !isGradient
        } else {
            gradientLayer.isHidden = false
            doneButton.isHidden = false
            deleteButton.isHidden = false
            isGradient = !isGradient
        }
    }
    
    fileprivate func setupGradient() {
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [-0.1, 0.35]
        gradientLayer.frame = view.bounds
        self.view.layer.addSublayer(self.gradientLayer)
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
