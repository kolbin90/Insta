//
//  Post.swift
//  Insta
//
//  Created by Apple User on 10/7/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation
import FirebaseAuth

class Post {
    var captionText: String?
    var photoUrlString: String?
    var videoUrlString: String?
    var uid: String?
    var id: String?
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
    var ratio: CGFloat?
}
extension Post {
    static func transformToImagePost(dict: [String:Any], id: String) -> Post {
        let post = Post()
        post.captionText = dict["captionText"] as? String
        post.photoUrlString = dict["photoUrlString"] as? String
        post.uid = dict["uid"] as? String
        post.id = id
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        if let videoUrlString = dict["videoUrlString"] as? String {
            post.videoUrlString = videoUrlString
        }
        if let imageRatio = dict["ratio"] as? CGFloat {
            post.ratio = imageRatio
        } else {
            post.ratio = 1
        }
        
        if post.likes != nil {
            if let currentUserId = Auth.auth().currentUser?.uid {
                post.isLiked = post.likes![currentUserId] != nil
            }
        }
        return post
    }
}
