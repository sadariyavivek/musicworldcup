//
//  Video.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 22/11/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import Foundation
import UIKit

class Video {
    
    //MARK: Properties
    let thumbnail: UIImage?
    let title: String
    let views: Int
    let channel: Channel
    let duration: Int
    var videoLink: URL!
    let likes: Int
    let disLikes: Int
    var suggestedVideos = [SuggestedVideo]()
    
    //MARK: Inits
    init(title: String, channelName: String) {
        self.thumbnail = UIImage.init(named: "")
        self.title = title
        self.views = Int(arc4random_uniform(1000000))
        self.duration = Int(arc4random_uniform(400))
        self.likes = Int(arc4random_uniform(1000))
        self.disLikes = Int(arc4random_uniform(1000))
        self.channel = Channel.init(name: channelName, image: UIImage.init(named: channelName)!)
    }
    
    //MARK: Methods   STATIC VIDEO
    class func fetchVideos(completion: @escaping (([Video]) -> Void)) {
        let video1 = Video.init(title: "What Does Jared Kushner Believe", channelName: "Nerdwriter1")
        var items = [video1]
        items.myShuffle()
        completion(items)
    }
    
    class func fetchVideo(completion: @escaping ((Video) -> Void)) {
        let video = Video.init(title: "Big Buck Bunny", channelName: "Blender Foundation")
        video.videoLink = URL.init(string: "http://sample-videos.com/video/mp4/360/big_buck_bunny_360p_10mb.mp4")!
        let suggestedVideo1 = SuggestedVideo.init(title: "What Does Jared Kushner Believe", channelName: "Nerdwriter1")
        let suggestedVideo2 = SuggestedVideo.init(title: "Moore's Law Is Ending. So, What's Next", channelName: "Seeker")
        let suggestedVideo3 = SuggestedVideo.init(title: "What Bill Gates is afraid of", channelName: "Vox")
        let suggestedVideo4 = SuggestedVideo.init(title: "Why Can't America Have a Grown-Up Healthcare Conversation", channelName: "vlogbrothers")
        let suggestedVideo5 = SuggestedVideo.init(title: "TensorFlow Basics - Deep Learning with Neural Networks p. 2", channelName: "sentdex")
        let items = [suggestedVideo1, suggestedVideo2, suggestedVideo3, suggestedVideo4, suggestedVideo5]
        video.suggestedVideos = items
        completion(video)
    }
}

struct SuggestedVideo {
    
    let title: String
    let channelName: String
    let thumbnail: UIImage
    
    init(title: String, channelName:String) {
        self.title = title
        self.channelName = channelName
        self.thumbnail = UIImage.init(named: title)!
    }
}

class Channel {
    
    let name: String
    let image: UIImage
    var subscribers = 0
    
    class func fetchData(completion: @escaping (([Channel]) -> Void)) {
        var items = [Channel]()
        for i in 0...18 {
            let name = ""
            let image = UIImage.init(named: "channel\(i)")
            let channel = Channel.init(name: name, image: image!)
            items.append(channel)
        }
        items.myShuffle()
        completion(items)
    }

    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
}


