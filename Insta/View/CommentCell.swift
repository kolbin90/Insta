//
//  CommentCell.swift
//  Insta
//
//  Created by Apple User on 10/9/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit
import ActiveLabel

protocol CommentCellDelegate {
    func goToProfileUserVC(withUser user: UserModel)
}

class CommentCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: ActiveLabel!

    var delegate: CommentCellDelegate?
    var comment: Comment? {
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
        usernameLabel.text = ""
        commentLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameLabel.text = ""
        commentLabel.text = ""
        let tapGestureForUsername = UITapGestureRecognizer(target: self, action: #selector(self.user_TchUpIns))
        usernameLabel.addGestureRecognizer(tapGestureForUsername)
        usernameLabel.isUserInteractionEnabled = true
        let tapGestureForProfileImage = UITapGestureRecognizer(target: self, action: #selector(self.user_TchUpIns))
        profileImageView.addGestureRecognizer(tapGestureForProfileImage)
        profileImageView.isUserInteractionEnabled = true
    }
    
    @objc func user_TchUpIns() {
        if let user = user {
            delegate?.goToProfileUserVC(withUser: user)
        }
    }

    func updateView() {
        commentLabel.text = comment?.commentText
    }
    
    func setupUserInfo() {
        if let profileUrlString = user?.profileImageUrl {
            let profileUrl = URL(string: profileUrlString)
            profileImageView.sd_setImage(with: profileUrl, placeholderImage: UIImage(named: "placeholderImg"), options: [], completed: nil)
        }
        usernameLabel.text = user?.username
    }
    
}

