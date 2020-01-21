//
//  BaseViewController.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 19/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).view_player.dissmiss_player()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).view_player.show_player()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        (UIApplication.shared.delegate as! AppDelegate).view_player.show_player()
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
     
        case 0:
            print("Home\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("ACTIVITYViewControllerSSS")
            
            break
        case 1:
            print("Play\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("ProfilePhotoDetailsViewController")
            
            break
            
        case 2:
            print("item select\n", terminator: "")
            
     //       self.openViewControllerBasedOnIdentifier("CompetitionRulesViewController")
            
            break
            
        case 3:
            print("item select\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("MessagesListViewController")
            
            break
            
            case 4:
            print("item select\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("MyFavouritePostViewController")
            
            break
            
            case 5:
                          ///////////////////////// LOGOUT CODE ///////////////////////////////
                print("item select\n", terminator: "")
            // declare Alert
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to Sign Out?", preferredStyle: .alert)
            
            // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button click...")
               
             let prefs = UserDefaults.standard
                
                 prefs.removeObject(forKey:USER_ID)
                 prefs.removeObject(forKey:USER_PHONE)
                 prefs.removeObject(forKey:USER_PROFILE_PIC)
                 prefs.removeObject(forKey:USER_COVER_PIC)
                
                 prefs.removeObject(forKey:USER_DOB)
                 prefs.removeObject(forKey:USER_PHONE)
                 prefs.removeObject(forKey:USER_PROFILE_PIC)
                 prefs.removeObject(forKey:USER_COVER_PIC)
              
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "splashViewController") as! splashViewController
    let navigationController = UINavigationController(rootViewController: nextViewController)
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    appdelegate.window!.rootViewController = navigationController
               
                 })
            
            // Create Cancel button with action handlder
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        print("Cancel button click...")
            }
            
           //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)
            // Present dialog message to user
            
            break
            
            case 6:
            print("item select\n", terminator: "")
            
       //     self.openViewControllerBasedOnIdentifier("ProfilePhotoDetailsViewController")
            
            break
            
            
            
            case 7:
            print("item select\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("ConfirmEmailAddress")
            
            break
                
            case 8:
            print("item select\n", terminator: "")
            
         self.openViewControllerBasedOnIdentifier("AccountSettingsViewController")
            
            break
            
            
            
            case 9:
            print("item select\n", terminator: "")
            
  //          self.openViewControllerBasedOnIdentifier("AccountSettingsViewController")
            
            break
            
            
            case 10:
            print("item select\n", terminator: "")
            
     //       self.openViewControllerBasedOnIdentifier("ProfilePhotoDetailsViewController")
            
            break
            
        default:
            print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
        btnShowMenu.setImage(UIImage(named: "slide_menu_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btnShowMenu.tintColor = .black    // MENU ICON COLOR CHANGE
        
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
  //  func defaultMenuImage() -> UIImage {
    //    var defaultMenuImage = UIImage()
        
  //      UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
 //       UIColor.black.setFill()
 //       UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
 //       UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
   //     UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
 //       UIColor.white.setFill()
 //       UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
 //       UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
 //       UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
  //      defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
  //      UIGraphicsEndImageContext()
        
   //     return defaultMenuImage;
//    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        (UIApplication.shared.delegate as! AppDelegate).view_player.dissmiss_player()
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }
}

