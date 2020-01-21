//
//  ProfilePhotoDetailViewController.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 31/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import QuartzCore
import Kingfisher
import IQKeyboardManagerSwift

class ProfilePhotoDetailsViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate{
    
    
    
    @IBOutlet weak var bioDetailProfile: UILabel!
    @IBOutlet weak var cover_profile_imv: UIImageView!
    @IBOutlet weak var ProfileImg: UIImageView!
    @IBOutlet weak var mycall: UITableView!
    @IBOutlet weak var NAMElabel: UILabel!
    @IBOutlet weak var USERNAMElabel: UILabel!
//    @IBOutlet weak var followersLbl: UIButton!
//    @IBOutlet weak var followingLbl: UIButton!
   
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    
    var data1 = NSArray()
    
    @IBAction func editButtonAction(_ sender: Any) {
   
   let myVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
   self.navigationController?.pushViewController(myVC, animated: true)
      
    }
    
    
   
       override func viewDidLoad() {
        super.viewDidLoad()
       
        addSlideMenuButton() // SIDE MENU BAR OPEN
    
        self.navigationController?.navigationBar.isHidden = false

        ProfileImg.layer.cornerRadius = ProfileImg.frame.size.width / 2 ;
        ProfileImg.clipsToBounds = true ;
    
        mycall.rowHeight = UITableView.automaticDimension
        mycall.estimatedRowHeight = UITableView.automaticDimension
    
        
    }
    
        override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(true)
            
            self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: "Poppins", size: 18)!]
            
            if (UIApplication.shared.delegate as! AppDelegate).view_player.isPresent{
                (UIApplication.shared.delegate as! AppDelegate).view_player.isHidden = false
            }
    
          self.initiateView()
         
     }

    
    func initiateView()  {
        
        let user_name = UserDefaults.standard.string(forKey: USER_NAME) ?? ""
        let user_email = UserDefaults.standard.string(forKey: USER_EMAIL) ?? ""
        let user_user_name = UserDefaults.standard.string(forKey: USER_USER_NAME) ?? ""
        let user_profile_pic = UserDefaults.standard.string(forKey: USER_PROFILE_PIC) ?? ""
        let user_profile_cover_pic = UserDefaults.standard.string(forKey: USER_COVER_PIC) ?? ""
        let user_bio_summary = UserDefaults.standard.string(forKey: USER_BIO_SUMMARY) ?? ""
        let user_phone = UserDefaults.standard.string(forKey: USER_PHONE) ?? ""
        let user_address = UserDefaults.standard.string(forKey: USER_ADDRESS) ?? ""
        let user_city_state = UserDefaults.standard.string(forKey: USER_CITY_STATE) ?? ""
        let user_zipcode = UserDefaults.standard.string(forKey: USER_ZIPCODE) ?? ""
        let user_country = UserDefaults.standard.string(forKey: USER_COUNTRY) ?? ""
        
      
         
         if  user_profile_pic != ""
          {
         
         }
         NAMElabel.text = user_name
         USERNAMElabel.text = "@" + user_user_name
         bioDetailProfile.text = user_bio_summary
        
         //let profile_pic = suggestions_list.value(forKey: "profile_pic") as? String
                
        var string1 = "https://dtyaxcg60g9n4.cloudfront.net/"
            string1 += user_profile_pic
                
        ProfileImg.sd_setImage(with: URL(string:string1 ), placeholderImage: UIImage(named: "playerImage"))
            var stringCover1 = "https://dtyaxcg60g9n4.cloudfront.net/"
            stringCover1 += user_profile_cover_pic
         
         cover_profile_imv.sd_setImage(with: URL(string:stringCover1 ), placeholderImage: UIImage(named: "playerImage"))
         
        let user_id = UserDefaults.standard.string(forKey: USER_ID) ?? ""
        let comment: [String:AnyObject] = ["user_id": user_id as AnyObject]
             getBitcoinData(url: "https://musicworldcupdevelopment.com/Apps/profile",comment: comment)
                
                   
    }
    
    func getBitcoinData(url: String,comment: [String:AnyObject]) {
               SVProgressHUD.show()
               
               Alamofire.request(url, method: .post, parameters: comment)
               .responseData
                   { response in
                    print(response)
                   print("********************************* 1 ******************************")
                   if response.result.isSuccess
                   {
                       
                       do {
                           let weatherJSON =  try JSONSerialization.jsonObject(with: response.data! , options: []) as? [String: Any]

                       
                       print("********************************* 2  ******************************")
                       SVProgressHUD.dismiss()
                       print("Sucess! Got the weather data")

                       print("********************************* 3 ******************************")
                       print(weatherJSON)
                       print("********************************* 4 ******************************")

                        self.data1 = weatherJSON?["suggestions_list"] as! NSArray
                        let followers = weatherJSON?["followers"] as! NSArray
                        let following = weatherJSON?["following"] as! NSArray
                        
                        let followersDic = followers.object(at: 0) as! NSDictionary
                        let followingDic = following.object(at: 0) as! NSDictionary
                        
                        let totalFollowing = followersDic.value(forKey: "followers") as? String
                        let totalFollowers = followingDic.value(forKey: "following") as? String
                        
//                        self.followingLbl.setTitle(totalFollowing ?? "", for:.normal )
//                        self.followersLbl.setTitle(totalFollowers ?? "", for:.normal )
                         self.followersLbl.text = (totalFollowers ?? "")
                         self.followingLbl.text = (totalFollowing ?? "")

                        self.mycall.reloadData()
                            
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
           



           func jsonToString(json: AnyObject)-> String {
               do {
                   let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                   let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                   
                   return (convertedString ?? "defaultvalue")
               } catch let myJSONError {
                   print(myJSONError)
               }
               return ""
           }



       func storeSharedValue(currentLevel: String, saveValue: String)
                 {
                     let preferences = UserDefaults.standard
                     
                     let currentLevelKey = currentLevel
                     
                     
                     //        // store string value
                     preferences.set(saveValue, forKey: currentLevelKey)
                     //
                     //        //  Save to disk
                     let didSave = preferences.synchronize()
                     //
                     if !didSave {
                         //  Couldn't save (I've never seen this happen in real world testing)
                     }
                 }
                 
                 
                 func retriveSharedValue(currentLevel: String)->String
                 {
                     let preferences = UserDefaults.standard
                     
                     let currentLevelKey = currentLevel
                     
                     if preferences.object(forKey: currentLevelKey) == nil {
                         //  Doesn't exist
                     } else {
                         
                         
                         return preferences.object(forKey: currentLevelKey) as! String
                         
                         
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
            
            
        let cell:ProfileCells = tableView.dequeueReusableCell(withIdentifier: "ProfileCells", for: indexPath as IndexPath) as! ProfileCells
            
            
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
        
            cell.actionBlock = {
            //cell.followButton.setTitle("FOLLOWING", for:.normal)
                
            let user_id = UserDefaults.standard.string(forKey: USER_ID) ?? ""
                     
                
          //////////////////////////////////////////////////////////////////////////////////
                
            let comment: [String:AnyObject] = [
                                               
                "followingid": suggestions_list.value(forKey: "user_id") as? String as AnyObject ,
                "followerid": user_id as AnyObject ]
                                           
    self.GetFollowData(url: "https://musicworldcupdevelopment.com/Apps/addfollowers",comment: comment)
        }
          
        
        let profile_pic = suggestions_list.value(forKey: "profile_pic") as? String
        
          var string1 = "https://dtyaxcg60g9n4.cloudfront.net/"
        
           string1 += profile_pic ?? ""
        
        cell.profile_pic.sd_setImage(with: URL(string:string1 ), placeholderImage: UIImage(named: "playerImage"))
        
        cell.profile_pic.layer.cornerRadius = cell.profile_pic.frame.size.width / 2;
           cell.profile_pic.clipsToBounds = true ;
        
        
           return cell
       
    }
           ///////////////////////////////////// TABLEVIEW  HEIGHT  //////////////////////////////////////////
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return 80
}

    
    func GetFollowData(url: String,comment: [String:AnyObject]) {
       

             Alamofire.request(url, method: .post, parameters: comment)
                    .responseData { response in
                  if response.result.isSuccess {
                  
                   print("Sucess! Got the weather data")
                   let weatherJSON : JSON = JSON(response.result.value!)
                   print(weatherJSON)
                   self.FOLLOWupdateData(json: weatherJSON)
                  
                    let user_id = UserDefaults.standard.string(forKey: USER_ID) ?? ""
                    let comment: [String:AnyObject] = ["user_id": user_id as AnyObject]
                    self.getBitcoinData(url: "https://musicworldcupdevelopment.com/Apps/profile",comment: comment)
                   
               } else {
                   SVProgressHUD.dismiss();
                    print("Error: \(String(describing: response.result.error))")
                  
               }
       }
       }
    
    
     func FOLLOWupdateData(json : JSON) {
    
    
    }
    
    
    
    
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extension UIImageView {
    func downloadImageFROM(link:String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



