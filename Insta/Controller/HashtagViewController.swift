//
//  HashtagViewController.swift
//  Insta
//
//  Created by Apple User on 12/2/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class HashtagViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var hashtag: String?
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        navigationItem.title = "#\(hashtag!)"
        loadPosts()
    }
    
    func loadPosts() {
        Api.hashtag.observePostsForHashtag(hashtag: hashtag!) { (post) in
            self.posts.append(post)
            self.collectionView.reloadData()
        }
    }

}

extension HashtagViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let currentPost = posts[indexPath.row]
        cell.post = currentPost
        cell.delegate = self
        
        return cell
    }
}

extension HashtagViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacingBetweenAllCellsAtLine: CGFloat = 4
        return CGSize(width: (collectionView.frame.size.width - spacingBetweenAllCellsAtLine) / 3, height: (collectionView.frame.size.width - spacingBetweenAllCellsAtLine) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}


extension HashtagViewController: PhotoCollectionViewCellDelegate {
    func goToDetailVC(withPost post: Post) {
        let discoveryStoryboard = UIStoryboard(name: "Discover", bundle: nil)
        let detailVC = discoveryStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.post = post
        show(detailVC, sender: nil)
    }
}
