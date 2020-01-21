//
//  CellTableViewCell.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 31/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class CellTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
       
       @IBOutlet weak var product: UILabel!
       
       @IBOutlet weak var expire: UILabel!
       
       @IBOutlet weak var amount: UILabel!
       
       
       
       override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
           
           
       }
       
       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
           // Configure the view for the selected state
       }

}
