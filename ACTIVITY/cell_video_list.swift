//
//  cell_video_list.swift
//  MusicAppWorld
//
//  Created by Vivek Sadariya on 19/12/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class cell_video_list: UITableViewCell {

    @IBOutlet weak var cnst_img_flag_left: NSLayoutConstraint!
    @IBOutlet weak var cnst_img_w: NSLayoutConstraint!
    @IBOutlet weak var img_flag: UIImageView!
    @IBOutlet var cnst_width_square: NSLayoutConstraint!
    @IBOutlet var cnst_width_rectangle: NSLayoutConstraint!
    @IBOutlet weak var lbl_cnt_share: UILabel!
    @IBOutlet weak var lbl_cnt_play: UILabel!
    @IBOutlet weak var lbl_cnt_cmt: UILabel!
    @IBOutlet weak var lbl_cnt_fav: UILabel!
    @IBOutlet weak var lbl_usrnm: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
