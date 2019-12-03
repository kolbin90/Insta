//
//  PhotoCollectionViewCell.swift
//  Insta
//
//  Created by Apple User on 10/24/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

protocol PhotoCollectionViewCellDelegate: class {
    func goToDetailVC(withPost post: Post)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    weak var delegate: PhotoCollectionViewCellDelegate?
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let photoUrlString = post?.photoUrlString {
            let photoUrl = URL(string: photoUrlString)
            photoImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholder-photo"), options: [], completed: nil)
            let tapGestureForComments = UITapGestureRecognizer(target: self, action: #selector(self.PhotoView_TchUpIns))
            photoImageView.addGestureRecognizer(tapGestureForComments)
            photoImageView.isUserInteractionEnabled = true
        }
    }
    @objc func PhotoView_TchUpIns() {
        delegate?.goToDetailVC(withPost: post!)
    }
    
}
