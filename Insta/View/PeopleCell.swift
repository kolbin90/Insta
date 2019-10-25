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
    var user: UserModel? {
        didSet {
            updateView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        
        followButton.addTarget(self, action: #selector(self.followAction), for: UIControl.Event.touchUpInside)
        followButton.addTarget(self, action: #selector(self.unfollowAction), for: UIControl.Event.touchUpInside)
    }
    
    @objc func followAction() {
        Api.follow.followAction(withUserId: user!.id!)
    }
    
    @objc func unfollowAction() {
        Api.follow.unfollowAction(withUserId: user!.id!)
    }

}
