//
//  CommentApi.swift
//  Insta
//
//  Created by Apple User on 10/16/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentApi {
    let REF_COMMENT = Database.database().reference().child("comments")
    
    func observeComment(withCommentId id: String, completion: @escaping (Comment) -> Void) {
        REF_COMMENT.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String:Any] {
                let comment = Comment.transformToImagePost(dict: dict)
            completion(comment)
            }
        }
    }
}
