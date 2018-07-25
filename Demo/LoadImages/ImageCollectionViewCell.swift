//
//  ImageCollectionViewCell.swift
//  Demo
//
//  Created by Yogendra on 7/9/18.
//  Copyright © 2018 Yogendra Singh. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
}

extension UIImageView {
    
    func imageFromServer(url: String) {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                if let data = data {
                    self.image = UIImage(data: data)
                }
            }
            }.resume()
    }
}
