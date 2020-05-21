//
//  SearchViewController.swift
//  ekanek-assignment
//
//  Created by Mrinal Maheshwari on 21/05/20.
//  Copyright © 2020 Mrinal Maheshwari. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var search = UISearchController(searchResultsController: nil)
    
    
    //Initilising ScrollView for infinite scrolling
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    //Initialsing contentView to display content on ScrollView
    let contentView : UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    let imageCollectionView : UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.itemSize = CGSize(width: 131, height: 131)
        
        let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCollectionViewCell")
        imageCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.searchController = search
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
//        self.view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
        self.view.addSubview(imageCollectionView)
        setLayout()
    }
    
    func setLayout(){
        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
//
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath)
        collectionViewCell.backgroundColor = .blue
        return collectionViewCell
    }
}
