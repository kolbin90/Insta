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
                let user = UserModel.transformToUser(dict: dict)
                completion(user)
            }
        }
    }
    
    func observeUser(withUid uid: String, completion: @escaping (UserModel) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformToUser(dict: dict)
                completion(user)
            }
        }
    }
}
