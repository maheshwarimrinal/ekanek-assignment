//
//  ImageViewerViewController.swift
//  ekanek-assignment
//
//  Created by Mrinal Maheshwari on 24/05/20.
//  Copyright © 2020 Mrinal Maheshwari. All rights reserved.
//

import UIKit

class ImageViewerViewController: UIViewController {
    
    var imagePath : String = ""
    
    let imageViewer : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(imageViewer)
        setLayout()
        setImage()
    }
    
    func setLayout(){
        NSLayoutConstraint.activate([
            imageViewer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageViewer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageViewer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageViewer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func setImage(){
        imageViewer.image = UIImage(named: imagePath)
        imageViewer.contentMode = .scaleAspectFit
        
    }

}
