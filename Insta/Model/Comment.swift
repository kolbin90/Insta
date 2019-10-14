//
//  Comment.swift
//  Insta
//
//  Created by Apple User on 10/13/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation

class Comment {
    var commentText: String?
    var uid: String?
}
extension Comment {
    static func transformToImagePost(dict: [String:Any]) -> Comment {
        let comment = Comment()
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        return comment
    }
}
