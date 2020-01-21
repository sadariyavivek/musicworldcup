//
//  ViewController.swift
//  MusicAppWorld
//
//  Created by Shikha on 03/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class ViewController: AMPagerTabsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //    self.setNavigationItem()
        
        settings.tabBackgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        settings.tabButtonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings.tabButtonselectedTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

         
        tabFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        self.viewControllers = getTabs()
        
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
       // self.navigationController?.navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 80.0)
        self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200.0)
        // 1
        let nav = self.navigationController?.navigationBar

        // 2
     //   nav?.barStyle = UIBarStyle.clear
        nav?.tintColor = UIColor.white

        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        imageView.contentMode = .scaleAspectFit

        // 4
        let image = UIImage(named: "music world cup")
        imageView.image = image

        // 5
        navigationItem.titleView = imageView
    }

    
    
      func getTabs() -> [UIViewController] {
        
    
        let SignInViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController")
       
        let SignUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
      
        SignInViewController?.title = "Sign In"
        SignUpViewController?.title = "Sign Up"
       
        return [SignInViewController!,SignUpViewController!]
        
        
    }
    
}



///////////////////////////////////////////////////////// ///////////////////// //////////////////////////////////////////////////////////////////////////////////////////// ///////////////////// //////////////////////////////////////////////////////////////////////////////////////////// ///////////////////// ///////////////////////////////////
////////////////////////////////////////////////////////// ///////////////////// //////////////////////////////////////////////////////////////////////////////////////////// ///////////////////// //////////////////////////////////////////////////////////////////////////////////////////// ///////////////////// ///////////////////////////////////


