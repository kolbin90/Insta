//
//  PhotoCollectionViewCell.swift
//  Insta
//
//  Created by Apple User on 10/24/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let photoUrlString = post?.photoUrlString {
            let photoUrl = URL(string: photoUrlString)
            photoImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholder-photo"), options: [], completed: nil)
        }
    }
}
