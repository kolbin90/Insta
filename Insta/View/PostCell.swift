//
//  PostCell.swift
//  Insta
//
//  Created by Apple User on 10/7/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit
import SDWebImage

protocol PostCellDelegate {
    func goToCommentsVC(withPostId id: String)
    func goToProfileUserVC(withUser user: UserModel)
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
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    var delegate: PostCellDelegate?
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
        //updateLikes(forPost: post!)
        Api.post.REF_POSTS.child(post!.id!).removeAllObservers()

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
        if let photoUrlString = post?.photoUrlString {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholder-photo"), options: [], completed: nil)
        }
        captionLabel.text = post?.captionText
        
        imageViewHeightConstraint.constant = UIScreen.main.bounds.width / post.ratio!
        updateLikes(forPost: post)
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
