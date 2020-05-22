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

//extension SearchViewController : UICollectionViewFlowLayout{
//}

class SearchViewController: UIViewController{
    
    var isLoading : Bool = false
    var numberOfItemsPerSection = 30
    
    func updateSearchResults(for searchController: UISearchController) {
        print("\(searchController.searchBar.text ?? "")")
    }
    
    
    var search = UISearchController(searchResultsController: nil)
    
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
        collectionViewFlowLayout.invalidateLayout()
        
        let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCollectionViewCell")
//        imageCollectionView.isScrollEnabled = false
//        imageCollectionView.contentInset = UIEdgeInsets(top: -2, left: -2, bottom: -2, right: -2)
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageCollectionView
    }()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.searchController = search
        
        search.searchResultsUpdater = self
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageCollectionView)
        parseJSON()
        setLayout()
    }
    
    func setLayout(){
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.trailingAnchor),
            
            imageCollectionView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageCollectionView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10)
            
        ])
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(searchText)lkag;lksh")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("----\(String(describing: searchBar.text))")
    }
    
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating, UISearchBarDelegate{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsPerSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        collectionViewCell.imageView.backgroundColor = .green
        collectionViewCell.imageView.text = "\(indexPath.row)"
        return collectionViewCell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == numberOfItemsPerSection - 1 && !self.isLoading{
            loadMoreData()
        }
    }

    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            numberOfItemsPerSection = numberOfItemsPerSection + 30
            DispatchQueue.global().async {
                // fake background loading task
                sleep(2)
                self.parseJSON()
                DispatchQueue.main.async {
                    self.imageCollectionView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }

    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        if self.isLoading {
//            return CGSize.zero
//        } else {
//            return CGSize(width: collectionView.bounds.size.width, height: 55)
//        }
//    }

//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionView.elementKindSectionFooter {
//            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
//            loadingView = aFooterView
//            loadingView?.backgroundColor = UIColor.clear
//            return aFooterView
//        }
//        return UICollectionReusableView()
//    }

//    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//        if elementKind == UICollectionView.elementKindSectionFooter {
//            self.loadingView?.activityIndicator.startAnimating()
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
//        if elementKind == UICollectionView.elementKindSectionFooter {
//            self.loadingView?.activityIndicator.stopAnimating()
//        }
//    }

}
