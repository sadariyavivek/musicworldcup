//
//  NextScreenViewController.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 19/11/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import AlamofireImage
import SDWebImage
import AVKit
import AVFoundation
import AudioToolbox
import MMPlayerView
import Kingfisher

class NextScreenViewController: BaseViewController ,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , AVAudioPlayerDelegate {

    var offsetObservation: NSKeyValueObservation?
        lazy var mmPlayerLayer: MMPlayerLayer = {
          
            let l = MMPlayerLayer()
            l.cacheType = .memory(count: 5)
            l.coverFitType = .fitToPlayerView
            l.videoGravity = AVLayerVideoGravity.resizeAspectFill
            l.replace(cover: screenA.instantiateFromNib()) // XIB FILE
            l.repeatWhenEnd = true
            return l
        }()
        
        @IBOutlet weak var remainingTimeLabel: UILabel!
        @IBOutlet weak var slider: UISlider!
        @IBOutlet weak var playButton: UIButton!
        @IBOutlet weak var pauseButton: UIButton!
        @IBOutlet weak var MuteButton: UIButton!
        
        @IBOutlet weak var mycall: UICollectionView!
       
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
            
             addSlideMenuButton() // SIDE MENU BAR OPEN
            
            self.navigationController?.navigationBar.isHidden = false
            
            let layout = UICollectionViewFlowLayout()
                   layout.scrollDirection = .vertical
                   self.mycall.collectionViewLayout = layout
                   self.mycall!.contentInset = UIEdgeInsets(top: 20, left: 0, bottom:20, right: 0)
                   if let layout = self.mycall.collectionViewLayout as? UICollectionViewFlowLayout {
                       layout.minimumInteritemSpacing = 10
                       layout.minimumLineSpacing = 10
                       layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 380)
                      // layout.itemSize = UICollectionViewFlowLayout.automaticSize
                       //layout.estimatedItemSize = CGSize(width:1,height: 1)
                       layout.invalidateLayout()
                   }
           
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins", size: 20)!]
                    
            mycall.dataSource = self
            mycall.delegate = self
            self.mycall.allowsMultipleSelection = true
           
            let user_id = UserDefaults.standard.string(forKey: USER_ID) ?? ""
            
            let comment: [String:AnyObject] = [
                "user_id": user_id
                    as AnyObject ,
                "page": "0" as AnyObject
            ]
            getBitcoinData(url: "https://musicworldcupdevelopment.com/Apps/activity", comment: comment)
              
            

         
            
            MMPlayerDownloader.cleanTmpFile()
            self.navigationController?.mmPlayerTransition.push.pass(setting: { (_) in

            })
            offsetObservation = mycall.observe(\.contentOffset, options: [.new]) { [weak self] (_, value) in
                guard let self = self, self.presentedViewController == nil else {return}
                self.updateByContentOffset()
                NSObject.cancelPreviousPerformRequests(withTarget: self)
                self.perform(#selector(self.startLoading), with: nil, afterDelay: 0.3)
            }
            mycall.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right:0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.updateByContentOffset()
               // self?.startLoading()
            }
            mmPlayerLayer.getStatusBlock { [weak self] (status) in
                switch status {
                case .failed(let err):
                    let alert = UIAlertController(title: "err", message: err.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                case .ready:
                    print("Ready to Play")
                case .playing:
                    print("Playing")
                case .pause:
                    print("Pause")
                case .end:
                    print("End")
                default: break
                }
            }
            mmPlayerLayer.getOrientationChange { (status) in
                print("Player OrientationChange \(status)")
            }
           }
           override func viewWillDisappear(_ animated: Bool) {
               super.viewWillDisappear(animated)
               NotificationCenter.default.removeObserver(self)
           }
        
           deinit {
            offsetObservation?.invalidate()
            offsetObservation = nil
            print("ViewController deinit")
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
                            self.data1 = weatherJSON?["activity_posts"] as! NSArray
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
             // store string value
            preferences.set(saveValue, forKey: currentLevelKey)
            //
             //  Save to disk
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
        
        //////////////////////////////////////////////////////  ///////////////////////////   COLLECTION_VIEW CODING   ///////////////////////////////////////////////////// /////////////////////////////////////////////////   //////////////////////   //////////////////////   //////////////////////   //////////////////////   //////////////////////
          
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return data1.count
        }
        func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            return 1
        }
        
        
        fileprivate func updateByContentOffset() {
            let p = CGPoint(x: mycall.frame.width/2, y: mycall.contentOffset.y + mycall.frame.width/2)
            
            if let path = mycall.indexPathForItem(at: p),
                self.presentedViewController == nil {
                self.updateCell(at: path)
            }
        }
        

          fileprivate func updateCell(at indexPath: IndexPath) {
           
            let activity_post = data1.object(at: indexPath.row) as! NSDictionary
            var str = "https://d2n6yw60ezcr1z.cloudfront.net/"
               
            let audio_url = activity_post.value(forKey: "media_name") as? String
               str += audio_url ?? ""
              
            if let cell = mycall.cellForItem(at: indexPath) as? PlayerCELLS,
                let playURL = URL(string: str) {
     
                   mmPlayerLayer.thumbImageView.image = cell.videoPlayerImg.image
                   mmPlayerLayer.playView = cell.videoPlayerImg
                   mmPlayerLayer.set(url: playURL)
               }
           }
           
           @objc fileprivate func startLoading() {
               if self.presentedViewController != nil {
                   return
               }
               // start loading video
               mmPlayerLayer.resume()
           }
       
        func getThumbnailImage(forUrl url: URL) -> UIImage? {
            let asset: AVAsset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)

            do {
                let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
                return UIImage(cgImage: thumbnailImage)
            } catch let error {
                print(error)
            }

            return nil
        }
       
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let activity_post = data1.object(at: indexPath.row) as! NSDictionary
            let media_type = activity_post.value(forKey: "media_type") as? String
            
           
            
                let cell:PlayerCELLS=collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCELLS", for: indexPath as IndexPath) as! PlayerCELLS
                
                self.updateByContentOffset()

               // cell.contentView.layer.cornerRadius = 2.0
               // cell.contentView.layer.borderWidth = 0.0
                cell.contentView.layer.borderColor = UIColor.gray.cgColor
                cell.contentView.layer.masksToBounds = true
                cell.layer.shadowColor = UIColor.lightGray.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 0.0)
                cell.layer.shadowRadius = 0.0
                cell.layer.shadowOpacity = 0.0
                cell.layer.masksToBounds = false
                cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
                cell.layer.borderColor = UIColor.clear.cgColor
                
                
                
                cell.layer.shouldRasterize = true
                cell.layer.rasterizationScale = UIScreen.main.scale
                
                
                let profile_pic = activity_post.value(forKey: "profile_pic") as? String
            
            cell.profile_pic.layer.cornerRadius = cell.profile_pic.frame.size.width / 2;
            cell.profile_pic.clipsToBounds = true ;
            
               
                var str = "https://d2n6yw60ezcr1z.cloudfront.net/"
                let audio_url = activity_post.value(forKey: "media_name") as? String
                str += audio_url ?? ""
                
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                            
                var string1 = "https://dtyaxcg60g9n4.cloudfront.net/"
                string1 += profile_pic ?? ""
               
                let video_bg_img = activity_post.value(forKey: "thumbnail_img") as? String
                var string3 = "https://d18kirqsofzqcm.cloudfront.net/"
                string3 += video_bg_img ?? ""
               
                cell.videoPlayerImg.sd_setImage(with: URL(string:string3), placeholderImage: UIImage(named: ""))
            
                return cell
            }
        }
        func collectionView(_ collectionView: UICollectionView,
             willDisplay cell: UICollectionViewCell,
          forItemAt indexPath: IndexPath)
        {
            
        }
       
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let contentOffsetX = scrollView.contentOffset.x
            if contentOffsetX >= (scrollView.contentSize.width - scrollView.bounds.width) - 20 /* Needed offset */ {
    //            guard !self.isLoading else { return }

            }
        }
       
        func scrollViewDidEndDecelerating(_ scrollView:UIScrollView)
        {
            
        }
        
       func mutueVideo(player:AVPlayer)  {
            
            if player.isMuted
            {
                player.isMuted = false
            }else{
                player.isMuted = true
            }
        }
       
        func mutueAudio(player:AVPlayer)  {
              
              if player.isMuted
              {
                  player.isMuted = false
              }else{
                  player.isMuted = true
            }
        }
           
       
         func muteAudio(player:AVAudioPlayer)
        {
            player.play()
        }
       
         func playAudio(player:AVPlayer)
        {
            player.play()
            
        }
        
       
        
        func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect
        {
            return CGRect(x: x, y: y, width: width, height: height)
        }
       
        
     
        

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

         

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // This protocol use to pass playerLayer to second UIViewcontroller
     
    extension NextScreenViewController: MMPlayerFromProtocol {
        // when second controller pop or dismiss, this help to put player back to where you want
        // original was player last view ex. it will be nil because of this view on reuse view
        func backReplaceSuperView(original: UIView?) -> UIView? {
            return original
        }
        // add layer to temp view and pass to another controller
        var passPlayer: MMPlayerLayer {
            return self.mmPlayerLayer
        }
        // current playview is cell.image hide prevent ui error
        func transitionWillStart() {
            self.mmPlayerLayer.playView?.isHidden = false
        }
        // show cell.image
        func transitionCompleted() {
            self.mmPlayerLayer.playView?.isHidden = false
        }
        func dismissViewFromGesture() {
            mmPlayerLayer.thumbImageView.image = nil
            self.updateByContentOffset()
          // self.startLoading()
        }
        func presentedView(isShrinkVideo: Bool) {
            self.mycall.visibleCells.forEach {
                if ($0 as? ActivityVideoCELL)?.videoPlayerImg.isHidden == true && isShrinkVideo {
                    ($0 as? ActivityVideoCELL)?.videoPlayerImg.isHidden = false
                }
            }
        }
    }

