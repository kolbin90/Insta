//
//  PostCell.swift
//  Insta
//
//  Created by Apple User on 10/7/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation
import SDWebImage

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var homeVC: HomeViewController?
    var post: Post? {
        didSet {
            updateView()
        }
    }
    var user: User? {
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameLabel.text = ""
        captionLabel.text = ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentImageView_TchUpIns))
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
    }
    @objc func commentImageView_TchUpIns() {
        if let id = post?.id {
            homeVC?.performSegue(withIdentifier: "CommentsSegue", sender: id)
        }
    }
    
    func updateView() {
        if let photoUrlString = post?.photoUrlString {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholder-photo"), options: [], completed: nil)
        }
        captionLabel.text = post?.captionText
    }
    
    func setupUserInfo() {
        if let profileUrlString = user?.profileImageUrl {
            let profileUrl = URL(string: profileUrlString)
            profileImageView.sd_setImage(with: profileUrl, placeholderImage: UIImage(named: "placeholderImg"), options: [], completed: nil)
        }
        usernameLabel.text = user?.username
    }
}
