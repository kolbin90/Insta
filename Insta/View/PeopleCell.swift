//
//  PeopleCell.swift
//  Insta
//
//  Created by Apple User on 10/25/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var cellView: UIView!
    
    var peopleVC: PeopleViewController?
    var user: UserModel? {
        didSet {
            updateView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureForUsernameLabel = UITapGestureRecognizer(target: self, action: #selector(self.cellView_TchUpIns))
        cellView.addGestureRecognizer(tapGestureForUsernameLabel)
        cellView.isUserInteractionEnabled = true
    }
    
    @objc func cellView_TchUpIns() {
        if let user = user {
            peopleVC?.performSegue(withIdentifier: "ProfileUserSegue", sender: user)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = ""
        profileImageView.image = UIImage(named: "placeholderImg")
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView() {
        if let profileUrlString = user?.profileImageUrl {
            let profileUrl = URL(string: profileUrlString)
            profileImageView.sd_setImage(with: profileUrl, placeholderImage: UIImage(named: "placeholderImg"), options: [], completed: nil)
        }
        usernameLabel.text = user?.username
        
        
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
    }
    
    @objc func unfollowAction() {
        followButton.removeTarget(self, action: #selector(self.followAction), for: UIControl.Event.touchUpInside)
        Api.follow.unfollowAction(withUserId: user!.id!)
        configureFollowButton()
        user!.isFollowing = false
    }

}
