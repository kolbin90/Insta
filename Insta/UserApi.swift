//
//  UserApi.swift
//  Insta
//
//  Created by Apple User on 10/16/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserApi {
    let REF_USERS = Database.database().reference().child("users")
    var REF_CURRNT_USER: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        return REF_USERS.child(currentUser.uid) 
    }
    var CURRENT_USER: User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }
        return nil
    }
    
    func observeUserByUsername(username: String, completion: @escaping (UserModel) -> Void) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryEqual(toValue: username).observeSingleEvent(of: .childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformToUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        }
    }
    
    func observeCurrentUser(completion: @escaping (UserModel) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        observeUser(withUid: currentUser.uid) { (user) in
            completion(user)
        }
    }
    
    func observeUsers(completion: @escaping (UserModel) -> Void) {
        REF_USERS.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformToUser(dict: dict, key: snapshot.key)
                if user.id != Api.user.CURRENT_USER!.uid {
                    completion(user)
                }
            }
        }
    }
    
    func observeUser(withUid uid: String, completion: @escaping (UserModel) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformToUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        }
    }
    
    func queryUsers(withText text: String, completion: @escaping (UserModel) -> Void) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text + "\u{f8ff}").queryLimited(toFirst: 10).observeSingleEvent(of: .value) { (snapshot) in
            snapshot.children.forEach({ (snapshotChild) in
                guard let child = snapshotChild as? DataSnapshot else {
                    return
                }
                if let dict = child.value as? [String: Any] {
                    let user = UserModel.transformToUser(dict: dict, key: child.key)
                    completion(user)
                }
            })
        }
    }
    

}
