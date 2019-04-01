//
//  ImageCollectionViewController.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 24/3/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

import UIKit

extension ImageCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[.editedImage] as? UIImage
        guard let originalImage = info[.originalImage] as? UIImage else { return }
        
        let projectImage = ProjectImage(context: context)
        
        if let editedImage = editedImage {
            let imageData = editedImage.jpegData(compressionQuality: 1.0)
            projectImage.projectImage = imageData
            images.append(editedImage)
        } else {
            let imageData = originalImage.jpegData(compressionQuality: 1.0)
            projectImage.projectImage = imageData
            images.append(originalImage)
        }
        
        projectImage.project = self.project
        let index = images.count - 1
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.insertItems(at: [indexPath])
        imagePicker.dismiss(animated: true, completion: nil)
        
        do {
            try context.save()
        } catch let err {
            print("failed to save: ", err)
        }
    }
}

class ImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ImageViewControllerDelegate {
    
    var project: Project? {
        didSet{
            let projectImages = project?.projectImages?.allObjects as? [ProjectImage]
            
            projectImages?.forEach({ (projectImage) in
                imageDatas.append(projectImage)
                guard let data = projectImage.projectImage else { return }
                guard let image = UIImage(data: data) else { return }
                images.append(image)
            })
            collectionView.reloadData()
        }
    }
    
    let context = CoreDataManager.shared.persistantContainer.viewContext
    let cellId = "cellId"
    var imageDatas = [ProjectImage]()
    var images = [UIImage]()
    
    let imagePicker = UIImagePickerController()
    
    let addImageButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("+", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bt.layer.cornerRadius = 25
        bt.backgroundColor = .darkBlue
        bt.addTarget(self, action: #selector(handleAddImage), for: .touchUpInside)
        bt.alpha = 0.85
        return bt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setupCollectionAndNavigation()
        setupUI()
    }
    
    fileprivate func setupUI() {
        view.addSubview(addImageButton)
        addImageButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 50, height: 50))
        addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupCollectionAndNavigation() {
        collectionView.backgroundColor = .lightBlue
        collectionView.alwaysBounceVertical = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        title = "Image"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-delete-filled-60 (1)").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    }
    
    @objc fileprivate func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .whiteBlue
        
        cell.addSubview(imageView)
        imageView.fillSuperview()
        imageView.image = images[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 30
        let height = view.frame.height - 30
        
        return CGSize(width: width, height: height)
    }
    
    @objc fileprivate func handleAddImage() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageViewController = ImageViewController()
        imageViewController.imageView.image = images[indexPath.item]
        imageViewController.delegate = self
        present(imageViewController, animated: true, completion: nil)
    }
    
    func didDeleteButtonClicked(image: UIImage) {
        guard let index = images.firstIndex(of: image) else { return }
        images.remove(at: index)
        context.delete(imageDatas[index])
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.deleteItems(at: [indexPath])
        
        do {
            try context.save()
        } catch let err {
            print("failed to save: ", err)
        }
    }
}
