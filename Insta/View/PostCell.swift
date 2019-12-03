//
//  PostCell.swift
//  Insta
//
//  Created by Apple User on 10/7/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import ActiveLabel

protocol PostCellDelegate: class {
    func goToCommentsVC(withPostId id: String)
    func goToProfileUserVC(withUser user: UserModel)
    func goToHashtagVC(withHashtag hashtag: String)
}

class PostCell: UITableViewCell {
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: ActiveLabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var volumeView: UIView!
    @IBOutlet weak var volumeImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    weak var delegate: PostCellDelegate?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var post: Post! {
        didSet {
            updateView()
        }
    }
    var user: UserModel? {
        didSet {
            setupUserInfo()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "placeholderImg")
        postImageView.image = UIImage(named: "placeholder-photo")
        usernameLabel.text = ""
        captionLabel.text = ""
        Api.post.REF_POSTS.child(post!.id!).removeAllObservers()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        timestampLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameLabel.text = ""
        captionLabel.text = ""
        let tapGestureForComments = UITapGestureRecognizer(target: self, action: #selector(self.commentImageView_TchUpIns))
        commentImageView.addGestureRecognizer(tapGestureForComments)
        commentImageView.isUserInteractionEnabled = true
        let tapGestureForLike = UITapGestureRecognizer(target: self, action: #selector(self.likeImageView_TchUpIns))
        likeImageView.addGestureRecognizer(tapGestureForLike)
        likeImageView.isUserInteractionEnabled = true
        let tapGestureForHeaderView = UITapGestureRecognizer(target: self, action: #selector(self.headerView_TchUpIns))
        headerView.addGestureRecognizer(tapGestureForHeaderView)
        headerView.isUserInteractionEnabled = true
        timestampLabel.text = ""
    }
    
    @objc func headerView_TchUpIns() {
        if let user = user {
            delegate?.goToProfileUserVC(withUser: user)
        }
    }
    @objc func commentImageView_TchUpIns() {
        if let id = post?.id {
            delegate?.goToCommentsVC(withPostId: id)
        }
    }
    
    @objc func likeImageView_TchUpIns() {
        Api.post.incrementLikes(forPostId: post.id!, onSuccess: { (post) in
            self.updateLikes(forPost: post)
            self.post.likes = post.likes
            self.post.isLiked = post.isLiked
            self.post.likeCount = post.likeCount
        }) { (error) in
            ProgressHUD.showError(error)
        }
    }
    
    
    
    func updateView() {
        imageViewHeightConstraint.constant = UIScreen.main.bounds.width / post.ratio!
        layoutIfNeeded()
        captionLabel.text = post?.captionText
        captionLabel.handleHashtagTap { (word) in
            self.delegate?.goToHashtagVC(withHashtag: word)
        }
        captionLabel.handleMentionTap { (username) in
            Api.user.observeUserByUsername(username: username, completion: { (user) in
                self.delegate?.goToProfileUserVC(withUser: user)
            })
            
        }
        updateLikes(forPost: post)
        if let photoUrlString = post?.photoUrlString {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholder-photo"), options: [], completed: nil)
        }
        volumeView.isHidden = true
        
        if let videoUrlString = post?.videoUrlString, let videoUrl = URL(string: videoUrlString) {
            NotificationCenter.default.addObserver(self, selector: #selector(stopVideo), name: NSNotification.Name.init("stopVideo"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(playVideo), name: NSNotification.Name.init("playVideo"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(scrollToStop(_:)), name: NSNotification.Name.init("scrollToStop"), object: nil)
            player = AVPlayer(url: videoUrl)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = postImageView.frame
            playerLayer?.frame.size.width = UIScreen.main.bounds.width
            playerLayer?.frame.size.height = UIScreen.main.bounds.width / post!.ratio!
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PostCell.changeVolume))
            tapGesture.numberOfTapsRequired = 1
            volumeView.addGestureRecognizer(tapGesture)
            self.contentView.layer.addSublayer(playerLayer!)
            volumeImageView.image = UIImage(named: "Icon_Volume")
            volumeView.isHidden = false
            volumeView.layer.zPosition = 1
            player?.isMuted = false
            player?.play()
        }
        
        if let timestamp = post.timestamp {
            let now = Date()
            let timestampDate = Date(timeIntervalSince1970: Double(timestamp))
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth, .month, .year])
            let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
            
            var timeText = ""
            
            if let second = diff.second, second <= 0, let minute = diff.minute, minute == 0 {
                timeText = "Now"
            }
            if let second = diff.second, second > 0, let minute = diff.minute, minute == 0  {
                timeText = (second == 1) ? "\(second) second ago" : "\(second) seconds ago"
            }
            if let minute = diff.minute, minute > 0, let hour = diff.hour, hour == 0 {
                timeText = (minute == 1) ? "\(minute) minute ago" : "\(minute) minutes ago"
            }
            if let hour = diff.hour, hour > 0, let day = diff.day, day == 0 {
                timeText = (hour == 1) ? "\(hour) hour ago" : "\(hour) hours ago"
            }
            if let day = diff.day, day > 0, let week = diff.weekOfMonth, week == 0 {
                timeText = (day == 1) ? "\(day) day ago" : "\(day) days ago"
            }
            
            if let week = diff.weekOfMonth, week > 0, let month = diff.month, month == 0 {
                timeText = (week == 1) ? "\(week) week ago" : "\(week) weeks ago"
            }
            if let month = diff.month, month > 0, let year = diff.year, year == 0 {
                timeText = (month == 1) ? "\(month) month ago" : "\(month) monthes ago"
            }
            if let year = diff.year, year > 0{
                timeText = (year == 1) ? "\(year) year ago" : "\(year) years ago"
            }
            
            timestampLabel.text = timeText
        }
        
    }
    
    @objc func changeVolume() {
        guard let player = player else {
            return
        }
        if player.isMuted {
            player.isMuted = false
            volumeImageView.image = UIImage(named: "Icon_Volume")
        } else {
            player.isMuted = true
            volumeImageView.image = UIImage(named: "Icon_Mute")
        }
    }
    @objc func stopVideo() {
        if player?.rate != 0 {
            player?.pause()
        }
    }
    
    @objc func playVideo() {
        if player?.rate == 0 {
            player?.play()
        }
    }
    
    @objc func scrollToStop(_ notification: NSNotification) {
        if let sentPostId = notification.userInfo?["postId"] as? String {
            if post.id == sentPostId {
                player?.pause()
            }
        }
    }
    
    func updateLikes(forPost post: Post) {
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        guard let likeCount = post.likeCount else {
            likeCountButton.setTitle("Be the first to like", for: .normal)
            return
        }
        if likeCount != 0 {
            likeCountButton.setTitle("\(likeCount) likes", for: .normal)
        } else {
            likeCountButton.setTitle("Be the first to like", for: .normal)
        }
    }
    
    func setupUserInfo() {
        if let profileUrlString = user?.profileImageUrl {
            let profileUrl = URL(string: profileUrlString)
            profileImageView.sd_setImage(with: profileUrl, placeholderImage: UIImage(named: "placeholderImg"), options: [], completed: nil)
        }
        usernameLabel.text = user?.username
    }
}
