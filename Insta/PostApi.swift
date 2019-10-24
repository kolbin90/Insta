//
//  PostApi.swift
//  Insta
//
//  Created by Apple User on 10/16/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostApi {
    let REF_POSTS = Database.database().reference().child("posts")
    
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.observe(.childAdded) { (dataSnapsot) in
            if let dict = dataSnapsot.value as? [String:Any] {
                let post = Post.transformToImagePost(dict: dict, id: dataSnapsot.key)
                completion(post)
            }
        }
    }
    
    func observePost(withId id: String, completion: @escaping (Post) -> Void) {
        Api.post.REF_POSTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformToImagePost(dict: dict, id: id)
                completion(post)
            }
        }
    }
}
