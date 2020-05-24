//
//  SaveImageLocally.swift
//  ekanek-assignment
//
//  Created by Mrinal Maheshwari on 22/05/20.
//  Copyright © 2020 Mrinal Maheshwari. All rights reserved.
//

import UIKit
import SystemConfiguration


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

class SaveImageLocally{
    
    var searchValue : String = ""
    var imageNumbering = 0

    //Check application and Directory states
    func checkState(pageNumber : Int){
        if totalValuesAvailable() == 0 && isConnectedToNetwork() == true
        {
            parseData(pageNumber: pageNumber)
        }else if totalValuesAvailable() > 0 && isConnectedToNetwork() == true
        {
            parseData(pageNumber: pageNumber)
        }else if totalValuesAvailable() > 0 && isConnectedToNetwork() == false
        {
            
        }
    }
    
    //Parse data from API in JSON format
    func parseData(pageNumber: Int){
        if let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=8d3827adfd94d09a720226ece2074c5a&format=json&text=\(searchValue)&nojsoncallback=true&per_page=30&page=\(pageNumber)") {
                URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(Welcome.self, from: data)
                        for i in 0..<30{
//                            print("https://farm\(res.photos.photo[i].farm).staticflickr.com/\(res.photos.photo[i].server)/\(res.photos.photo[i].id)_\(res.photos.photo[i].secret).jpg")
                            self.downloadImage( urlString: "https://farm\(res.photos.photo[i].farm).staticflickr.com/\(res.photos.photo[i].server)/\(res.photos.photo[i].id)_\(res.photos.photo[i].secret).jpg", id: res.photos.photo[i].id)
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    //Download images from URL passed
    func downloadImage(urlString: String, id: String){
        let url = URL(string: urlString)!
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            self.saveImage(image: UIImage(data: data)!, imageName: "hello", id: id)
        }
    }
    
    //Save image in directory
    func saveImage(image: UIImage, imageName: String, id: String){
        
        do {
            let fileManager = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(searchValue)")
            
            //Create directory with name of search if does not exist
            if !FileManager.default.fileExists(atPath: fileManager.absoluteString){
                try FileManager.default.createDirectory(at: fileManager, withIntermediateDirectories: true, attributes: nil)
            }
            let imageUrl = fileManager.appendingPathComponent("\(imageName)_\(id).jpg", isDirectory: true)
            if !FileManager.default.fileExists(atPath: imageUrl.path){
                do {
                    try image.jpegData(compressionQuality: 0.5)?.write(to: imageUrl)
                } catch {
                    print(error.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    //Check for total Sub Directories available in system directory
    func totalValuesAvailable() -> Int{
        var fileUrl : [URL] = []
        do {
            fileUrl = try FileManager.default.contentsOfDirectory(at: FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(searchValue)"), includingPropertiesForKeys: nil)
        } catch {
            return fileUrl.count
        }
//        print(fileUrl)
        return fileUrl.count - 1
    }

    //Returns Array of URL which contain image path
    func imageURL() -> [URL]{
        var fileUrl : [URL] = []
        do {
            fileUrl = try FileManager.default.contentsOfDirectory(at: FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(searchValue)"), includingPropertiesForKeys: nil)
        } catch {
            print(error.localizedDescription)
            return fileUrl
        }
        return fileUrl
    }
    
    //Check internet connectivity
    public func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }

    //Clear all folder and documents in system directory
    func clearAllFilesFromTempDirectory(){

        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            try FileManager.default.removeItem(at: documentsUrl)
        } catch  { print(error.localizedDescription) }
    }
}
