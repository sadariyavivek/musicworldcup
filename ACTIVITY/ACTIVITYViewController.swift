//
//  ACTIVITYViewController.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 19/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

//import Foundation
//import UIKit
//import SwiftyJSON
//import Alamofire
//import SVProgressHUD
//import AlamofireImage
//import SDWebImage
//
//
//class ACTIVITYViewController:BaseViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout   {
//
//    
//        
//   
//    @IBOutlet weak var mycall: UICollectionView!
//      
//            var selectedIndex=[Int] ()
//            var selectedIndexPath: IndexPath?
//            var numberOfItemsPerRow : Int = 1
//            var dataSource:[String]?
//            var dataSourceForSearchResult:[String]?
//            var searchBarActive:Bool = false
//            var searchBarBoundsY:CGFloat?
//            var refreshControl:UIRefreshControl?
//            var cellWidth:CGFloat{
//            
//                return mycall.frame.size.width/2
//            }
//            
//            var data1 = [[String:AnyObject]]()
//            var data2 = [[String:AnyObject]]()
//            
//        
//            override func viewDidLoad() {
//                super.viewDidLoad()
//                
//                addSlideMenuButton()    // SIDE MENU BAR OPEN 
//                
//                
//                
//                mycall.dataSource = self
//                mycall.delegate = self
//                self.mycall.allowsMultipleSelection = false
//                
//                
//                
//                let comment: [String:AnyObject] = [
//                    
//                    "user_id": "3617"
//                        as AnyObject ,
//                    "page": "0"
//                    as AnyObject
//                ]
//                
//     
//           getBitcoinData(url: "https://musicworldcupdevelopment.com/Apps/activity",comment: comment)
//                                
//
//            }
//    
//        
//        
//        
//    
//        var arr_val = Array<Int>()
//     
//     func getBitcoinData(url: String,comment: [String:AnyObject]) {
//            SVProgressHUD.show()
//            
//            
//            Alamofire.request(url, method: .post, parameters: comment)
//            .responseData
//                { response in
//            
//                    print(response)
//                print("*********************************1")
//                if response.result.isSuccess
//                {
//                    print("*********************************2")
//                    SVProgressHUD.dismiss()
//                    print("Sucess! Got the weather data")
//                    let weatherJSON : JSON = JSON(response.result.value!) ["activity_posts"]
//                    print("*********************************3")
//                    print(weatherJSON)
//                    print("*********************************4")
//                    
//                    
//                    if let da = weatherJSON[].arrayObject
//                    {
//                        print("*********************************5")
//                        self.data1 = (da as! [[String:AnyObject]])
//                        
//                    }
//                    if self.data1.count>0
//                    {
//                        print("*********************************6")
//                        self.mycall?.reloadData()
//                    }
//                    
//                    
//                    
//                   
//                        for i in 0...self.data1.count {
//                        self.arr_val.append(0)
//                        
//                    }
//                    print("*********************************7",self.arr_val)
//                    
//                    
//                    self.updatebitcoinDatass(json: weatherJSON)
//                    
//                }
//                else
//                {
//                    SVProgressHUD.dismiss();
//                    print("Error: \(String(describing: response.result.error))")
//                    
//                }
//                
//            }
//            
//
//            }
//        
//
//
//
//        func jsonToString(json: AnyObject)-> String{
//            do {
//                let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
//                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
//                
//                return (convertedString ?? "defaultvalue")
//            } catch let myJSONError {
//                print(myJSONError)
//            }
//            return ""
//        }
//
//
//
//
//
//
//    //MARK: - JSON Parsing
//    /***************************************************************/
//
//        var id1 = [String]();
//        
//    func updatebitcoinDatass(json : JSON) {
//
//        
//       
//        
//            for (index, da) in self.data1.enumerated() {
//           
//            
//                     
//                    let name = json["activity_posts"]["name"].stringValue
//                    let post_title = json["activity_posts"]["post_title"].stringValue
//                    let thumbnail_img = json["activity_posts"]["thumbnail_img"].stringValue
//                    let profile_pic = json["activity_posts"]["profile_pic"].stringValue
//                       
//                       print(name)
//                       print(post_title)
//                       print(thumbnail_img)
//                       print(profile_pic)
//                       
//                      
//        storeSharedValue(currentLevel: "name" ,saveValue:json["activity_posts"]["name"].stringValue)
//        storeSharedValue(currentLevel: "post_title" ,saveValue:json["activity_posts"]["post_title"].stringValue)
//        storeSharedValue(currentLevel: "thumbnail_img" ,saveValue:json["activity_posts"]["thumbnail_img"].stringValue)
//        storeSharedValue(currentLevel: "profile_pic" ,saveValue:json["activity_posts"]["profile_pic"].stringValue)
//                    
//                
//                
//                  print("name",retriveSharedValue(currentLevel: "name"));
//                  print("post_title",retriveSharedValue(currentLevel: "post_title"));
//                  print("thumbnail_img",retriveSharedValue(currentLevel: "thumbnail_img"));
//                  print("profile_pic",retriveSharedValue(currentLevel: "profile_pic"));
//               
//                
//                
//                
//            }
//            
//        
//        
//    }
//
//    
//    
//    func storeSharedValue(currentLevel: String, saveValue: String)
//              {
//                  let preferences = UserDefaults.standard
//                  
//                  let currentLevelKey = currentLevel
//                  
//                  
//                  //        // store string value
//                  preferences.set(saveValue, forKey: currentLevelKey)
//                  //
//                  //        //  Save to disk
//                  let didSave = preferences.synchronize()
//                  //
//                  if !didSave {
//                      //  Couldn't save (I've never seen this happen in real world testing)
//                  }
//              }
//              
//              
//              func retriveSharedValue(currentLevel: String)->String
//              {
//                  let preferences = UserDefaults.standard
//                  
//                  let currentLevelKey = currentLevel
//                  
//                  if preferences.object(forKey: currentLevelKey) == nil {
//                      //  Doesn't exist
//                  } else {
//                      
//                      
//                      return preferences.object(forKey: currentLevelKey) as! String
//                      
//                      
//                  }
//                  
//                  
//                  return ""
//              }
//            
//
//    
//            
//        ////////////////////////////   COLLECTION_VIEW CODING  //////////////////////////////
//        
//        
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            return data1.count
//        }
//        
//        
//            func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//                return 3
//            }
//            
//            
//            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//                
//                let cell:ActivityCELL=collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCELL", for: indexPath as IndexPath) as! ActivityCELL
//                
//            
//                                   cell.contentView.layer.cornerRadius = 1.0
//                                   cell.contentView.layer.borderWidth = 1.0
//                                   cell.contentView.layer.borderColor = UIColor.gray.cgColor
//                                   cell.contentView.layer.masksToBounds = true
//                                   cell.layer.shadowColor = UIColor.lightGray.cgColor
//                                   cell.layer.shadowOffset = CGSize(width: 0, height: 0.0)
//                                   cell.layer.shadowRadius = 2.0
//                                   cell.layer.shadowOpacity = 1.0
//                                   cell.layer.masksToBounds = false
//                                   cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
//                                   cell.layer.borderColor = UIColor.clear.cgColor
//                                   
//                                   
//                                 
//                                   
//                                   if(self.arr_val[indexPath.row] == 0)
//                                   {
//                                   cell.layer.borderWidth = 0
//                                   }
//                                   else
//                                   {
//                                       cell.layer.borderColor = UIColor.blue.cgColor
//                                       cell.layer.borderWidth = 2
//                                   
//                                   }
//                                   
//                                   
//                                   
//                                   let ip = data1[indexPath.row]
//                                
//                                    print("====id======",id1)
//                                  
//                                   print("id from -------",id1)
//                                   for (index, da) in self.data1.enumerated()
//
//                                   {
//                                       print("index",index)
//                                      
//                                       
//                                       cell.title.text  =  ip["post_title"] as? String
//                                       cell.name.text  =  ip["name"] as? String
//                                       cell.PostDescreptions.text  =  ip["post_desc"] as? String
//                                       cell.LIKES.text  =  ip["noofplays"] as? String
//                                       cell.COMMENTS.text  =  ip["total_comments"] as? String
//                                       cell.FAVOURITES.text  =  ip["total_favorites"] as? String
//                                       cell.SHARES.text  =  ip["total_shares"] as? String
//                                   
//                                     
////                                    if let ImagePath = ip["profile_pic"] as? String
////
////
////
////                                       {
////                                           print(ip["profile_pic"] as? String)
////
////
////                                           print("*********** image  print from url ***********",ImagePath);
//
//                                        
////
////       cell.playerImage1.image = UIImage(named: "playerImage")  //set placeholder image first.
////      cell.playerImage1.downloadImageFromSSS(link: (ip["profile_pic"] as? String)!,
////    contentMode: UIView.ContentMode.scaleAspectFill)  //set your image from link array.
//                                              
//                                        
//                                        
//                                        
////               cell.playerImage1.image = UIImage(named: "playerImage")  //set placeholder image first.
////                cell.playerImage1.downloadImageFromSSS(link: ImagePath ,
////                contentMode: UIView.ContentMode.scaleAspectFill)
////                                   
//                                        
//                                  
//
//                                    
//    
//    cell.playerImage1.sd_setImage(with: URL(string: "https://dtyaxcg60g9n4.cloudfront.net/8b453bea-52e4-4459-a19b-8a058556f732.jpeg"),
//            placeholderImage: nil)
//
//       //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                    
//                
//                                                       }
//                                       
//                                       
//                            //      }
//                                   
//                                   return cell
//                           }
//
//        // MARK: <UICollectionViewDelegateFlowLayout>
//        
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            
//            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//            let totalSpace = flowLayout.sectionInset.left
//                + flowLayout.sectionInset.right
//                + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
//            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
//            return CGSize(width: size, height: size)
//        }
//        
//        func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
//            return CGRect(x: x, y: y, width: width, height: height)
//        }
//        
//        
//        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//            
//        {
//            
//            
//           
//                
//        }
//        
//        
//        
//        private func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: IndexPath) {
//            
//            let cell = mycall.cellForItem(at: indexPath)
//            cell?.layer.borderWidth = 2
//            cell?.layer.borderColor = UIColor.clear as! CGColor
//            
//           
//            
//        }
//        
//         
//   
//
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//extension UIImageView {
//    
//    func downloadImageFromSSS(link:String, contentMode: UIView.ContentMode) {
//        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
//            (data, response, error) -> Void in
//            DispatchQueue.main.async {
//                self.contentMode =  contentMode
//                if let data = data { self.image = UIImage(data: data) }
//            }
//        }).resume()
//    }
//}
//
//
//
//
//
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
