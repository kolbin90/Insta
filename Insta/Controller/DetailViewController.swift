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
        tableView.dataSource = self
        fetchUser(uid: post!.uid!) {
            self.tableView.reloadData()
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
        return cell
    }
}
