//
//  FeedApi.swift
//  Insta
//
//  Created by Apple User on 10/31/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FeedApi {
    let REF_FEED = Database.database().reference().child("feed")
    
    func observeFeed(forUid id: String, completion: @escaping (Post) -> Void) {
        REF_FEED.child(id).observe(.childAdded) { (snapshot) in
            Api.post.observePost(withId: snapshot.key, completion: { (post) in
                completion(post)
            })
        }
    }
    
    func observeRemovedFeedPost(forUid id: String, completion: @escaping (String) -> Void) {
        REF_FEED.child(id).observe(.childRemoved) { (snapshot) in
            completion(snapshot.key)
        }
    }
}
