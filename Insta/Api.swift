//
//  Api.swift
//  Insta
//
//  Created by Apple User on 10/16/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation
struct Api {
    static let post = PostApi()
    static let user = UserApi()
    static let comment = CommentApi()
    static let post_comments = Post_CommentsApi()
    static let user_posts = User_PostsApi()
    static let follow = FollowApi()
    static let feed = FeedApi()
}
