//
//  HomeViewController.swift
//  Insta
//
//  Created by Apple User on 9/18/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadPosts()
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentsSegue" {
            let commentVC = segue.destination as! CommentsViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
    }
    func loadPosts() {
        activityIndicator.startAnimating()
        Api.post.observePosts { post in
            self.fetchUser(uid: post.uid!,completed: {
                self.posts.append(post)
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        Api.user.observeUser(withUid: uid) { (user) in
            self.users.append(user)
            completed()
        }
    }


    @IBAction func logoutBtn_TchUpIns(_ sender: Any) {
        
        AuthService.logout(onSuccess: {
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInViewController, animated: true, completion: nil)
        }) { (errorString) in
            ProgressHUD.showError(errorString)
        }
        
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.post = post
        cell.user = user
        cell.homeVC = self
        return cell
    }
}

