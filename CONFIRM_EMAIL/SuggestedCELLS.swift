//
//  SuggestedCELLS.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 12/11/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class SuggestedCELLS: UITableViewCell {
    
         
         @IBOutlet weak var name: UILabel!
         @IBOutlet weak var username: UILabel!
         @IBOutlet weak var tittle: UILabel!
         @IBOutlet weak var profile_pic: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
