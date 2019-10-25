//
//  FollowApi.swift
//  Insta
//
//  Created by Apple User on 10/25/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowApi {
    let REF_FOLLOWERS = Database.database().reference().child("followers")
    let REF_FOLLOWING = Database.database().reference().child("following")

}
