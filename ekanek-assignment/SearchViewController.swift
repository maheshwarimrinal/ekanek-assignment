//
//  SearchViewController.swift
//  ekanek-assignment
//
//  Created by Mrinal Maheshwari on 21/05/20.
//  Copyright © 2020 Mrinal Maheshwari. All rights reserved.
//

import UIKit

var defaultDisplayCells = 3

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    var isLoading : Bool = false
    var numberOfItemsPerSection = 30
    var pageNumber = 2
    var searchValue = "food"
    var imagePath : [URL] = []
    var saveImageLocally = SaveImageLocally()
    var loadingView: LoadingReusableView?
    
            
    var search = UISearchController(searchResultsController: nil)
    
    let imageCollectionView : UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.minimumLineSpacing = 2
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewFlowLayout.invalidateLayout()
        
        let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCollectionViewCell")
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageCollectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        imageCollectionView.reloadData()
    }
    
    let bottomRefreshLoader : UIRefreshControl = {
        let bottomRefreshLoader = UIRefreshControl()
//        bottomRefreshLoader.offse
        return bottomRefreshLoader
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.searchController = search
        
        let settings = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(barButton))
        navigationItem.rightBarButtonItem = settings
                
        search.searchBar.delegate = self
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        imageCollectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")
        
        self.view.addSubview(imageCollectionView)
        setLayout()
        if saveImageLocally.totalValuesAvailable() == 0 && saveImageLocally.isConnectedToNetwork() == false{
            let alertController = UIAlertController(title: "Connectivity", message: "Kindly Connect to internet to load infornmation", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }else{
            saveImageLocally.searchValue = searchValue
            saveImageLocally.checkState(pageNumber: pageNumber)
            sleep(2)
            imagePath = saveImageLocally.imageURL()
            imageCollectionView.reloadData()
        }
    }
    
    //Setting layout of imageCollectionView
    func setLayout(){
        NSLayoutConstraint.activate([

            imageCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
            
        ])
    }
    
    //When search button is clicked on keyboard used to fetch search value
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchValue = searchBar.text!
        pageNumber = 2
        imagePath = []
        saveImageLocally.searchValue = searchValue
        saveImageLocally.checkState(pageNumber: pageNumber)
        sleep(2)
        imagePath = saveImageLocally.imageURL()
        imageCollectionView.reloadData()
        searchBar.endEditing(true)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size : CGSize = CGSize(width: 0, height: 0)
        if defaultDisplayCells == 2{
            size = CGSize(width: 195, height: 195)
        }
        if defaultDisplayCells == 3{
            size = CGSize(width: 130, height: 130)
        }
        if defaultDisplayCells == 4{
            size = CGSize(width: 97, height: 97)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageViewerViewController = ImageViewerViewController()
        imageViewerViewController.imagePath = imagePath[indexPath.row].path
        navigationController?.pushViewController(imageViewerViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = imageCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    //Load more data after reaching limit of 30 images
    func loadMoreData() {
        
        if !self.isLoading {
            self.isLoading = true
            self.pageNumber = self.pageNumber + 1
            self.saveImageLocally.parseData(pageNumber: self.pageNumber)
            
            DispatchQueue.global().async {
                sleep(3)
                DispatchQueue.main.async {
                    self.imagePath = self.saveImageLocally.imageURL()
                    self.imageCollectionView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
    //Bar buttom settings option to change settings
    @objc func barButton(){
        let fooViewController = AppSettingsViewController()
        navigationController?.pushViewController(fooViewController, animated: true)
    }
    
}
