//
//  ConfirmEmailAddress.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 12/11/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import QuartzCore
import Kingfisher
import IQKeyboardManagerSwift

class ConfirmEmailAddress: UIViewController,UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate {

    
      @IBOutlet weak var mycall: UITableView!
    
    var data1 = NSArray()
    var selectedIndex=[Int] ()
    var selectedIndexPath: IndexPath?
    var numberOfItemsPerRow : Int = 1
    var dataSource:[String]?
    var dataSourceForSearchResult:[String]?
    var searchBarActive:Bool = false
    var searchBarBoundsY:CGFloat?
    var refreshControl:UIRefreshControl?
    var cellWidth:CGFloat
    {
        return mycall.frame.size.width/2
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mycall.dataSource = self
        mycall.delegate = self
        self.mycall.allowsMultipleSelection = true
        
         let user_id = UserDefaults.standard.string(forKey: USER_ID) ?? ""
      
        let passwordTF = UserDefaults.standard.string(forKey: USER_PASSWORD)
        
        let user_name = UserDefaults.standard.string(forKey: USER_NAME) ?? ""
        let user_email = UserDefaults.standard.string(forKey: USER_EMAIL) ?? ""
         
         
        let comment: [String:AnyObject] = [
               
               "username": user_name as AnyObject,
               "password": passwordTF as AnyObject,
               "device_id":"1211" as AnyObject ,
               "deviceName": "ios" as AnyObject ]
         
        print("SEND DATA ", comment)
           
           getBitcoinData(url: "https://musicworldcupdevelopment.com/Apps/login",comment: comment)
         
        }

   
    var arr_val = Array<Int>()
       
       func getBitcoinData(url: String,comment: [String:AnyObject]) {
           SVProgressHUD.show()
           
           
           Alamofire.request(url, method: .post, parameters: comment)
               .responseData
               { response in
                   
                   print(response)
                   print("****************** 1 **************")
                   if response.result.isSuccess
                   {
                       
                       do {
                           let weatherJSON =  try JSONSerialization.jsonObject(with: response.data! , options: []) as? [String: Any]
                           
                           
                           print("****************** 2 **************")
                           SVProgressHUD.dismiss()
                           print("Sucess! Got the weather data")
                           print("****************** 3 **************")
                           print(weatherJSON)
                           print("****************** 4 **************")
                           self.data1 = weatherJSON?["suggestions"] as! NSArray
                        
                       // self.data1 = weatherJSON as! NSArray
                           DispatchQueue.main.async{
                               self.mycall.reloadData()
                           }
                           
                           
                       } catch let myJSONError {
                           print(myJSONError)
                       }
                   }
                   else
                   {
                       SVProgressHUD.dismiss();
                       print("Error: \(String(describing: response.result.error))")
                       
                   }
           }
       }
    
       func jsonToString(json: AnyObject)-> String{
           do {
               let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
               let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
               
               return (convertedString ?? "defaultvalue")
           } catch let myJSONError {
               print(myJSONError)
           }
           return ""
       }
    
    
    
    
    
    
    
    
    
    
    
    
    
    ///////////////////////// /////////////////////////  /////////////////////////  /////////////////////////  /////////////////////////  /////////////////////////
         /////////////////////////           TABLE VIEW CONTROLLER  CODE       //////////////////////////////////////////////
      
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return data1.count
      }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let suggestions_list = data1.object(at: indexPath.row) as! NSDictionary
    
            
        let cell:SuggestedCELLS = tableView.dequeueReusableCell(withIdentifier: "SuggestedCELLS", for: indexPath as IndexPath) as! SuggestedCELLS
            
            
        cell.contentView.layer.cornerRadius = 0.0
        cell.contentView.layer.borderWidth = 0.0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 0.0
        cell.layer.masksToBounds = true
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
    
        
            cell.name.text  = suggestions_list.value(forKey: "name") as? String
            cell.username.text  = suggestions_list.value(forKey: "username") as? String
            cell.tittle.text  = suggestions_list.value(forKey: "bio") as? String
                    
        let profile_pic = suggestions_list.value(forKey: "profile_pic") as? String
        
          var string1 = "https://dtyaxcg60g9n4.cloudfront.net/"
        
           string1 += profile_pic ?? ""
        
        cell.profile_pic.sd_setImage(with: URL(string:string1 ), placeholderImage: UIImage(named: "playerImage"))
        
        cell.profile_pic.layer.cornerRadius = cell.profile_pic.frame.size.width / 2;
           cell.profile_pic.clipsToBounds = true ;
            
                     
                 return cell
         
                
            
        }
          
    
    
    
    
    
    
}
