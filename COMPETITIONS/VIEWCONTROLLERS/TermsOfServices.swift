//
//  TermsOfServices.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 11/11/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class TermsOfServices: UIViewController {
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var TermsandServicestextviews : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

    //   TermsandServicestextviews.font = UIFont(name: "Poppins Regular", size: 16)
        
        
        
    }
    

    

}
