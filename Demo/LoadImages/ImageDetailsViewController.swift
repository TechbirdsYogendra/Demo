//
//  ImageDetailsViewController.swift
//  Demo
//
//  Created by Yogendra on 7/16/18.
//  Copyright © 2018 Yogendra Singh. All rights reserved.
//

import UIKit

class ImageDetailsViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        return []
    }
    
//    override var previewActionItems() -> [UIPreviewActionItem] {
//        let showAction = UIPreviewAction(title: "Show", style: .Default) { [weak self] (action: UIPreviewAction, vc: UIViewController) -> Void in
//            guard let weakSelf = self else {
//                return;
//            }
//
//            if let _popAction = weakSelf.popAction {
//                _popAction()
//            }
//            self?.showViewController(vc, sender: nil)
//            print("show city controller")
//        }
//        let cityController = CityController()
//        cityController.showPreviewController()
//        return [showAction]
//    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
    }
    
   
    

    
}
