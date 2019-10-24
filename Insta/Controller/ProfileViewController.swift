//
//  ProfileViewController.swift
//  Insta
//
//  Created by Apple User on 9/18/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit
import FirebaseAuth
class ProfileViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var user: User!
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUser()
        fetchUserPosts()
    }
    
    func fetchUser() {
        Api.user.observeCurrentUser { (user) in
            self.user = user
            self.collectionView.reloadData()
        }
    }
    func fetchUserPosts() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
Api.user_posts.REF_USER_POSTS.child(currentUser.uid).observe(.childAdded) { (snapshot) in
            Api.post.observePost(withId: snapshot.key, completion: { (post) in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        }
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    
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

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
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
