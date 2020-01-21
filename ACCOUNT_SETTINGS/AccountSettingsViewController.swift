//
//  AccountSettingsViewController.swift
//  MusicAppWorld
//
//  Created by shikha on 04/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class AccountSettingsViewController: UIViewController {
    
      @IBOutlet weak var swiftySwitch1: SwiftySwitch!
      @IBOutlet weak var EditProfile: UIButton!
      @IBOutlet weak var ChangePassword: UIButton!
      @IBOutlet weak var language: UIButton!
      @IBOutlet weak var notification: UIButton!
      @IBOutlet weak var privateAccount: UIButton!
      @IBOutlet weak var aboutUs: UIButton!
      @IBOutlet weak var help: UIButton!
      @IBOutlet weak var provideFeedback: UIButton!
    
      @IBOutlet weak var Edit_button: UIButton!
      @IBOutlet weak var ChangePassword_button: UIButton!
      @IBOutlet weak var language_button: UIButton!
      @IBOutlet weak var notification_button: UIButton!
      @IBOutlet weak var aboutUs_button: UIButton!
      @IBOutlet weak var help_button: UIButton!
      @IBOutlet weak var provideFeedback_button: UIButton!
    
    
          override func viewDidLoad() {
              super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
         
         
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins", size: 20)!]

        let switchArray = [ swiftySwitch1 ]
                    
    
}

    func valueChanged(sender: SwiftySwitch) {
        if sender.isOn {
            //code when switch is turned on
            print("SwiftySwitch \(sender.tag) turned on! :)")
        } else {
            //code when switch is turned off
            print("SwiftySwitch \(sender.tag)  turned off! :(")
        }
    }

    
    @IBAction func BACK_CLICK_BUTTON(_ sender: Any) {
           
            self.navigationController?.popViewController(animated: true)
         }
    
    
    
    
    
    @IBAction func EditbtnClick(_ sender: Any) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
                self.navigationController?.pushViewController(myVC, animated: true)
        
        
        
        
        
    }
    
    
    @IBAction func ChangePsdClick(_ sender: Any) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ChangePassword") as! ChangePassword
                self.navigationController?.pushViewController(myVC, animated: true)
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    

}
