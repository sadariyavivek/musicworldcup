//
//  SignUpViewController.swift
//  MusicAppWorld
//
//  Created by Shikha on 03/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import  Kingfisher
import IQKeyboardManagerSwift

class SignUpViewController: UIViewController , UITextFieldDelegate {

    
//    @IBAction func privacyBtnAction(_ sender: Any) {
//        let myVC = storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicy") as! PrivacyPolicy
//        self.navigationController?.pushViewController(myVC, animated: true)
//    }
    
    @IBOutlet weak var name: FloatingTF!
         @IBOutlet weak var UserNameTF: FloatingTF!
         @IBOutlet weak var emailTF: FloatingTF!
         @IBOutlet weak var passwordTF: FloatingTF!
         @IBOutlet weak var imageView: UIImageView!
          @IBOutlet weak var RegisterButtton: UIButton!
         @IBOutlet weak var imageViewtwitter: UIImageView!
         @IBOutlet weak var imageViewgoogle: UIImageView!

    
           override func viewDidLoad() {
              super.viewDidLoad()
           
             RegisterButtton.semanticContentAttribute = .forceRightToLeft
            
            self.navigationController?.navigationBar.isHidden = true
            
            self.name.delegate = self
            self.UserNameTF.delegate = self
            self.emailTF.delegate = self
            self.passwordTF.delegate = self
            
            ///////////////////////////////////////////////////////////     IMAGE URL FROM SERVER    ///////////////////////////////////////////////////////////////////
            
//            let url = URL(string: "https://mwcmobileapp.s3.us-east-2.amazonaws.com/images/fb.png")
//             imageView.kf.setImage(with: url)
//             
//             let url1 = URL(string: "https://mwcmobileapp.s3.us-east-2.amazonaws.com/images/twitter.png")
//                    imageViewtwitter.kf.setImage(with: url1)
//            
//             let url22 = URL(string: "https://mwcmobileapp.s3.us-east-2.amazonaws.com/images/google.png")
//             imageViewgoogle.kf.setImage(with: url22)
            
        ///////////////////////////////////////////////////////////    /////////////////////////   ///////////////////////////////////////////////////////////////////

            
        }
    
    
    @IBAction func TERMANDSERVICES(_ sender: UIButton) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TermsOfServices") as! TermsOfServices
                   self.navigationController?.pushViewController(myVC, animated: true)
    
    
    }
    
    @IBAction func privacy_policy(_ sender: UIButton) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicy") as! PrivacyPolicy
                   self.navigationController?.pushViewController(myVC, animated: true)
    
    
    }
    
    
    
    
      @IBAction func ButtonToSplash(_ sender: UIButton) {
        
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "splashViewController") as! splashViewController
        self.navigationController?.pushViewController(myVC, animated: true)
        
        
    }
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////     SIGNUP BUTTON CODE   /////////////////////////////////////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func SIGNUP(_ sender: UIButton) {
        
        let fullname = name.text
        let Username = UserNameTF.text
        let email = emailTF.text
        let password = passwordTF.text
        
        
        if(fullname == ""){
            self.showErrorAlert(message: "Please enter your name.")
        }
        else if(Username == ""){
            self.showErrorAlert(message: "Please enter your username.")
        }
            else if(email == ""){
                self.showErrorAlert(message: "Please enter your email.")
            }
            else if(password == ""){
                self.showErrorAlert(message: "Please enter your password.")
            }
                    else
                    
        {
 
        let comment: [String:AnyObject] = [
              
              "name": name.text as AnyObject,
              "username": UserNameTF.text  as AnyObject,
              "email": emailTF.text  as AnyObject,
              "password": passwordTF.text  as AnyObject,
              "deviceId":"1" as AnyObject ,
              "deviceType": "ios" as AnyObject ]
          print("SEND DATA ", comment)
          
          getBitcoinData(url: "https://musicworldcupdevelopment.com/Apps/signup",comment: comment)
        
          
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
                    
                    
                    // SVProgressHUD.dismiss()
                    print("Sucess! Got the weather data")
                    let weatherJSON : JSON = JSON(response.result.value!)
                    //                        Toast(self.jsonToString(json: weatherJSON as AnyObject)).show(self)
                    print(weatherJSON)
                    self.updatebitcoinData(json: weatherJSON)
                   
                    
                } else {
                    SVProgressHUD.dismiss();                   print("Error: \(String(describing: response.result.error))")
                    
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
           
           print(json)
           
           Toast(json["message"].stringValue).show(self)
        
              let name = json["data"]["name"].stringValue
              let username = json["data"]["username"].stringValue
              let email = json["data"]["email"].stringValue
              let password = json["data"]["password"].stringValue
        
        
storeSharedValue(currentLevel: name ,saveValue:json["data"]["name"].stringValue)
storeSharedValue(currentLevel: username ,saveValue:json["data"]["username"].stringValue)
storeSharedValue(currentLevel: email ,saveValue:json["data"]["email"].stringValue)
storeSharedValue(currentLevel: password ,saveValue:json["data"]["password"].stringValue)
        
        
        

        print("name",retriveSharedValue(currentLevel: name));
        print("username",retriveSharedValue(currentLevel: username));
        print("email",retriveSharedValue(currentLevel: email));
         print("password",retriveSharedValue(currentLevel: password));
        
        
    
        if json["status"].boolValue {
            let myVC = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                    
              self.navigationController?.pushViewController(myVC, animated: true)
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
     
    
    
    
    func storeSharedValue(currentLevel: String, saveValue: String)
    {
        
        let preferences = UserDefaults.standard
        preferences.set(true, forKey: "machine_id")
        
        print("abcd==========")
        let currentLevelKey = currentLevel
        
        
        // store string value
        preferences.set(saveValue, forKey: currentLevelKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            //  Couldn't save (I've never seen this happen in real world testing)
        }
    }
    
    
    
    
    @IBAction func SIGNIN(_ sender: UIButton) {
       
               let myVC = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
          self.navigationController?.pushViewController(myVC, animated: true)
    
       
           }
       
    
        
    }
    

    

