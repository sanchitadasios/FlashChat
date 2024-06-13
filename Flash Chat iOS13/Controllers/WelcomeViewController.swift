//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        navigationController?.isNavigationBarHidden = false
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = K.appName
//        var charIndex = 0.0
//        let titletext = "⚡️FlashChat"
//        for letter in titletext{
//            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { timer in
//                self.titleLabel.text?.append(letter)
//            }
//            charIndex += 1
//        }

       
    }
    

}
