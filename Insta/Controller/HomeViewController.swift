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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadPosts()
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    func loadPosts() {
        activityIndicator.startAnimating()
        Database.database().reference().child("posts").observe(.childAdded) { (dataSnapsot) in
            if let dict = dataSnapsot.value as? [String:Any] {
                let post = Post.transformToImagePost(dict: dict)
                self.fetchUser(uid: post.uid!,completed: {
                    self.posts.append(post)
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                })
            }
        }
        
    }
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformToUser(dict: dict)
                self.users.append(user)
                completed()
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
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        cell.post = post
        cell.user = user
        return cell
    }
}

