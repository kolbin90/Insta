//
//  HeaderProfileCollectionReusableView.swift
//  Insta
//
//  Created by Apple User on 10/20/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountButton: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var user: UserModel? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        self.usernameLabel.text = user!.username
        if let profileUrlString = user!.profileImageUrl {
            let profileUrl = URL(string: profileUrlString)
            self.profileImageView.sd_setImage(with: profileUrl, placeholderImage: UIImage(named: "placeholderImg"), options: [], completed: nil)
        }
        
        if user?.id == Api.user.CURRENT_USER?.uid {
            
        } else {
            
        }
    }
}


