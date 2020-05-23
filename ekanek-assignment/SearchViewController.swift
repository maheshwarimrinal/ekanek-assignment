//
//  SearchViewController.swift
//  ekanek-assignment
//
//  Created by Mrinal Maheshwari on 21/05/20.
//  Copyright © 2020 Mrinal Maheshwari. All rights reserved.
//

import UIKit
//extension SearchViewController : UICollectionViewFlowLayout{
//}

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    var isLoading : Bool = false
    var numberOfItemsPerSection = 30
    var pageNumber = 2
    var searchValue = "cats"
    var imagePath : [URL] = []
    var saveImageLocally = SaveImageLocally()
            
    var search = UISearchController(searchResultsController: nil)
    
    
    let imageCollectionView : UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.minimumLineSpacing = 2
        collectionViewFlowLayout.itemSize = CGSize(width: 123, height: 123)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewFlowLayout.invalidateLayout()
        
        let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCollectionViewCell")
//        imageCollectionView.isScrollEnabled = false
//        imageCollectionView.contentInset = UIEdgeInsets(top: -2, left: -2, bottom: -2, right: -2)
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.searchController = search
                
        search.searchBar.delegate = self
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        self.view.addSubview(imageCollectionView)
        setLayout()
        saveImageLocally.searchValue = searchValue
        saveImageLocally.parseJson(pageNumber: pageNumber)
//        sleep(3)
//        imagePath = saveImageLocally.imageURL()
//        imageCollectionView.reloadData()
    }
    
    func setLayout(){
        NSLayoutConstraint.activate([

            imageCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
            
        ])
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchValue = searchBar.text!
//        parseJson()
    }

    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePath.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        collectionViewCell.imageView.image = UIImage(named: imagePath[indexPath.row].path)
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == imagePath.count - 1 && !self.isLoading{
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        
        if !self.isLoading {
            self.isLoading = true
            self.pageNumber = self.pageNumber + 1
            self.saveImageLocally.parseData(pageNumber: self.pageNumber)
            
            DispatchQueue.global().async {
                // fake background loading task
//                for _ in start...end {
//                    self.itemsArray.append(self.getRandomColor())
//                }
                sleep(3)
                DispatchQueue.main.async {
                    self.imagePath = self.saveImageLocally.imageURL()
                    print(self.imagePath.count, self.saveImageLocally.imageURL().count)
                    self.imageCollectionView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
}
        
        
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//            if self.isLoading {
//                return CGSize.zero
//            } else {
//                return CGSize(width: collectionView.bounds.size.width, height: 55)
//            }
//        }
//
//        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//            if kind == UICollectionView.elementKindSectionFooter {
//                let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
//                loadingView = aFooterView
//                loadingView?.backgroundColor = UIColor.clear
//                return aFooterView
//            }
//            return UICollectionReusableView()
//        }
//
//        func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//            if elementKind == UICollectionView.elementKindSectionFooter {
//                self.loadingView?.activityIndicator.startAnimating()
//            }
//        }
//
//        func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
//            if elementKind == UICollectionView.elementKindSectionFooter {
//                self.loadingView?.activityIndicator.stopAnimating()
//            }
//        }
    
