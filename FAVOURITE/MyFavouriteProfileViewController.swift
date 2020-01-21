//
//  MyFavouriteProfileViewController.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 14/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD


class MyFavouriteProfileViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    
            
            @IBOutlet weak var mycall: UICollectionView!
          
                var data1 = NSArray()
              
                var selectedIndex=[Int] ()
                var selectedIndexPath: IndexPath?
                var numberOfItemsPerRow : Int = 2
                var dataSource:[String]?
                var dataSourceForSearchResult:[String]?
                var searchBarActive:Bool = false
                var searchBarBoundsY:CGFloat?
                var refreshControl:UIRefreshControl?
                var cellWidth:CGFloat{
                
                    return mycall.frame.size.width/2
                }
                
               
             
                
            
                override func viewDidLoad() {
                    super.viewDidLoad()
                    
                    mycall.dataSource = self
                    mycall.delegate = self
                    self.mycall.allowsMultipleSelection = false
                    
                    
                    
                    let comment: [String:AnyObject] = [
                        
                        "user_id": "3617"
                            as AnyObject
                        
                    ]
                    
         
               getBitcoinData(url: "https://musicworldcupdevelopment.com/Apps/myFavoriteprofiles",comment: comment)
                                    

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
                                   
//                                let weatherJSON = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [String: AnyObject]
                                
                                
                                
                                   
                                   print("****************** 2 **************")
                                   SVProgressHUD.dismiss()
                                   print("Sucess! Got the weather data")
                                   print("****************** 3 **************")
                                   print(weatherJSON)
                                   print("****************** 4 **************")
                                   self.data1 = weatherJSON?["profile"] as! NSArray
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
          
                
            ////////////////////////////   COLLECTION_VIEW CODING  //////////////////////////////
            
            
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return data1.count
            }
            
            
                func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
                    return 3
                }
                
                
                func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                    
                    let profile_list = data1.object(at: indexPath.row) as! NSDictionary
                        
                        
                    let cell:FavoritesProfileCELL = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesProfileCELL", for: indexPath as IndexPath) as! FavoritesProfileCELL
                        
                        
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
                    
                    
                    

                      cell.name.text  = profile_list.value(forKey:"name") as? String
                 //     cell.username.text  = profile_list.value(forKey: "username") as? String
                  
                   
                    let BackgroundImg = profile_list.value(forKey:"cover_pic") as? String
                    
                     let string2 = BackgroundImg ?? ""
                     
                     cell.playerImage.sd_setImage(with: URL(string:string2 ), placeholderImage: UIImage(named: " "))
                   
                    
                    
                   return cell
                            
                        }
                        
                        
                    
                    
                    
            
            

            // MARK: <UICollectionViewDelegateFlowLayout>
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
                let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
                let totalSpace = flowLayout.sectionInset.left
                    + flowLayout.sectionInset.right
                    + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
                let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
                return CGSize(width: size, height: size)
            }
            
            func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
                return CGRect(x: x, y: y, width: width, height: height)
            }
            
            
            func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
                
            {
                
                
               
                    
            }
            
            
            
            private func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: IndexPath) {
                
                let cell = mycall.cellForItem(at: indexPath)
                cell?.layer.borderWidth = 2
                cell?.layer.borderColor = UIColor.clear as! CGColor
                
               
                
            }
            
             
       

    }




    extension UIImageView {
        func downloadImageFromSs(link:String, contentMode: UIView.ContentMode) {
            URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
                (data, response, error) -> Void in
                DispatchQueue.main.async {
                    self.contentMode =  contentMode
                    if let data = data { self.image = UIImage(data: data) }
                }
            }).resume()
        }
    }

   

