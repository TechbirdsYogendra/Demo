//
//  CreateBmojiViewController.swift
//  Demo
//
//  Created by Yogendra on 7/13/18.
//  Copyright © 2018 Yogendra Singh. All rights reserved.
//

import UIKit


struct ExpressionsImages {
    let abuse = #imageLiteral(resourceName: "abuse")
    let hand = #imageLiteral(resourceName: "hand")
    let facepack = #imageLiteral(resourceName: "facepack")
    let star = #imageLiteral(resourceName: "star")
}

class CreateBmojiViewController: UIViewController {

    //MARK:-@IBOutlets
    
    @IBOutlet weak var createdEmojisCollectionView: UICollectionView!
    @IBOutlet weak var basicMojiImageView: UIImageView!
    
    
    //MARK:- @Varibles
    var createdBimojis = [UIImage]()
    var expressions = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let expressionImages = ExpressionsImages.init()
        expressions.append(expressionImages.abuse)
        expressions.append(expressionImages.hand)
        expressions.append(expressionImages.facepack)
        expressions.append(expressionImages.star)
        
    }
    
    func createBemojiAndReloadCollectionView() {
        
        createdBimojis.removeAll()
        for expressionImage in expressions {
            let image = mergeImages(topImage: expressionImage, bottomImage: #imageLiteral(resourceName: "BasicBmoji"))
            createdBimojis.append(image)
            createdEmojisCollectionView.reloadData()
        }
    }
    
    func mergeImages(topImage: UIImage, bottomImage: UIImage) -> UIImage {
        
        let bottomImageSize = CGSize(width: 300, height: 300)
        UIGraphicsBeginImageContext(bottomImageSize)
        let bottomImageRect = CGRect(x: 0, y: 0, width: bottomImageSize.width, height: bottomImageSize.height)
        bottomImage.draw(in: bottomImageRect)
        
        let topImageSize = CGSize(width: 300, height: 300)
        let topImageRect = CGRect(x: 0, y: 0, width: topImageSize.width, height: topImageSize.height)
        topImage.draw(in: topImageRect, blendMode: .normal, alpha: 1.0)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    @IBAction func generateBmojiButtonPressed(_ sender: UIButton) {
         createBemojiAndReloadCollectionView()
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        createdBimojis.removeAll()
        createdEmojisCollectionView.reloadData()
        basicMojiImageView.image = #imageLiteral(resourceName: "BasicBmoji")
    }
    
}

//MARK:- UICollectionViewDataSource
extension CreateBmojiViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.createdBimojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = createdBimojis[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.width/3
        return CGSize(width: height, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        basicMojiImageView.image = createdBimojis[indexPath.row]
    }
    
}

