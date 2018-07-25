                    //
//  LoadImagesViewController.swift
//  Demo
//
//  Created by Yogendra on 7/9/18.
//  Copyright © 2018 Yogendra Singh. All rights reserved.
//

import UIKit

class LoadImagesViewController: UIViewController {

    //MARK:- @IBOutlets
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    //MARK:- @Properties
    var allPhotos = [Photo]()
    let webServiceHandler = WebServiceHandler()
    let dispatchGroup = DispatchGroup()
    var allUsers = [[String: Any]]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.getAllImages()
        }
     
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
       
    }
   
    
    func getAllImages() {
        
       let url = "https://jsonplaceholder.typicode.com/photos"
        //"https://reqres.in/api/users?page=2"
        
       URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
        
        if let data = data {
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                    print(json)
                    // handle json...
                    for photo in json {
                        let photoObj = Photo.init(id: photo["id"] as! Int, thumbnailUrl: photo["thumbnailUrl"] as! String, url: photo["url"] as! String, title: photo["title"] as! String)
                        self.allPhotos.append(photoObj)
                    }
                    DispatchQueue.main.async {
                        self.imageCollectionView.reloadData()
                    }
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        }.resume()
    }
    
  
 
    func dispatchMultipleRequest() {
        
        for index in 1...4 {
            dispatchGroup.enter()
            let urlString = "https://reqres.in/" + "api/users?page=\(index)"
            self.webServiceHandler.hitGetRequestWith(urlString: urlString) { (response, error) in
                if let response = response {
                    if let data = response["data"] as? [[String: Any]] {
                        for user in data {
                            self.allUsers.append(user)
                        }
                    }
                }
                self.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .global()) {
            print("Task1 Completed")
            
            for index in 1...4 {
                self.dispatchGroup.enter()
                let urlString = "https://reqres.in/" + "api/users?page=\(index)"
                self.webServiceHandler.hitGetRequestWith(urlString: urlString) { (response, error) in
                    if let response = response {
                        if let data = response["data"] as? [[String: Any]] {
                            for user in data {
                                self.allUsers.append(user)
                            }
                        }
                    }
                    self.dispatchGroup.leave()
                }
            }
            
            self.dispatchGroup.notify(queue: .global()) {
                
                print("Task2 Completed")
                for index in 1...4 {
                    self.dispatchGroup.enter()
                    let urlString = "https://reqres.in/" + "api/users?page=\(index)"
                    self.webServiceHandler.hitGetRequestWith(urlString: urlString) { (response, error) in
                        if let response = response {
                            if let data = response["data"] as? [[String: Any]] {
                                for user in data {
                                    self.allUsers.append(user)
                                }
                            }
                        }
                        self.dispatchGroup.leave()
                    }
                }
                
                self.dispatchGroup.notify(queue: .global()) {
                    print("Task3 Completed")
                    print("\(self.allUsers.count) users:-\(self.allUsers)")
                }
            }
        }
    }
    
    
 
}

//MARK:- UICollectionViewDataSource
extension LoadImagesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.backgroundColor = UIColor.green
        //cell.imageView.imageFromServer(url: allPhotos[indexPath.row].thumbnailUrl)
        TaskManager.shared.dataTask(with: URL(string: allPhotos[indexPath.row].thumbnailUrl)!) { (data, response, error) in
            if let data = data {
               cell.imageView.image = UIImage(data: data)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.width/3
        return CGSize(width: height, height: height)
    }
 
}
//MARK:- UIViewControllerPreviewingDelegate
extension LoadImagesViewController: UIViewControllerPreviewingDelegate{
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = imageCollectionView?.indexPathForItem(at: location) else { return nil }
        guard let cell = imageCollectionView?.cellForItem(at: indexPath) as? ImageCollectionViewCell else { return nil }
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "ImageDetailsViewController") as? ImageDetailsViewController else { return nil }
       // detailVC.imageView.image = cell.imageView.image
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
        previewingContext.sourceRect = cell.frame
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
