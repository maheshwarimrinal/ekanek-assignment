//
//  ImageCollectionViewCell.swift
//  ekanek-assignment
//
//  Created by Mrinal Maheshwari on 21/05/20.
//  Copyright © 2020 Mrinal Maheshwari. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
//    let imageView : UIImageView = {
//        let imageView = UIImageView()
//        imageView.backgroundColor = .purple
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    let imageView : UILabel = {
        let imageView = UILabel()
//        imageView.backgroundColor = .purple
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        setLayout()
    }
        
    func setLayout(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
