//
//  Post_CommentApi.swift
//  Insta
//
//  Created by Apple User on 10/16/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Post_CommentsApi {
    let REF_POST_COMMENTS = Database.database().reference().child("post-comments")
    
    func observePost_Comments(withPostId id: String, completion: @escaping (String) -> Void) {
        REF_POST_COMMENTS.child(id).observe(.childAdded) { (snapshot) in
            completion(snapshot.key)
        }
    }
}
