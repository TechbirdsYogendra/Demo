//
//  LoginViewController.swift
//  Demo
//
//  Created by Yogendra on 7/10/18.
//  Copyright © 2018 Yogendra Singh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK:- @IBOutlets.
    @IBOutlet weak var buzableImageView: BuzzableImageView!
    @IBOutlet weak var buzzableTextField: BuzzableTextField!
    @IBOutlet weak var buzzablePopableLabel: BuzzablePopableLabel!
    @IBOutlet weak var buzzableButton: BuzzableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCornerRadius()
    
    }
    
    
    
    @IBAction func loginButtonPressed(_ sender: BuzzableButton) {
        
        self.buzzableButton.buzz()
        self.buzableImageView.buzz()
        self.buzzableTextField.buzz()
        self.buzzablePopableLabel.buzz()
        self.buzzablePopableLabel.pop()
        
    }
    
    func setUpCornerRadius() {
        
        let imageHeight = buzableImageView.frame.height/2
        buzableImageView.layer.cornerRadius = imageHeight
        buzableImageView.layer.masksToBounds = true
        
    }
    


}
