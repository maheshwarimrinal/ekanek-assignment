//
//  SearchViewController.swift
//  ekanek-assignment
//
//  Created by Mrinal Maheshwari on 21/05/20.
//  Copyright © 2020 Mrinal Maheshwari. All rights reserved.
//

import UIKit

struct Welcome: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}


class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var search = UISearchController(searchResultsController: nil)
    
    var numberOfItemsPerSection = 30
//    var isPageRefreshing : Bool = false
//    var page : Int = 0
    
    //Initialising ScrollView for infinite scrolling
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
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.minimumLineSpacing = 2
        collectionViewFlowLayout.itemSize = CGSize(width: 123, height: 123)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCollectionViewCell")
//        imageCollectionView.contentInset = UIEdgeInsets(top: -2, left: -2, bottom: -2, right: -2)
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
        parseJSON()
        setLayout()
    }
    
    func setLayout(){
        NSLayoutConstraint.activate([
            
            imageCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
            
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsPerSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        collectionViewCell.imageView.backgroundColor = .green
        collectionViewCell.imageView.text = "\(indexPath.row)"
        return collectionViewCell
    }
    
    func parseJSON(){
        if let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=8d3827adfd94d09a720226ece2074c5a&format=json&text=dogs&nojsoncallback=true&per_page=30&page=1") {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                    let res = try JSONDecoder().decode(Welcome.self, from: data)
                    downloadImage( urlString: "https://farm\(res.photos.photo[0].farm).staticflickr.com/\(res.photos.photo[0].server)/\(res.photos.photo[0].id)_\(res.photos.photo[0].secret)_m.jpg")
                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
    }
}
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//
//        if offsetY > contentHeight - scrollView.frame.size.height {
//           numberOfItemsPerSection += 30
//           self.imageCollectionView.reloadData()
//        }
//    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print(numberOfItemsPerSection, "+++++++++++")
//        if indexPath.row == numberOfItemsPerSection - 1{
//            numberOfItemsPerSection += 30;
//            imageCollectionView.reloadData()
//        }
//        print(numberOfItemsPerSection, "--------")
//    }
