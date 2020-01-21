//
//  ProfileCells.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 31/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class ProfileCells: UITableViewCell {
    
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var name: UILabel!
  
     @IBOutlet weak var profile_pic: UIImageView!
     @IBOutlet weak var followButton: UIButton!
    
     var actionBlock: (()-> Void)? = nil
     public var indexPath:IndexPath!
    
    

     override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    @IBAction func FOLLOW_BUTTON_TAPPED(_ sender: Any) {
              
              actionBlock?()
              
              
          }
          
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
