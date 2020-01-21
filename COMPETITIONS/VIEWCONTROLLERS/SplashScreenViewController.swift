//
//  SplashScreenViewController.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 07/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit
import MediaPlayer

class SplashScreenViewController: UIViewController {
    
    

    @IBOutlet weak var label: UILabel!
    @IBOutlet var VIEW : UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "musicimg.png")
        backgroundImage.contentMode = UIView.ContentMode.bottomLeft
        self.VIEW.insertSubview(backgroundImage, at: 0)
        
    }
    

    
    
//
//    @IBAction func SIGNIN(_ sender: UIButton) {
//
//        let myVC = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
//        //self.present(myVC, animated: true)
//        self.navigationController?.pushViewController(myVC, animated: false)
//
//
//    }
//
//
//
//
//
//
//    @IBAction func SIGNUP(_ sender: UIButton) {
//
//        let myVC = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
//               //self.present(myVC, animated: true)
//               self.navigationController?.pushViewController(myVC, animated: false)
//
//
//
//    }
//
//
    
    
    
   
}



