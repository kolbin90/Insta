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
    
    func updateView() {
        Api.user.REF_CURRNT_USER?.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Any] {
                let user = User.transformToUser(dict: dict)
                if let profileUrlString = user.profileImageUrl {
                    let profileUrl = URL(string: profileUrlString)
                    self.profileImageView.sd_setImage(with: profileUrl, placeholderImage: UIImage(named: "placeholderImg"), options: [], completed: nil)
                }
                self.usernameLabel.text = user.username
            }
        })
    }
}


