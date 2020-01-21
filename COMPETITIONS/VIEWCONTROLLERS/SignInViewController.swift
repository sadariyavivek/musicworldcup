//
//  SignInViewController.swift
//  MusicAppWorld
//
//  Created by Shikha on 03/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import QuartzCore
import Kingfisher
import IQKeyboardManagerSwift


class SignInViewController: UIViewController , UITextFieldDelegate {

    
      @IBOutlet weak var emailTF: FloatingTF!
      @IBOutlet weak var passwordTF: FloatingTF!
      @IBOutlet weak var loginButtton: UIButton!
      @IBOutlet weak var imageView: UIImageView!
      @IBOutlet weak var imageViewtwitter: UIImageView!
      @IBOutlet weak var imageViewgoogle: UIImageView!
      @IBOutlet weak var CHECK_BOX_BUTTON_CONDITION: CheckboxButton!
      
         var state = "OFF";
    
        override func viewDidLoad() {
        super.viewDidLoad()
     //       loginButtton.semanticContentAttribute = .forceRightToLeft
        self.navigationController?.navigationBar.isHidden = true
        
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
            
            CHECK_BOX_BUTTON_CONDITION.layer.borderWidth = 1
            CHECK_BOX_BUTTON_CONDITION.layer.borderColor = UIColor.lightGray.cgColor
            
  
       
  ///////////////////////////////////////////////////////////     IMAGE URL FROM SERVER    ///////////////////////////////////////////////////////////////////
//      let url = URL(string: "https://mwcmobileapp.s3.us-east-2.amazonaws.com/images/fb.png")
//        imageView.kf.setImage(with: url)
//        
//        let url1 = URL(string: "https://mwcmobileapp.s3.us-east-2.amazonaws.com/images/twitter.png")
//               imageViewtwitter.kf.setImage(with: url1)
//       
//        let url22 = URL(string: "https://mwcmobileapp.s3.us-east-2.amazonaws.com/images/google.png")
//        imageViewgoogle.kf.setImage(with: url22)
        
      ////////////////////////////////////////////////////////////    /////////////////////////////    ///////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////    /////////////////////////////    ///////////////////////////////////////////////////////////////////
    
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0.0
    }
    
    
    @IBAction func didToggleCheckboxButton(_ sender: CheckboxButton) {
         state = sender.on ? "ON" : "OFF"

        print("CheckboxButton: did turn \(state)")
    }
    
    
    @IBAction func ButtonToSplash(_ sender: UIButton) {
        
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "splashViewController") as! splashViewController
        self.navigationController?.pushViewController(myVC, animated: true)
        
        
    }
    
    
    
    
//////////////////////////////////////////////////////////////////   LOGIN BUTTON CODE         /////////////////////////////////////////////////////////////////////////////////////////// ///////////////////////////////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func SIGNIN(_ sender: UIButton) {
        
        
        
    
               let username = emailTF.text
               let password = passwordTF.text
               
               if(username == ""){
                   self.showErrorAlert(message: "Please enter your username.")
               }
               else if(password == ""){
                   self.showErrorAlert(message: "Please enter your password.")
               }
             else
              {
                   let comment: [String:AnyObject] = [
                       
                       "username": emailTF.text as AnyObject,
                       "password": passwordTF.text  as AnyObject,
                       "device_id":"1211" as AnyObject ,
                       "deviceName": "ios" as AnyObject ]
                 
                print("SEND DATA ", comment)
                   
                   getBitcoinData(url: "https://musicworldcupdevelopment.com/Apps/login",comment: comment)
                 
                }
                }
        
        
    
      

    
    func showErrorAlert(message : String) {

        let errorMsgAlert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        errorMsgAlert.addAction(okAction)
        self.present(errorMsgAlert, animated: true, completion: nil)
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    
   func displayAlertMessage(messageToDisplay: String)
   {
       let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
       
       let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
           
           // Code in this block will trigger when OK button tapped.
           print("Ok button tapped");
           
       }
       
       alertController.addAction(OKAction)
       
       self.present(alertController, animated: true, completion:nil)
   }
    
    
   func getBitcoinData(url: String,comment: [String:AnyObject]) {
    
    
   let alert : UIAlertView = UIAlertView(title: "Please Wait...", message: nil , delegate: nil, cancelButtonTitle: nil)
    
    let viewBack:UIView = UIView(frame:  CGRect(x: 83, y: 0, width: 100, height:20 ))
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
                // SVProgressHUD.dismiss()
                print("Sucess! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                // Toast(self.jsonToString(json: weatherJSON as AnyObject)).show(self)
                print(weatherJSON)
                self.updatebitcoinData(json: weatherJSON)
                
            } else {
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
             
            
            
    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MailTabVC") as! MailTabVC
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
        }
    }
        
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func SIGNUP(_ sender: UIButton) {
    
    let myVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.navigationController?.pushViewController(myVC, animated: true)
    
}
    
    
    @IBAction func FORGET_PASSWORD(_ sender: UIButton) {
       
    let myVC = storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
            self.navigationController?.pushViewController(myVC, animated: true)
       
           }
       
    ////////////////////////////////////////////////////////////// /////////////////////////////////////////////////////////////////////////////////////////////////////////////// ////////////////////////////////////////////////////////////// ////////////////////////////////////////////////////////////// ///////////////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
   

}

