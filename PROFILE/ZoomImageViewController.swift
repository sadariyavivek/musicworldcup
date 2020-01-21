//
//  ZoomImageViewController.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 25/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import AlamofireImage



class ZoomImageViewController:  UIViewController {
    var urlStr: String?
    @IBOutlet weak var ProfileImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
fileprivate func setupUI() {
    
    guard let urlImage = urlStr else { return }
    
    ProfileImg.downloadImageFromSS(link: urlImage,
                                       contentMode: UIView.ContentMode.scaleAspectFill)
    
}

}
extension UIImageView {
    
    func downloadImageFromSS(link:String, contentMode: UIView.ContentMode) {
        
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            
            (data, response, error) -> Void in
            
            DispatchQueue.main.async {
                
                self.contentMode =  contentMode
                
                if let data = data { self.image = UIImage(data: data) }
                
            }
            
        }).resume()
        
    }
    
}
