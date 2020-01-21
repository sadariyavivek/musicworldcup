//
//  CompetitionRulesViewController.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 15/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class CompetitionRulesViewController: BaseViewController {
    
    
   @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var btnCheckBox1:UIButton!
    @IBOutlet weak var btnCheckBox2:UIButton!
    @IBOutlet weak var btnCheckBox3:UIButton!
    
    var state = "OFF";
    
     @IBOutlet weak var CHECK_BOX_BUTTON_CONDITION: CheckboxButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton() // SIDE MENU BAR OPEN
         self.navigationController?.navigationBar.isHidden = false
        
         self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins", size: 20)!]
        
      roundView.layer.cornerRadius = 10.0
        
     CHECK_BOX_BUTTON_CONDITION.layer.borderWidth = 1
     CHECK_BOX_BUTTON_CONDITION.layer.borderColor = UIColor.lightGray.cgColor
    
     
    }
    override func viewWillAppear(_ animated: Bool) {
         if (UIApplication.shared.delegate as! AppDelegate).view_player.isPresent{
             (UIApplication.shared.delegate as! AppDelegate).view_player.isHidden = false
         }
     }

    @IBAction func didToggleCheckboxButton(_ sender: CheckboxButton) {
            state = sender.on ? "ON" : "OFF"

           print("CheckboxButton: did turn \(state)")
       }
    
    
    
    @IBAction func PREVIOUS_BUTTON(_ sender: Any) {
        
        
    }
    
    
    @IBAction func NEXT_BUTTON_CLICK(_ sender: Any) {
        
        
        
    }
    
    

   

}
