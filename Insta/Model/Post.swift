//
//  Post.swift
//  Insta
//
//  Created by Apple User on 10/7/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation

class Post {
    var caption: String
    var photoUrlString: String
    init(captionText: String, photoUrlStringText: String) {
        caption = captionText
        photoUrlString = photoUrlStringText
    }
}
