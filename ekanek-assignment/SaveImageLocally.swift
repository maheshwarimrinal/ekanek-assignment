//
//  SaveImageLocally.swift
//  ekanek-assignment
//
//  Created by Mrinal Maheshwari on 22/05/20.
//  Copyright © 2020 Mrinal Maheshwari. All rights reserved.
//

import UIKit
import Foundation

func downloadImage(urlString: String){
    print(urlString)
    let url = URL(string: urlString)!
    getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        print(response?.suggestedFilename ?? url.lastPathComponent)
        print("Download Finished")
        saveImage(image: UIImage(data: data)!, imageName: "hello", searchValue: "hello")
        DispatchQueue.main.async() {
//            self?.imageView.image = UIImage(data: data)
        }
    }
}

func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}

func saveImage(image: UIImage, imageName: String, searchValue: String){
    
    let fileManager = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(searchValue)")
    
    //Create directory with name of search if does not exist
    if !FileManager.default.fileExists(atPath: fileManager.absoluteString){
        try! FileManager.default.createDirectory(at: fileManager, withIntermediateDirectories: true, attributes: nil)
    }
    
    let imageUrl = fileManager.appendingPathComponent("\(imageName)19.jpg", isDirectory: true)
    print(imageUrl.path)

//    do {
//        let fileURLs = try FileManager.default.contentsOfDirectory(at: fileManager, includingPropertiesForKeys: nil)
//        print(fileURLs.count)
//    } catch {
//    }
    
    if !FileManager.default.fileExists(atPath: imageUrl.path){
        do {
            try image.jpegData(compressionQuality: 0.5)?.write(to: imageUrl)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
