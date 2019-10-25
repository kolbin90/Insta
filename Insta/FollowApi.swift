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
    
    func followAction(withUserId id: String) {
        Api.follow.REF_FOLLOWERS.child(id).child(Api.user.CURRENT_USER!.uid).setValue(true)
        Api.follow.REF_FOLLOWING.child(Api.user.CURRENT_USER!.uid).child(id).setValue(true)
    }
    func unfollowAction(withUserId id: String) {
        Api.follow.REF_FOLLOWERS.child(id).child(Api.user.CURRENT_USER!.uid).setValue(NSNull())
        Api.follow.REF_FOLLOWING.child(Api.user.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
}
