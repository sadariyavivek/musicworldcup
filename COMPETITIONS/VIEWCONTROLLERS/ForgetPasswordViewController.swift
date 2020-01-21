//
//  ForgetPasswordViewController.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 14/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import QuartzCore
import IQKeyboardManagerSwift

class ForgetPasswordViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var ForgetIconimageView: UIImageView!
    @IBOutlet weak var textFieldWithPlaceholder: UITextField!
    
    @IBOutlet weak var emailTF: FloatingTF!
    @IBOutlet weak var UserNameTF: FloatingTF!

        override func viewDidLoad() {
          super.viewDidLoad()
            
            
         
       
         self.navigationController?.navigationBar.isHidden = true
        
       
        self.emailTF.delegate = self
    
        
    }
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func RESET_PASSWORD_BUTTON(_ sender: UIButton) {
        
     
        let username = emailTF.text
        
        if(username == ""){
              self.showErrorAlert(message: "Please enter a valid email address.")
          }
          else if((username != "") && !(self.isValidEmail(emailStr: username!))){
              self.showErrorAlert(message: "Please enter a valid email address.")
          }
        
        
          
        else
         {
        
        let comment: [String:AnyObject] = [
                
                "username": emailTF.text as AnyObject
                
            ]
            print("SEND DATA ", comment)
            
            getBitcoinData(url: "https://musicworldcupdevelopment.com/Apps/resetpassword",comment: comment)
          
            
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
        Toast("Thanks! Please check your email for a link to reset your password.").show(self)
        
       let myVC = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(myVC, animated: true)

        
    }
      




    //////////////////////////////////////////////////////////
    
   
    @IBAction func BACK_CLICK_BUTTON(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
     extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
