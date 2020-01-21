//
//  CompetitionNextViewController.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 06/11/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class CompetitionNextViewController: UIViewController {
    
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var btnCheckBox1:UIButton!
    @IBOutlet weak var btnCheckBox2:UIButton!
    @IBOutlet weak var btnCheckBox3:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnCheckBox1.setImage(UIImage(named:"icon-5"), for: .normal)
        btnCheckBox1.setImage(UIImage(named:"icon-1"), for: .selected)
        
        btnCheckBox2.setImage(UIImage(named:"icon-5"), for: .normal)
        btnCheckBox2.setImage(UIImage(named:"icon-1"), for: .selected)
        
        btnCheckBox3.setImage(UIImage(named:"icon-5"), for: .normal)
        btnCheckBox3.setImage(UIImage(named:"icon-5"), for: .selected)
        
        
         self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins", size: 20)!]
        
    }
    

  @IBAction func checkMarkTapped(_ sender: UIButton) {
    
    
    UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
        sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }) { (success) in
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.isSelected = !sender.isSelected
            sender.transform = .identity
        }, completion: nil)
    }
    
    
     }
    
    
    
    
    @IBAction func PREVIOUS_BUTTON(_ sender: Any) {
       }
       
       
       @IBAction func NEXT_BUTTON_CLICK(_ sender: Any) {
           
           
           
       }
       
    
    
    
    

}
