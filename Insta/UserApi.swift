//
//  UserApi.swift
//  Insta
//
//  Created by Apple User on 10/16/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserApi {
    let REF_USERS = Database.database().reference().child("users")
    
    func observeUser(withUid uid: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformToUser(dict: dict)
                completion(user)
            }
        }
    }
}
