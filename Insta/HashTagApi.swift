//
//  HashTagApi.swift
//  Insta
//
//  Created by Apple User on 11/23/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation
import FirebaseDatabase

class HashTagApi {
    var REF_HASHTAG = Database.database().reference().child("hashtag")
    
    func observePostsForHashtag(hashtag word: String, completion: @escaping (Post) -> Void) {
        REF_HASHTAG.child(word).observe(.childAdded) { (snapshot) in
            Api.post.observePost(withId: snapshot.key, completion: { (post) in
                completion(post)
            })
        }
    }
}
