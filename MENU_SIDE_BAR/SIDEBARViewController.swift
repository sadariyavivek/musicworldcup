//
//  SIDEBARViewController.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 01/11/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class SIDEBARViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.navigationController?.navigationBar.isHidden = true
       
    }
    

   
    
    
   @IBAction func ACTIVITY_PAGE_CLICK(_ sender: Any) {
        
     
    
        
         let myVC = storyboard?.instantiateViewController(withIdentifier: "ACTIVITYViewControllerSSS") as! ACTIVITYViewControllerSSS
           self.present(myVC, animated: true)
                      
     //   self.navigationController?.pushViewController(myVC, animated: true)
        
        
    }
    
    
    @IBAction func PROFILEE_CLICK(_ sender: Any) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ProfilePhotoDetailsViewController") as! ProfilePhotoDetailsViewController
       self.present(myVC, animated: true)
       //  self.navigationController?.pushViewController(myVC, animated: true)
    }
    
    
    
    @IBAction func COMPETITION_CLICK(_ sender: Any) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ACTIVITYViewControllerSSS") as! ACTIVITYViewControllerSSS
        self.present(myVC, animated: true)
    }
    
   
    
    @IBAction func MESSAGES_CLICK(_ sender: Any) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ACTIVITYViewControllerSSS") as! ACTIVITYViewControllerSSS
        self.present(myVC, animated: true)
    }
    
    
    @IBAction func FAVOURITE_CLICK(_ sender: Any) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ACTIVITYViewControllerSSS") as! ACTIVITYViewControllerSSS
        self.present(myVC, animated: true)
       //  self.navigationController?.pushViewController(myVC, animated: true)
    }
        
    
    
    
    @IBAction func SHOP_CLICK(_ sender: Any) {
           
           let myVC = storyboard?.instantiateViewController(withIdentifier: "ACTIVITYViewControllerSSS") as! ACTIVITYViewControllerSSS
           self.present(myVC, animated: true)
       }
       
       
       @IBAction func ANALYTICS_CLICK(_ sender: Any) {
           
           let myVC = storyboard?.instantiateViewController(withIdentifier: "ACTIVITYViewControllerSSS") as! ACTIVITYViewControllerSSS
            self.navigationController?.pushViewController(myVC, animated: true)
       }
           
    
    
    @IBAction func ACCOUNT_CLICK(_ sender: Any) {
              
              let myVC = storyboard?.instantiateViewController(withIdentifier: "ACTIVITYViewControllerSSS") as! ACTIVITYViewControllerSSS
              self.present(myVC, animated: true)
          }
          
          
          @IBAction func CENTERS_CLICK(_ sender: Any) {
              
              let myVC = storyboard?.instantiateViewController(withIdentifier: "ACTIVITYViewControllerSSS") as! ACTIVITYViewControllerSSS
               self.navigationController?.pushViewController(myVC, animated: true)
          }
              
    
    
    
    
    
    
    
    
}
