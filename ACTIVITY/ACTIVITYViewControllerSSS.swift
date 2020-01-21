//
//  ACTIVITYViewControllerSSS.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 23/10/19.
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
import PIPKit
import PictureInPicture

struct DataObj {
    var image: UIImage?
    var play_Url: URL?
    var title = ""
    var content = ""
}

class ACTIVITYViewControllerSSS:BaseViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , AVAudioPlayerDelegate,ProtocolNameDelegate  {

    @IBOutlet weak var view_reference_player: UIView!
    
    var offsetObservation: NSKeyValueObservation?
//    lazy var mmPlayerLayer: MMPlayerLayer = {
//
//        let l = MMPlayerLayer()
//        l.cacheType = .memory(count: 5)
//        l.coverFitType = .fitToPlayerView
//        l.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        l.replace(cover: CoverA.instantiateFromNib()) // XIB FILE
//        l.repeatWhenEnd = true
//        return l
//    }()
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var pipWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var MuteButton: UIButton!
    
    @IBOutlet weak var mycall: UICollectionView!
    @IBOutlet weak var pipView: UIView!
    @IBOutlet weak var customPipView: UIView!
    var confiddg: MMPlayerPresentConfig!

    var data1 = NSArray()
    var selectedIndex=[Int] ()
    var selectedIndexPath: IndexPath?
    var selectIndex :NSInteger?
    
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
    
    var player:AVPlayer!
    var playerItem:AVPlayerItem!
    var radioOption:Int?// Only used :: if u are 2. RadioButton Functionality implement
    var checkSelecetd:Bool?//
    var isPlaying:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSelecetd = false
        self.pipView.isHidden = true

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
        addSlideMenuButton() // SIDE MENU BAR OPEN
        MMPlayerDownloader.cleanTmpFile()
        self.navigationController?.mmPlayerTransition.push.pass(setting: { (_) in
            
        })
        offsetObservation = mycall.observe(\.contentOffset, options: [.new]) { [weak self] (_, value) in
            guard let self = self, self.presentedViewController == nil else {return}
            self.updateByContentOffset()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(self.startLoading), with: nil, afterDelay: 0.1)
        }
        mycall.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right:0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.updateByContentOffset()
            //  self?.startLoading()
        }
//        mmPlayerLayer.getStatusBlock { [weak self] (status) in
//            switch status {
//            case .failed(let err):
//                let alert = UIAlertController(title: "err", message: err.description, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self?.present(alert, animated: true, completion: nil)
//            case .ready:
//                print("Ready to Play")
//            case .playing:
//                print("Playing")
//            case .pause:
//                print("Pause")
//            case .end:
//                print("End")
//            default: break
//            }
//        }
//        mmPlayerLayer.getOrientationChange { (status) in
//            print("Player OrientationChange \(status)")
//        }
    }
    
    func pipMovePlayer()
    {
        print("pip")
     //   self.pipView.isHidden = false
        SVProgressHUD.dismiss()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (UIApplication.shared.delegate as! AppDelegate).view_player.isPresent{
            (UIApplication.shared.delegate as! AppDelegate).view_player.isHidden = false
        }
        //mmPlayerLayer.player?.isMuted = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        //mmPlayerLayer.player?.pause()
        //            player.pause()
        MMPlayerDownloader.cleanTmpFile()
        self.navigationController?.mmPlayerTransition.push.pass(setting: { (_) in
            
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
//    deinit {
//        offsetObservation?.invalidate()
//        offsetObservation = nil
//        print("ViewController deinit")
//    }
    
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
        
        if let cell = mycall.cellForItem(at: indexPath) as? ActivityVideoCELL,
            let playURL = URL(string: str) {
//            mmPlayerLayer.thumbImageView.image = cell.videoPlayerImg.image
//            mmPlayerLayer.playView = cell.videoPlayerImg
//            mmPlayerLayer.set(url: playURL)
        }
    }
    
    @objc fileprivate func startLoading() {
        if self.presentedViewController != nil {
            return
        }
        // start loading video
        //mmPlayerLayer.resume()
        MusicPlayer.player.player_Audio?.pause()
       
//        if isPlaying == true
//        {
//            MusicPlayer.player.player_Audio?.pause()
//            isPlaying = true
//            self.mycall.reloadData()
//        }
        
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
    //   @IBAction func audioPlayAction(_ sender: UIButton)
    //      {
    //        //  sender.isSelected = !sender.isSelected
    //          //self.mycall.reloadData()
    //
    //           if player?.rate == 0{
    //              self.player?.play()
    //             } else {
    //                self.player?.pause()
    //             }
    //      }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let activity_post = data1.object(at: indexPath.row) as! NSDictionary
        let media_type = activity_post.value(forKey: "media_type") as? String
        
        if media_type == "1" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityAudioCell", for: indexPath as IndexPath) as! ActivityAudioCell
            //mmPlayerLayer.player?.pause()
            //     cell.contentView.layer.cornerRadius = 0.0
            //     cell.contentView.layer.borderWidth = 0.0
            cell.contentView.layer.borderColor = UIColor.gray.cgColor
            cell.contentView.layer.masksToBounds = true
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0.0)
            cell.layer.shadowRadius = 0.0
            cell.layer.shadowOpacity = 0.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            cell.layer.borderColor = UIColor.clear.cgColor
           
            //var player:AVPlayer!
            //var playerItem:AVPlayerItem!
            
            
            do {
                
                var str = "https://d2n6yw60ezcr1z.cloudfront.net/"
                
                let audio_url = activity_post.value(forKey: "media_name") as? String
                str += audio_url ?? ""
               // cell.url = str
                if let url =  URL(string: str)
                {
                    playerItem = AVPlayerItem(url: url)
                    player = AVPlayer(playerItem: playerItem)
                    
                    //  let playerLayer=AVPlayerLayer(player: player!)
                    //playerLayer.frame=CGRect(x:0, y:0, width:10, height:50)
                    // cell.audioPlayer.layer.addSublayer(playerLayer)
                    // player.play()
                    //  cell.playMusic.addTarget(player, action: #selector(player.play), for: .touchUpInside)
                    // cell.pausMusic.addTarget(player, action: #selector(player.pause), for: .touchUpInside)
                    print(url)
                }
            } catch let error as NSError {
                player = nil
                print(error.localizedDescription)
            } catch {
                print("AVAudioPlayer init failed")
            }
            //  player.isMuted = false
            cell.playMusic.tag = indexPath.row
            cell.playMusic.addTarget(self, action: #selector(self.btnCheck(_:)), for: .touchUpInside)
            cell.btn_img.tag = indexPath.row
            cell.btn_img.addTarget(self, action: #selector(self.btnCheck(_:)), for: .touchUpInside)
            cell.audioMute.addTarget(player, action: #selector(player.play),for: .touchUpInside)
            
            // cell.btnCheckBox2.setImage(#imageLiteral(resourceName: "playe-red-new"), for: .normal)
            // cell.btnCheckBox2.setImage(#imageLiteral(resourceName: "pause-red"), for: .normal)
            //cell.btnCheckBox2.setImage(UIImage(named:"playe-red-new"), for: .normal)
            // cell.btnCheckBox2.setImage(UIImage(named:"pause-red"), for: .selected)
            
            cell.title.text  = activity_post.value(forKey: "post_title") as? String
            cell.groupName.text  = activity_post.value(forKey: "name") as? String
            cell.lbl_descriptions.text  = activity_post.value(forKey: "post_desc") as? String
            
            cell.LIKES.text  = activity_post.value(forKey: "noofplays") as? String
            cell.COMMENTS.text  = activity_post.value(forKey: "total_comments") as? String
            cell.FAVOURITES.text  = activity_post.value(forKey: "total_favorites") as? String
            cell.totalLikeWithName.text  =  (activity_post.value(forKey: "likes_text_row") as! String)
            cell.totalCommentsWithName.text  =  (activity_post.value(forKey: "total_comments") as! String) + " Comments"
            cell.SHARES.text  = activity_post.value(forKey: "total_shares") as? String
            
            let profile_pic = activity_post.value(forKey: "profile_pic") as? String
            
            var string1 = "https://dtyaxcg60g9n4.cloudfront.net/"
            
            string1 += profile_pic ?? ""
            
            cell.profile_pic.sd_setImage(with: URL(string:string1 ), placeholderImage: UIImage(named: "playerImage"))
            
            cell.profile_pic.layer.cornerRadius = cell.profile_pic.frame.size.width / 2;
            cell.profile_pic.clipsToBounds = true ;
            
            let audio_bg_img = activity_post.value(forKey: "bg_img") as? String
            let string2 = audio_bg_img ?? ""
            cell.audio_bg_img.sd_setImage(with: URL(string:string2 ), placeholderImage: UIImage(named: " "))
            let Country_flag = activity_post.value(forKey: "country_flag_code") as? String
            var stringCountry = "https://mwcmobileapp.s3.us-east-2.amazonaws.com/flag/"
            
            stringCountry += Country_flag ?? ""
            
            if Country_flag != ""{
                cell.Country_flag.sd_setImage(with: URL(string:stringCountry ), placeholderImage: UIImage(named: ""))
                cell.flageWidth.constant = 20
            }else{
                cell.flageWidth.constant = 0
            }
            let influencer = activity_post.value(forKey: "influencer") as? String
            if (influencer == "yes")
            {
                //cell.VerifiedSign.sd_setImage(with:placeholderImage: UIImage(named: "y-1"))
                cell.VerifiedSign.image = UIImage(named: "y-1")
            }
            else
            {
                cell.VerifiedSign.image = UIImage(named:" ")
            }
            if (radioOption == indexPath.row)
             {
            
             NotificationCenter.default.removeObserver(self)
             //mmPlayerLayer.player?.pause()
             MMPlayerDownloader.cleanTmpFile()
             self.navigationController?.mmPlayerTransition.push.pass(setting: { (_) in
             })
             checkSelecetd = true
           //self.player.play()
             cell.playMusic.setImage(#imageLiteral(resourceName: "pause-red"), for: .normal)
             //mmPlayerLayer.player?.pause()
         //  cell.playMusic.addTarget(player, action: #selector(player.play), for: .touchUpInside)
             player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/30.0, preferredTimescale: Int32(NSEC_PER_SEC)), queue: nil) { time in
             let durationTot = self.playerItem.asset.duration
             let totalTime = CMTimeGetSeconds(durationTot)
             let totalTimesecs = Int(totalTime)
             cell.totalTimeLbl.text = NSString(format: "%02d:%02d", totalTimesecs/60, totalTimesecs%60) as String//"\(secs/60):\(secs%60)"
             let duration = CMTimeGetSeconds(self.playerItem.duration)
             print(Float((CMTimeGetSeconds(time) / duration)))
             cell.audioProgress.progress = Float((CMTimeGetSeconds(time) / duration))

              }
             }
             else
             {
             checkSelecetd = false
             
           //self.player.pause()
             cell.playMusic.setImage(#imageLiteral(resourceName: "playe-red-new"), for: .normal)
           //cell.pausMusic.addTarget(player, action: #selector(player.pause), for: .touchUpInside)
             player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/30.0, preferredTimescale: Int32(NSEC_PER_SEC)), queue: nil) { time in
             let durationTot = self.playerItem.asset.duration
             let totalTime = CMTimeGetSeconds(durationTot)
             let totalTimesecs = Int(totalTime)
             cell.totalTimeLbl.text = NSString(format: "%02d:%02d", totalTimesecs/60, totalTimesecs%60) as String//"\(secs/60):\(secs%60)"
             let duration = CMTimeGetSeconds(self.playerItem.duration)
             print(Float((CMTimeGetSeconds(time) / duration)))
             cell.audioProgress.progress = Float((CMTimeGetSeconds(time) / duration))

             }
            }
            // let duration = CMTimeGetSeconds((MusicPlayer.player.playerItem?.duration)!)

//                   progress.minimumValue = 0.0
//                   progress.maximumValue = Float(player.duration)
//                   progress.setValue(Float(player.currentTime), animated: true)
              //  print(Float((CMTimeGetSeconds(time) / duration)))
           // let result: Double = Double((MusicPlayer.player.playerItem?.duration)!/duration)

            
          
            
         //   let currentTimeInSeconds = CMTimeGetSeconds((MusicPlayer.player.player_Audio?.currentTime())!)
            // 2 Alternatively, you could able to get current time from `currentItem` - videoPlayer.currentItem.duration
//            let mins = currentTimeInSeconds / 60
//            let secs = currentTimeInSeconds.truncatingRemainder(dividingBy: 60)
//            let timeformatter = NumberFormatter()
//            timeformatter.minimumIntegerDigits = 2
//            timeformatter.minimumFractionDigits = 0
//            timeformatter.roundingMode = .down
//            guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
//                return
//            }
                        
//            if let currentItem = MusicPlayer.player.player_Audio?.currentItem {
//                let duration = currentItem.duration
//                let currentTime = currentItem.currentTime()
//               cell.audioProgress.progress = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
//            }
        
            return cell
        }  else
        {
           //   checkSelecetd = false
            
            let cell:ActivityVideoCELL=collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityVideoCELL", for: indexPath as IndexPath) as! ActivityVideoCELL
            
            cell.videoDetailBtn.tag = indexPath.row

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
            cell.btnCheckBox1.setImage(UIImage(named:"play-white"), for: .normal)
            cell.btnCheckBox1.setImage(UIImage(named:"pause-white"), for: .selected)
            
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            
            cell.title.text  = activity_post.value(forKey: "post_title") as? String
            cell.name.text  = activity_post.value(forKey: "name") as? String
            cell.PostDescreptions.text  = activity_post.value(forKey: "post_desc") as? String
            
            cell.LIKES.text  = activity_post.value(forKey: "noofplays") as? String
            cell.COMMENTS.text  = activity_post.value(forKey: "total_comments") as? String
            cell.FAVOURITES.text  = activity_post.value(forKey: "total_favorites") as? String
            cell.SHARES.text  = activity_post.value(forKey: "total_shares") as? String
            
            let profile_pic = activity_post.value(forKey: "profile_pic") as? String
            
            var str = "https://d2n6yw60ezcr1z.cloudfront.net/"
            let audio_url = activity_post.value(forKey: "media_name") as? String
            str += audio_url ?? ""
            
            /////////////////////////////////////////////////////////////////////// COUNTRY FLAG  video
            let Country_flag = activity_post.value(forKey: "country_flag_code") as? String
            var stringCountry = "https://mwcmobileapp.s3.us-east-2.amazonaws.com/flag/"
            
            stringCountry += Country_flag ?? ""
            
            if Country_flag != ""{
                cell.Country_flag.sd_setImage(with: URL(string:stringCountry ), placeholderImage: UIImage(named: ""))
                cell.flageWidth.constant = 20
            }else
            {
                cell.flageWidth.constant = 0
            }
            let influencer = activity_post.value(forKey: "influencer") as? String
            if (influencer == "yes")
            {
                cell.VerifiedSign.image = UIImage(named: "y-1")
            }
            else
            {
                cell.VerifiedSign.image = UIImage(named:" ")
            }
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            var string1 = "https://dtyaxcg60g9n4.cloudfront.net/"
            string1 += profile_pic ?? ""
            
            let video_bg_img = activity_post.value(forKey: "thumbnail_img") as? String
            var string3 = "https://d18kirqsofzqcm.cloudfront.net/"
            string3 += video_bg_img ?? ""
            
            cell.videoPlayerImg.sd_setImage(with: URL(string:string3), placeholderImage: UIImage(named: ""))
            
            cell.playerImage1.sd_setImage(with: URL(string:string1 ), placeholderImage: UIImage(named: "playerImage"))
            cell.playerImage1.layer.cornerRadius = cell.playerImage1.frame.size.width / 2;
            cell.playerImage1.clipsToBounds = true;
            
            cell.totalLikeWithName.text  =  (activity_post.value(forKey: "likes_text_row") as! String)
            cell.totalCommentsWithName.text  =  (activity_post.value(forKey: "total_comments") as! String) + " Comments"

            return cell
        }
    }
    
    @objc func btnCheck(_ sender: UIButton) {
        // Here I need to change Image and how to Implement my question
//        let activity_post = data1.object(at: sender.tag) as! NSDictionary
//        var str = "https://d2n6yw60ezcr1z.cloudfront.net/"
//         let audio_url = activity_post.value(forKey: "media_name") as? String
//         str += audio_url ?? ""
//         MusicPlayer.player.playMusic(str)
//        if checkSelecetd == true || sender.isSelected == true
//            {
//                radioOption = nil
//              //checkSelecetd = false
//                isPlaying = false
//            }
//            else
//           {
//             radioOption = sender.tag
//            //checkSelecetd = true
//             isPlaying = true
//
//            }
//         self.mycall.reloadData()
        
        
        let activity_post = self.data1.object(at: sender.tag) as! NSDictionary
        
        (UIApplication.shared.delegate as! AppDelegate).view_player.arr_video  = self.data1
        (UIApplication.shared.delegate as! AppDelegate).view_player.dict_video = activity_post
        (UIApplication.shared.delegate as! AppDelegate).view_player.present_player(view: view_reference_player)
    }
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if let comedyCell = cell as? ActivityAudioCell {
//            comedyCell.playMusic.setImage(#imageLiteral(resourceName: "playe-red-new"), for: .normal)
//            MusicPlayer.player.player_Audio?.pause()
//        }
//    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        if contentOffsetX >= (scrollView.contentSize.width - scrollView.bounds.width) - 20
            /* Needed offset */ {
            // guard !self.isLoading else { return }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView:UIScrollView)
    {
        
    }
    @objc func editPlayAction(sender: UIButton) {
        //player.play()
    }
    @objc func editPausAction(sender: UIButton) {
        //player.pause()
    }
    
    @objc func mutueVideo(player:AVPlayer)  {
        
        if player.isMuted
        {
            player.isMuted = false
        }else{
            player.isMuted = true
        }
    }
    
    @objc func mutueAudio(player:AVPlayer)  {
        
        if player.isMuted
        {
            player.isMuted = false
        }else{
            player.isMuted = true
        }
    }
    
    @objc func muteAudio(player:AVAudioPlayer)
    {
       // player.play()
    }
    
    @objc func playAudio(player:AVPlayer)
    {
      //  player.play()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let activity_post = data1.object(at: indexPath.row) as! NSDictionary
        let media_type = activity_post.value(forKey: "media_type") as? String
        if media_type == "1" {
            //  return CGSize.init(width: UIScreen.main.bounds.size.width, height: 300)
            return CGSize(width: UIScreen.main.bounds.size.width,height: 300)
        }
        else
        {
            return CGSize(width: UIScreen.main.bounds.size.width,height: 420)
            // return CGSize.init(width: UIScreen.main.bounds.size.width, height: 400)
        }
    }
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect
    {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        
    {
        let activity_post = data1.object(at: indexPath.row) as! NSDictionary
        let media_type = activity_post.value(forKey: "media_type") as? String
        if media_type == "1" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityAudioCell", for: indexPath as IndexPath) as! ActivityAudioCell
        }
    
    }
    @IBAction func videoDetailAction(_ sender: UIButton)
    {
        let activity_post = self.data1.object(at: sender.tag) as! NSDictionary
        
        (UIApplication.shared.delegate as! AppDelegate).view_player.arr_video  = self.data1
        (UIApplication.shared.delegate as! AppDelegate).view_player.dict_video = activity_post
        (UIApplication.shared.delegate as! AppDelegate).view_player.present_player(view: view_reference_player)
        
//          if let cont = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ActivityDetailVC") as? ActivityDetailVC {
//            cont.getVideoData  = self.data1
//            cont.getDict = activity_post
//            cont.delegate_pip = self
//            self.present(cont, animated: true, completion: nil)
//          }
    }
    private func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: IndexPath)
    {
        let cell = mycall.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2
        cell?.layer.borderColor = UIColor.clear as! CGColor
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extension UIImageView {
    func downloadImageFromSSS(link:String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This protocol use to pass playerLayer to second UIViewcontroller

extension ACTIVITYViewControllerSSS: MMPlayerFromProtocol {
    // when second controller pop or dismiss, this help to put player back to where you want
    // original was player last view   . it will be nil because of this view on reuse view
    func backReplaceSuperView(original: UIView?) -> UIView? {
        return original
    }
    // add layer to temp view and pass to another controller
    var passPlayer: MMPlayerLayer {
        return MMPlayerLayer()
    }
    // current playview is cell.image hide prevent ui error
    func transitionWillStart() {
        //self.mmPlayerLayer.playView?.isHidden = false
        //self.mmPlayerLayer.playView?.isHidden = true
        
    }
    // show cell.image
    func transitionCompleted() {
        //self.mmPlayerLayer.playView?.isHidden = false
    }
    func dismissViewFromGesture() {
        //mmPlayerLayer.thumbImageView.image = nil
        self.updateByContentOffset()
        //  self.startLoading()
    }
    func presentedView(isShrinkVideo: Bool) {
        self.mycall.visibleCells.forEach {
            if ($0 as? ActivityVideoCELL)?.videoPlayerImg.isHidden == true && isShrinkVideo
            {
                ($0 as? ActivityVideoCELL)?.videoPlayerImg.isHidden = false
            }
//            else if isShrinkVideo == true
//            {
//               print(true)
//                self.pipView.isHidden = false
//
//            }
//            else
//            {
//                print(false)
//                self.pipView.isHidden = true
//
//            }
        }
    }
}

