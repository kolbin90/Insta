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
        tableView.estimatedRowHeight = 582
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentsSegue" {
            let commentVC = segue.destination as! CommentsViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
        if segue.identifier == "HomeToProfileUserSegue" {
            let profileUserVC = segue.destination as! ProfileUserViewController
            let user = sender as! UserModel
            profileUserVC.user = user
        }
    }
    func loadPosts() {
        activityIndicator.startAnimating()
        Api.feed.observeFeed(forUid: Api.user.CURRENT_USER!.uid) { (post) in
            self.fetchUser(uid: post.uid!,completed: {
                self.posts.append(post)
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            })
        }
        
        Api.feed.observeRemovedFeedPost(forUid: Api.user.CURRENT_USER!.uid) { (key) in
            for (index, post) in self.posts.enumerated() {
                if post.id! == key {
                    self.posts.remove(at: index)
                    self.users.remove(at: index)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        Api.user.observeUser(withUid: uid) { (user) in
            self.users.append(user)
            completed()
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
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: PostCellDelegate {
    func goToCommentsVC(withPostId id: String) {
        performSegue(withIdentifier: "CommentsSegue", sender: id)
    }
    func goToProfileUserVC(withUser user: UserModel) {
        performSegue(withIdentifier: "HomeToProfileUserSegue", sender: user)
    }
}

