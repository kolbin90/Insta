//
//  PostCell.swift
//  Insta
//
//  Created by Apple User on 10/7/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation

class PostCell: UITableViewCell {
    override func prepareForReuse() {
        backgroundColor = .white
        textLabel?.text = ""
    }
}
