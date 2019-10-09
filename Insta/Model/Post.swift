//
//  Post.swift
//  Insta
//
//  Created by Apple User on 10/7/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation

class Post {
    var captionText: String?
    var photoUrlString: String?
    var uid: String?
}
extension Post {
    static func transformToImagePost(dict: [String:Any]) -> Post {
        let post = Post()
        post.captionText = dict["captionText"] as? String
        post.photoUrlString = dict["photoUrlString"] as? String
        post.uid = dict["uid"] as? String
        return post
    }
}
