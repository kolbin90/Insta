//
//  ProfileUserViewController.swift
//  Insta
//
//  Created by Apple User on 11/2/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class ProfileUserViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [Post] = []
    var user: UserModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUserPosts()
        checkFollowingStatus()
        navigationItem.title = user.username!
        collectionView.reloadData()
    }
    
    func fetchUserPosts() {
        Api.user_posts.REF_USER_POSTS.child(user.id!).observe(.childAdded) { (snapshot) in
            Api.post.observePost(withId: snapshot.key, completion: { (post) in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        }
    }
    func checkFollowingStatus() {
        if user.isFollowing == nil {
            self.isFollowing(withUserId: user.id!) { (value) in
                self.user.isFollowing = value
                self.collectionView.reloadData()
            }
        }
    }
    
    func isFollowing(withUserId id: String, completed: @escaping (Bool) -> Void) {
        Api.follow.isFollowing(withUserId: id, completed: completed)
    }
    
}

extension ProfileUserViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let currentPost = posts[indexPath.row]
        cell.post = currentPost
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user {
            headerCell.user = user
        }
        return headerCell
    }
}

extension ProfileUserViewController: UICollectionViewDelegateFlowLayout {
    
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
