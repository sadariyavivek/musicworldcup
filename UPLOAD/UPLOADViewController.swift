//
//  UPLOADViewController.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 20/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class UPLOADViewController: BaseViewController {
    
    
    @IBOutlet weak var viewVideo: UIView!
    var videoURL : URL?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addSlideMenuButton() // SIDE MENU BAR OPEN

        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins", size: 20)!]
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
         if (UIApplication.shared.delegate as! AppDelegate).view_player.isPresent{
             (UIApplication.shared.delegate as! AppDelegate).view_player.isHidden = false
         }
     }
    
    
    
    
    


    @IBAction func AudioOrVideoUPLOAD(_ sender: Any) {
        
        
        
        
        
              let refreshAlert = UIAlertController(title: "Upload File", message: "Choose Your Option", preferredStyle: UIAlertController.Style.alert)
              
              refreshAlert.addAction(UIAlertAction(title: "Audio", style: .default, handler: { (action: UIAlertAction!) in
                  
                  
                  
              }))
              
              refreshAlert.addAction(UIAlertAction(title: "Video", style: .cancel, handler: { (action: UIAlertAction!) in
                  
                  
                  ///////GALLERY
                  
                  
                  
                   
                  
              }))
              
              present(refreshAlert, animated: true, completion: nil)
              
        
        
    }
    
    
    
    
    
}








