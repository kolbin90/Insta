//
//  DetailViewController.swift
//  Insta
//
//  Created by Apple User on 11/12/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var post: Post?
    var user: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        tableView.dataSource = self
        fetchUser(uid: post!.uid!) { [unowned self] in
            self.tableView.reloadData()
        }
        tableView.estimatedRowHeight = 582
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name.init("stopVideo"), object: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailToCommentsVCSegue" {
            let commentVC = segue.destination as! CommentsViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
        if segue.identifier == "DetailToProfileUserVCSegue" {
            let profileUserVC = segue.destination as! ProfileUserViewController
            let user = sender as! UserModel
            profileUserVC.user = user
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        Api.user.observeUser(withUid: uid) { (user) in
            self.user = user
            completed()
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension DetailViewController: PostCellDelegate {
    func goToCommentsVC(withPostId id: String) {
        performSegue(withIdentifier: "DetailToCommentsVCSegue", sender: id)
    }
    func goToHashtagVC(withHashtag hashtag: String) {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let hashtagVC = storyboard.instantiateViewController(withIdentifier: "HashtagViewController") as! HashtagViewController
        hashtagVC.hashtag = hashtag
        self.show(hashtagVC, sender: nil)
    }
    func goToProfileUserVC(withUser user: UserModel) {
        performSegue(withIdentifier: "DetailToProfileUserVCSegue", sender: user)
    }
}
