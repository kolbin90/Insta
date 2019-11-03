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
    
    func queryTopPosts(completion: @escaping (Post) -> Void) {
        Api.post.REF_POSTS.queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value) { (snapshot) in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (childSnapshot) in
                if let dict = childSnapshot.value as? [String: Any] {
                    let post = Post.transformToImagePost(dict: dict, id: childSnapshot.key)
                    completion(post)
                }
            })
        }
    }
    
    func observeLikesCount(withPostId id: String, completion: @escaping (Int) -> Void) {
        Api.post.REF_POSTS.child(id).observe(.childChanged) { (snapshot) in
            if let likeCount = snapshot.value as? Int {
                completion(likeCount)
            }
        }
    }
    
    func incrementLikes(forPostId id: String, onSuccess: @escaping (Post) -> Void, onError: @escaping (String) -> Void) {
        let ref = Api.post.REF_POSTS.child(id)
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Api.user.CURRENT_USER?.uid {
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unstar the post and remove self from stars
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                onError(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.transformToImagePost(dict: dict, id: snapshot!.key)
                onSuccess(post)
            }
        }
    }
}
