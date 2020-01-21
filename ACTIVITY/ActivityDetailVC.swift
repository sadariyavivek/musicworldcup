//
//  ActivityDetailVC.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 22/11/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

protocol PlayerVCDelegate {
    func didMinimize()
    func didmaximize()
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC)
    func didEndedSwipe(toState: stateOfVC)
    func setPreferStatusBarHidden(_ preferHidden: Bool)
}

import UIKit
import MMPlayerView
import AVKit
import AVFoundation
import AudioToolbox
import PictureInPicture

protocol ProtocolNameDelegate: class {
    // Protocol stuff goes here
    func pipMovePlayer()
}
class ActivityDetailVC: UIViewController,UIGestureRecognizerDelegate {
    var delegate: PlayerVCDelegate?
    var state = stateOfVC.hidden
    var direction = Direction.left
   // weak var delegate: ActivityDelegate?
    weak var delegate_pip: ProtocolNameDelegate?

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var getVideoData = NSArray()
    var getDict = NSDictionary()
    var videoArr = NSArray()
    var downloadObservation: MMPlayerObservation?
    fileprivate var playerLayer: MMPlayerLayer?
    @IBOutlet weak var playerImg: UIImageView!
    lazy var mmPlayerLayer: MMPlayerLayer = {
       let l = MMPlayerLayer()
       l.cacheType = .memory(count: 5)
       l.coverFitType = .fitToPlayerView
       l.videoGravity = AVLayerVideoGravity.resizeAspectFill
       l.replace(cover: screenA.instantiateFromNib()) // XIB FILE
       l.repeatWhenEnd = true
       return l
     }()
    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           self.mmPlayerTransition.present.pass { (config) in
               config.duration = 0.3
           }
       }
    var interactionController: UIPercentDrivenInteractiveTransition?

    @IBOutlet weak var pipPopupView: UIView!
  
    @IBOutlet weak var widthConstant: NSLayoutConstraint!
    @IBOutlet weak var player_View: UIView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.pipPopupView.isHidden = true
        self.tableView.delegate = self
         self.tableView.dataSource = self
         self.tableView.rowHeight = UITableView.automaticDimension
         self.tableView.estimatedRowHeight = 90
         self.player_View.layer.anchorPoint.applying(CGAffineTransform.init(translationX: -0.5, y: -0.5))
         self.tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
            self.playerView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.tapPlayView)))
                
        let resultPredicate  = NSPredicate(format: "media_type = %@","2")
        videoArr = getVideoData.filter { resultPredicate.evaluate(with: $0) } as NSArray
        self.automaticallyAdjustsScrollViewInsets = false
        self.backBtn.isHidden = false

    }
    @IBAction func minimizeGesture(_ sender: UIButton)
    {
//        UIView.animate(withDuration: 1.0, animations: {
//           // self.tableView.alpha = 0
//
//            (self.presentationController as? MMPlayerPassViewPresentatinController)?.shrinkView()
//
//        })
        self.state = .minimized
               self.delegate?.didMinimize()
               self.animate()
    }
        @objc func tapPlayView(notification: NSNotification)  {
            print(notification)
            self.state = .fullScreen
            self.delegate?.didmaximize()
            self.animate()
        }
  
    func animate()  {
           switch self.state {
           case .fullScreen:
               UIView.animate(withDuration: 0.3, animations: {
                   self.tableView.alpha = 1
                   self.player_View.transform = CGAffineTransform.identity
                   self.delegate?.setPreferStatusBarHidden(true)
                
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "ACTIVITYViewControllerSSS") as! ACTIVITYViewControllerSSS
                loginVC.willMove(toParent: nil)
                loginVC.view.removeFromSuperview()
                loginVC.removeFromParent()
                self.pipPopupView.isHidden = true
                self.backBtn.isHidden = false

                
               })
           case .minimized:
               UIView.animate(withDuration: 0.9, animations: {
                   self.delegate?.setPreferStatusBarHidden(false)
                   self.tableView.alpha = 0
                   let scale = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                let trasform = scale.concatenating(CGAffineTransform.init(translationX: -self.player_View.bounds.width/4, y: self.player_View.bounds.height/1.5))
                   self.player_View.transform = trasform
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "ACTIVITYViewControllerSSS") as! ACTIVITYViewControllerSSS
                self.addChild(loginVC)
                self.view.addSubview(loginVC.view)
                self.view.sendSubviewToBack(loginVC.view)
                self.navigationController?.popViewController(animated: true)
                //loginVC.willMove(toParent: self)
                self.delegate_pip?.pipMovePlayer()
                self.pipPopupView.isHidden = false
                let bounds = UIScreen.main.bounds
                let width = bounds.size.width
                self.widthConstant.constant = width-194
                self.backBtn.isHidden = true
//                loginVC.view.removeFromSuperview()
//                loginVC.removeFromParent()
//                (self.presentationController as? MMPlayerPassViewPresentatinController)?.shrinkView()

               })
           default: break
           }
       }
    @IBAction func viewAction(_ sender: Any)
      {
        self.dismiss(animated: true, completion: nil)

        }
    @IBAction func dismissAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func shrinkVideoAction(_ sender: Any)
    {
        (self.presentationController as? MMPlayerPassViewPresentatinController)?.shrinkView()

    }
}
extension ActivityDetailVC: MMPlayerToProtocol {
    
    func transitionCompleted(player: MMPlayerLayer) {
        self.playerLayer = player
    }

    var containerView: UIView {
        get {
            return playerView
        }
    }
}
extension ActivityDetailVC :UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return videoArr.count
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
    let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityDetailCell", for: indexPath as IndexPath) as! ActivityDetailCell
    let dict = videoArr[indexPath.row] as? NSDictionary
    cell.titileLbl.text = dict?.value(forKey: "post_title") as? String
    cell.userName.text = dict?.value(forKey: "name") as? String
    let video_bg_img = dict?.value(forKey: "thumbnail_img") as? String
    var string3 = "https://d18kirqsofzqcm.cloudfront.net/"
    string3 += video_bg_img ?? ""
    cell.thumnailImg.sd_setImage(with: URL(string:string3), placeholderImage: UIImage(named: ""))
    let Country_flag = dict?.value(forKey: "country_flag_code") as? String
    var stringCountry = "https://mwcmobileapp.s3.us-east-2.amazonaws.com/flag/"
    stringCountry += Country_flag ?? ""
    if Country_flag != ""{
       cell.flagIcon.sd_setImage(with: URL(string:stringCountry ), placeholderImage: UIImage(named: ""))
       cell.flagIconConstant.constant = 20
    }else
    {
       cell.flagIconConstant.constant = 0
    }
    cell.shareCount.text = dict?.value(forKey: "total_shares") as? String
    cell.chatCountLbl.text = dict?.value(forKey: "total_comments") as? String
    cell.heartCount.text = dict?.value(forKey: "total_favorites") as? String
    cell.playCount.text = dict?.value(forKey: "noofplays") as? String
    
    return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
          let activity_post = videoArr.object(at: indexPath.row) as! NSDictionary
          var str = "https://d2n6yw60ezcr1z.cloudfront.net/"
          let audio_url = activity_post.value(forKey: "media_name") as? String
          str += audio_url ?? ""
          let playURL = URL(string: str)
          self.playerLayer?.playView = self.playerView
        print(playURL?.absoluteString)
          self.playerLayer?.set(url: playURL)
          self.playerLayer?.resume()

        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
