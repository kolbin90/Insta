//
//  User.swift
//  Insta
//
//  Created by Apple User on 10/9/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation

class UserModel {
    var email: String?
    var profileImageUrl: String?
    var username: String?
    var id: String?
    var isFollowing: Bool?
}
extension UserModel {
    static func transformToUser(dict: [String:Any], key: String) -> UserModel {
        let user = UserModel()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        user.id = key
        return user
    }
}
