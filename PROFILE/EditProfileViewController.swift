//
//  EditProfileViewController.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 11/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import QuartzCore
import Kingfisher
import IQKeyboardManagerSwift


class EditProfileViewController: UIViewController , UITextFieldDelegate {
    
    
     
    
      @IBOutlet weak var name: FloatingTF!
      @IBOutlet weak var UserNameTF: FloatingTF!
      @IBOutlet weak var UserBio: FloatingTF!
      @IBOutlet weak var emailTF: FloatingTF!
      @IBOutlet weak var Phone: FloatingTF!
      @IBOutlet weak var Address: FloatingTF!
      @IBOutlet weak var City: FloatingTF!
      @IBOutlet weak var Zipcode: FloatingTF!
      @IBOutlet weak var Country: FloatingTF!
      @IBOutlet weak var SAVEbutton: UIButton!
     
      @IBOutlet weak var GetPicturesBtn:UIImageView!
      @IBOutlet weak var GetCoversBtn: UIImageView!
      @IBOutlet weak var etFacebook: FloatingTF!
      @IBOutlet weak var etTwitter: FloatingTF!
      @IBOutlet weak var etInstagram: FloatingTF!
      @IBOutlet weak var etWebsite: FloatingTF!
    
    
   

           var selectChangePr: Bool!
    

           override func viewDidLoad() {
               super.viewDidLoad()
            
       
             self.navigationController?.navigationBar.isHidden = false
          
            //////////////////////////// NAVIGATITION BAR TITLE FONT FAMILY //////////////////////////////////
            
            self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: "Poppins", size: 18)!]
            
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.font: UIFont(name: "Poppins", size: 18.0)!
            ]
            
               selectChangePr = false
    
               self.name.delegate = self
               self.UserNameTF.delegate = self
               self.UserBio.delegate = self
               self.emailTF.delegate = self
               self.Phone.delegate = self
               self.Address.delegate = self
               self.City.delegate = self
               self.Zipcode.delegate = self
               self.Country.delegate = self
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
        
        let user_google = UserDefaults.standard.string(forKey: USER_GOOGLE) ?? ""
        let user_facebook = UserDefaults.standard.string(forKey: USER_FACEBOOK) ?? ""
        let user_instagram = UserDefaults.standard.string(forKey: USER_INSTAGRAM) ?? ""
        let user_twitter = UserDefaults.standard.string(forKey: USER_TWITTER) ?? ""
        let user_website = UserDefaults.standard.string(forKey: USER_WEB_SITE) ?? ""
        
        self.name.text = user_name
        self.UserNameTF.text = user_user_name
        self.UserBio.text = user_bio_summary
        self.emailTF.text = user_email
        self.Phone.text = user_phone
        
        self.Address.text = user_address
        self.City.text = user_city_state
        self.Zipcode.text = user_zipcode
        self.Country.text = user_country
        
        
        self.etFacebook.text = user_facebook
        self.etTwitter.text = user_twitter
        self.etWebsite.text = user_website
        self.etInstagram.text = user_instagram
        
        var string1 = "https://dtyaxcg60g9n4.cloudfront.net/"
        
        string1 += user_profile_pic
       
        GetPicturesBtn.sd_setImage(with: URL(string:string1 ), placeholderImage: UIImage(named: "playerImage"))
                             var stringCover1 = "https://dtyaxcg60g9n4.cloudfront.net/"
                             
                                stringCover1 += user_profile_cover_pic
                   
                   GetCoversBtn.sd_setImage(with: URL(string:stringCover1 ), placeholderImage: UIImage(named: "playerImage"))
                   
                             
                   
    }
    
    
    @IBAction func BACK_CLICK_BUTTON(_ sender: Any) {
        
         self.navigationController?.popViewController(animated: true)
      }
    
    
 ///////////////////////////////////////////////////////          SAVE PROFILE BUTTON CODE   API DATA    ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func SAVE_PROFILE(_ sender: UIButton) {
        

         let comment: [String:AnyObject] = [
            
            "user_id": "1" as AnyObject,
            "user_email":  emailTF.text as AnyObject,
            "username": UserNameTF.text as AnyObject ,
            "dialing_code": "91" as AnyObject,
            "phone":Phone.text as AnyObject ,
            "city": City.text as AnyObject,
            "address": Address.text as AnyObject,
            "state": City.text as AnyObject,
            "zipcode": Zipcode.text  as AnyObject,
            "country_id": "99" as AnyObject
        ]
        print("SEND DATA ", comment)
        
        getBitcoinData(url: "https://musicworldcupdevelopment.com/Apps/profileUpdate",comment: comment)
    }
    
        func displayAlertMessage(messageToDisplay: String)
           {
               let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
               
               let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("Ok button tapped");
                   
               }
               
               alertController.addAction(OKAction)
               
               self.present(alertController, animated: true, completion:nil)
           }
            
            
           func getBitcoinData(url: String,comment: [String:AnyObject]) {
        

            var alert : UIAlertView = UIAlertView(title: "Please Wait...", message: nil , delegate: nil, cancelButtonTitle: nil)
                   var viewBack:UIView = UIView(frame:  CGRect(x: 83, y: 0, width: 100, height:20 ))
                   let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 50, y: 10, width: 37, height:37 ))
                   loadingIndicator.center = viewBack.center
                   loadingIndicator.hidesWhenStopped = true
                   loadingIndicator.style = UIActivityIndicatorView.Style.gray
                   loadingIndicator.startAnimating();
                   viewBack.addSubview(loadingIndicator)
                   viewBack.center = self.view.center
                   alert.setValue(viewBack, forKey: "accessoryView")
                   loadingIndicator.startAnimating()
                   alert.show();
            
           Alamofire.request(url, method: .post, parameters: comment)
                .responseData { response in
                    if response.result.isSuccess {
                        
                alert.dismiss(withClickedButtonIndex: 0, animated: true)
                SVProgressHUD.dismiss()
                print("Sucess! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updatebitcoinData(json: weatherJSON)
                self.navigationController?.popViewController(animated: true)
                        }
                    else {
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
            
                
                
                
            func updatebitcoinData(json : JSON) {
                    
            Toast(json["message"].stringValue).show(self)
                 
            if json["status"].boolValue {
                    
        let userdata = json["data"].dictionary
        UserDefaults.standard.set(userdata?["user_email"]?.stringValue , forKey: USER_EMAIL)
        UserDefaults.standard.set(userdata?["phone"]?.stringValue , forKey: USER_PHONE)
        UserDefaults.standard.set(userdata?["profile_pic"]?.stringValue , forKey: USER_PROFILE_PIC)
        UserDefaults.standard.set(userdata?["cover_pic"]?.stringValue , forKey: USER_COVER_PIC)
        UserDefaults.standard.set(userdata?["dob"]?.stringValue , forKey: USER_DOB)
        UserDefaults.standard.set(userdata?["name"]?.stringValue , forKey: USER_NAME)
        UserDefaults.standard.set(userdata?["bio_summary"]?.stringValue , forKey: USER_BIO_SUMMARY)
        UserDefaults.standard.set(userdata?["user_id"]?.stringValue , forKey: USER_ID)
        UserDefaults.standard.set(userdata?["bio"]?.stringValue , forKey: USER_BIO)
        UserDefaults.standard.set(userdata?["total_votes"]?.stringValue , forKey: USER_TOTAL_VOTES)
        UserDefaults.standard.set(userdata?["user_total_coins"]?.stringValue , forKey: USER_TOTAL_COINS)
        UserDefaults.standard.set(userdata?["gender"]?.stringValue , forKey: USER_GENDER)
        UserDefaults.standard.set(userdata?["username"]?.stringValue , forKey: USER_USER_NAME)
        UserDefaults.standard.set(userdata?["facebook_url"]?.stringValue , forKey: USER_FACEBOOK)
        UserDefaults.standard.set(userdata?["twitter_url"]?.stringValue , forKey: USER_TWITTER)
        UserDefaults.standard.set(userdata?["google_url"]?.stringValue , forKey: USER_GOOGLE)
        UserDefaults.standard.set(userdata?["website_url"]?.stringValue , forKey: USER_WEB_SITE)
        UserDefaults.standard.set(userdata?["instagram_url"]?.stringValue , forKey: USER_INSTAGRAM)
        UserDefaults.standard.set(userdata?["address"]?.stringValue , forKey: USER_ADDRESS)
        UserDefaults.standard.set(userdata?["zipcode"]?.stringValue , forKey: USER_ZIPCODE)
        UserDefaults.standard.set(userdata?["state"]?.stringValue , forKey: USER_CITY_STATE)
        UserDefaults.standard.set(userdata?["country"]?.stringValue , forKey: USER_COUNTRY)
        UserDefaults.standard.set(userdata?["country_code"]?.stringValue , forKey: USER_COUNTRY_ID)
                        
                    }
                }
              
        
     @IBAction func Change_picture(_ sender: UIButton) {
    
        self.changeImageMethod()
        selectChangePr = true
    }
    
    
    
    @IBAction func Change_Cover(_ sender: UIButton) {
        
     self.changeImageMethod()
      selectChangePr = false
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
           }
           else {
               
               
               return preferences.object(forKey: currentLevelKey) as! String
               
           }
           
           
           return ""
       }
    
    
    
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extension UIViewController{
    func showAlert(title :  String, message : String){
        let alert   =   UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction    =   UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}



extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//  image upload code  CAMERA CODE   ImagePicker

extension EditProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        var image : UIImage?
        if let pickedImage = info[.editedImage] as? UIImage {
            image   =   pickedImage
        }
        else if let pickedImage = info[.originalImage] as? UIImage {
            image   =   pickedImage
        }
        picker.dismiss(animated: true) {
            if image != nil{
                
                if self.selectChangePr {
                  
                    self.GetPicturesBtn.image  =   image
                    let strBase64 =  image?.pngData()?.base64EncodedString()
                                                         let user_id = UserDefaults.standard.string(forKey: USER_ID) ?? ""
                                                        let parameters = ["userId" : user_id,
                                                            "picture" : strBase64,
                                                            "extension" : "png"
                                      ]
                                                        let url = "https://musicworldcupdevelopment.com/Apps/profilePhoto" /* your API url */
                                                        
                                                        self.uploadProfilePic(url: url, comment: parameters as [String : AnyObject])
                  
                }else{
                    self.GetCoversBtn.image  =   image
                                   
                               //    self.uploadProfileImage(image:self.GetCoversBtn.image!)
                    let strBase64 =  image?.pngData()?.base64EncodedString()
                                       let user_id = UserDefaults.standard.string(forKey: USER_ID) ?? ""
                                      let parameters = ["userId" : user_id,
                                          "coverPicture" : strBase64,
                                          "extension" : "png"
                    ]
                                      let url = "https://musicworldcupdevelopment.com/Apps/coverPhoto" /* your API url */
                                      
                                      self.uploadCoverPic(url: url, comment: parameters as [String : AnyObject])
                                      
                }
            }
        }
        
        
        
    }
    
    
    func openCamera()
    {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            //            imagePicker.cameraDevice    =   .back
            //            imagePicker.cameraViewTransform =   false
            
            present(imagePicker, animated: true, completion: nil)
        } else{
            //Alert(self,message: "Camera not available!")
        }
    }
    
    func  openGallery () {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func changeImageMethod() {//_ sender: UITapGestureRecognizer
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let GalleryAction: UIAlertAction = UIAlertAction(title: "Gallery", style: .default) { action -> Void in
            self.openGallery()
        }
        let CameraAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default ) { action -> Void in
            self.openCamera()
        }
        let CancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel ) { action -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(GalleryAction)
        alert.addAction(CameraAction)
        alert.addAction(CancelAction)
       
        self.present(alert, animated: true, completion: nil)
        
    }

    
    func uploadCoverPic(url: String,comment: [String:AnyObject]) {
    SVProgressHUD.show()
    
    
    Alamofire.request(url, method: .post, parameters: comment)
    .responseData
        { response in
    
            print(response)
        if response.result.isSuccess
        {
            
            do {
                let weatherJSON =  try JSONSerialization.jsonObject(with: response.data! , options: []) as? [String: Any]
                Toast(weatherJSON!["message"] as! String).show(self)
                SVProgressHUD.dismiss()
                if weatherJSON?["status"] as! String == "true" {
                   let filename = weatherJSON?["filename"] as! String
                    UserDefaults.standard.set(filename , forKey: USER_COVER_PIC)
                    
                    let user_profile_pic = UserDefaults.standard.string(forKey: USER_PROFILE_PIC) ?? ""
                    let user_profile_cover_pic = UserDefaults.standard.string(forKey: USER_COVER_PIC) ?? ""
                    var string1 = "https://dtyaxcg60g9n4.cloudfront.net/"
                            
                               string1 += user_profile_pic ?? ""
                            
                    self.GetPicturesBtn.sd_setImage(with: URL(string:string1 ), placeholderImage: UIImage(named: "playerImage"))
                               var stringCover1 = "https://dtyaxcg60g9n4.cloudfront.net/"
                               
                                  stringCover1 += user_profile_cover_pic
                     
                    self.GetCoversBtn.sd_setImage(with: URL(string:stringCover1 ), placeholderImage: UIImage(named: "playerImage"))
                     
                }
            print("********************************* 3 ******************************")
            print(weatherJSON)
            print("********************************* 4 ******************************")
               
//             let followers = weatherJSON?["followers"] as! NSArray
//             let following = weatherJSON?["following"] as! NSArray
//
//             let followersDic = followers.object(at: 0) as! NSDictionary
//             let followingDic = following.object(at: 0) as! NSDictionary
//
//             let totalFollowing = followersDic.value(forKey: "followers") as? String
//             let totalFollowers = followingDic.value(forKey: "following") as? String
             
            
                 
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
    
    

    
     func uploadProfilePic(url: String,comment: [String:AnyObject]) {
        SVProgressHUD.show()
        
         Alamofire.request(url, method: .post, parameters: comment)
        .responseData
            { response in
        
            print(response)
            if response.result.isSuccess
            {
                do {
                    let weatherJSON =  try JSONSerialization.jsonObject(with: response.data! , options: []) as? [String: Any]
                    Toast(weatherJSON!["message"] as! String).show(self)
                SVProgressHUD.dismiss()
                    if weatherJSON?["status"] as! String == "true" {
                        
                let filename = weatherJSON?["filename"] as! String
                UserDefaults.standard.set(filename , forKey: USER_PROFILE_PIC)
                        
                let user_profile_pic = UserDefaults.standard.string(forKey: USER_PROFILE_PIC) ?? ""
                let user_profile_cover_pic = UserDefaults.standard.string(forKey: USER_COVER_PIC) ?? ""
                var string1 = "https://dtyaxcg60g9n4.cloudfront.net/"
                                
                string1 += user_profile_pic ?? ""
                                
    self.GetPicturesBtn.sd_setImage(with: URL(string:string1 ), placeholderImage: UIImage(named: "playerImage"))
                
                        var stringCover1 = "https://dtyaxcg60g9n4.cloudfront.net/"
                                   
                        stringCover1 += user_profile_cover_pic
                         
    self.GetCoversBtn.sd_setImage(with: URL(string:stringCover1 ), placeholderImage: UIImage(named: "playerImage"))
            
                    }
                print("********************************* 3 ******************************")
                print(weatherJSON)
                print("********************************* 4 ******************************")
                   
    //             let followers = weatherJSON?["followers"] as! NSArray
    //             let following = weatherJSON?["following"] as! NSArray
    //
    //             let followersDic = followers.object(at: 0) as! NSDictionary
    //             let followingDic = following.object(at: 0) as! NSDictionary
    //
    //             let totalFollowing = followersDic.value(forKey: "followers") as? String
    //             let totalFollowers = followingDic.value(forKey: "following") as? String
                 
                
                     
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
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



