//
//  UserPostsApi.swift
//  Insta
//
//  Created by Apple User on 10/23/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation
import FirebaseDatabase

class User_PostsApi {
    let REF_USER_POSTS = Database.database().reference().child("user-posts")
    
    func fetchUserPostsKey(withUserId id: String, completion: @escaping (String) -> Void) {
        Api.user_posts.REF_USER_POSTS.child(id).observe(.childAdded) { (snapshot) in
            completion(snapshot.key)
        }
    }
    
    func fetchPostsCount(withUserId id: String, completion: @escaping (Int) -> Void) {
        Api.user_posts.REF_USER_POSTS.child(id).observe(.value) { (snapshot) in
            completion(Int(snapshot.childrenCount))
        }
    }
}
