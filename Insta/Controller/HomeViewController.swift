//
//  HomeViewController.swift
//  Insta
//
//  Created by Apple User on 9/18/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadPosts()
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    func loadPosts() {
        Database.database().reference().child("posts").observe(.childAdded) { (dataSnapsot) in
            if let dict = dataSnapsot.value as? [String:Any] {
                let post = Post.transformToImagePost(dict: dict) //Post(captionText: captionText, photoUrlStringText: photoUrlString)
                self.posts.append(post)
                self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func logoutBtn_TchUpIns(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError{
            ProgressHUD.showError(logoutError.localizedDescription)
        }
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        present(signInViewController, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        if let photoUrlString = post.photoUrlString {
            let photoUrl = URL(string: photoUrlString)
            cell.postImageView.sd_setImage(with: photoUrl)
        }
        cell.captionLabel.text = post.captionText
        
        return cell 
    }
}

