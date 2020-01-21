//
//  SideMenuControllerViewController.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 04/11/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

//import Foundation
//import UIKit
//
//class SideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//   
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        
//        let cell: SideBarCell = tableView.dequeueReusableCell(withIdentifier: "SideBarCell") as! SideBarCell
//        
//        cell.title.text = arrayTitle[indexPath.row]
//        cell.icon.image = UIImage(named: arrayIcon[indexPath.row])
//        
//        return cell
//       
//    }
//    
//    
//    
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    let arrayTitle = ["Home", "Profile", "Notifications", "Favorites", "Settings"]
//    let arrayIcon = ["ic_home_36pt", "ic_person_36pt", "ic_notifications_36pt", "ic_star_36pt", "ic_settings_36pt"]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        self.tableView.dataSource = self
//        self.tableView.delegate = self
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .lightContent
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrayTitle.count
//    }
//    
////    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
////
////        let cell: SideBarCell = tableView.dequeueReusableCell(withIdentifier: "SideBarCell") as! SideBarCell
////
////        cell.title.text = arrayTitle[indexPath.row]
////        cell.icon.image = UIImage(named: arrayIcon[indexPath.row])
////
////        return cell
////    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        switch (indexPath.row) {
//        case 0:
//            self.performSegue(withIdentifier: "home_segue", sender: self)
//            break
//        case 1:
//            self.performSegue(withIdentifier: "profile_segue", sender: self)
//            break
//        case 2:
//            self.performSegue(withIdentifier: "notifications_segue", sender: self)
//            break
//        case 3:
//            self.performSegue(withIdentifier: "favorites_segue", sender: self)
//            break
//        case 4:
//            self.performSegue(withIdentifier: "settings_segue", sender: self)
//            break
//        default:
//            break
//        }
//    }
//
//}
