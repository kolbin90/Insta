//
//  PeopleViewController.swift
//  Insta
//
//  Created by Apple User on 10/25/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var users:[UserModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        tableView.dataSource = self
        loadUsers()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileUserSegue" {
            let profileUserVC = segue.destination as! ProfileUserViewController
            let user = sender as! UserModel
            profileUserVC.user = user
        }
    }
    
    func loadUsers() {
        Api.user.observeUsers { (user) in
            self.isFollowing(withUserId: user.id!, completed: { (value) in
                user.isFollowing = value
                self.users.append(user)
                self.tableView.reloadData()
            })
        }
    }
    
    func isFollowing(withUserId id: String, completed: @escaping (Bool) -> Void) {
        Api.follow.isFollowing(withUserId: id, completed: completed)
    }

}
extension PeopleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! PeopleCell
        cell.user = user
        cell.peopleVC = self
        return cell
    }
}
