//
//  HeaderProfileCollectionReusableView.swift
//  Insta
//
//  Created by Apple User on 10/20/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

protocol HeaderProfileDelegate: class {
    func updateFollowButton(forUser user: UserModel)
}

protocol HeaderProfileSettingDelegate: class {
    func goToSettingVC()
}

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var user: UserModel? {
        didSet {
            updateView()
        }
    }
    weak var delegate: HeaderProfileDelegate?
    weak var delegateSetting: HeaderProfileSettingDelegate?
    
    func updateView() {
        self.usernameLabel.text = user!.username
        if let profileUrlString = user!.profileImageUrl {
            let profileUrl = URL(string: profileUrlString)
            self.profileImageView.sd_setImage(with: profileUrl, placeholderImage: UIImage(named: "placeholderImg"), options: [], completed: nil)
        }
        
        if user?.id == Api.user.CURRENT_USER?.uid {
            followButton.setTitle("Edit Profile", for: .normal)
            followButton.addTarget(self, action: #selector(self.goToSettingVC), for: UIControl.Event.touchUpInside)
        } else {
            updateFollowButton()
        }
        
        Api.follow.fetchFollowersCount(withUserId: user!.id!, completion: { (count) in
            self.followersCountLabel.text = "\(count)"
        })
        Api.follow.fetchFollowingCount(withUserId: user!.id!, completion: { (count) in
            self.followingCountLabel.text = "\(count)"
        })
        Api.user_posts.fetchPostsCount(withUserId: user!.id!) { (count) in
            self.postsCountLabel.text = "\(count)"
        }
    }
    @objc func goToSettingVC() {
        delegateSetting?.goToSettingVC()
    }
    func updateFollowButton() {
        guard let _ = user?.isFollowing else {
            return
        }
        
        if user!.isFollowing! {
            configureUnfollowButton()
        } else {
            configureFollowButton()
        }
    }
    
    func configureFollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.backgroundColor = UIColor(red: 69/255, green: 144/255, blue: 255/255, alpha: 1)
        followButton.setTitleColor(.white, for: .normal)
        
        followButton.setTitle("Follow", for: .normal)
        followButton.addTarget(self, action: #selector(self.followAction), for: UIControl.Event.touchUpInside)
    }
    
    func configureUnfollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.backgroundColor = .clear
        followButton.setTitleColor(.black, for: .normal)
        followButton.setTitle("Unfollow", for: .normal)
        followButton.addTarget(self, action: #selector(self.unfollowAction), for: UIControl.Event.touchUpInside)
    }
    
    @objc func followAction() {
        followButton.removeTarget(self, action:#selector(self.unfollowAction), for: UIControl.Event.touchUpInside)
        Api.follow.followAction(withUserId: user!.id!)
        configureUnfollowButton()
        user!.isFollowing = true
        delegate?.updateFollowButton(forUser: user!)
    }
    
    @objc func unfollowAction() {
        followButton.removeTarget(self, action: #selector(self.followAction), for: UIControl.Event.touchUpInside)
        Api.follow.unfollowAction(withUserId: user!.id!)
        configureFollowButton()
        user!.isFollowing = false
        delegate?.updateFollowButton(forUser: user!)
    }
}


