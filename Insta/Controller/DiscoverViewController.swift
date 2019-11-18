//
//  DiscoverViewController.swift
//  Insta
//
//  Created by Apple User on 9/18/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        observeTopPosts()

    }

    func observeTopPosts() {
        posts.removeAll()
        self.collectionView.reloadData()
        Api.post.queryTopPosts { (post) in
            self.posts.append(post)
            self.collectionView.reloadData()
            ProgressHUD.dismiss()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            let post = sender as! Post
            let detailVC = segue.destination as! DetailViewController
            detailVC.post = post
        }
    }
    
    @IBAction func refreshBtn_TchUpIns(_ sender: Any) {
        ProgressHUD.show("Loading...", interaction: false)
        observeTopPosts()
    }
    
}
extension DiscoverViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let currentPost = posts[indexPath.row]
        cell.post = currentPost
        cell.delegate = self
        
        return cell
    }
}

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    
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

extension DiscoverViewController: PhotoCollectionViewCellDelegate {
    func goToDetailVC(withPost post: Post) {
        performSegue(withIdentifier: "showDetailSegue", sender: post)
    }
}
