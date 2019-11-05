//
//  SearchViewController.swift
//  Insta
//
//  Created by Apple User on 11/1/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchBar = UISearchBar()
    var users: [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .black
        
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        searchBar.delegate = self
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        navigationItem.rightBarButtonItem = searchItem
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        tableView.dataSource = self
        
        doSearch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToProfileUserSegue" {
            let profileUserVC = segue.destination as! ProfileUserViewController
            let user = sender as! UserModel
            profileUserVC.user = user
        }
    }
    
    @objc func hideKeyboard() {
        searchBar.endEditing(true)
    }
    
    func doSearch() {
        if let searchText = searchBar.text?.lowercased() {
            users.removeAll()
            tableView.reloadData()
            Api.user.queryUsers(withText: searchText) { (user) in
                if !self.users.contains(where: { $0.id == user.id }) {
                    self.isFollowing(withUserId: user.id!, completed: { (value) in
                        user.isFollowing = value
                        self.users.append(user)
                        self.tableView.reloadData()
                    })
                }
                
            }
        }
    }
    
    func isFollowing(withUserId id: String, completed: @escaping (Bool) -> Void) {
        Api.follow.isFollowing(withUserId: id, completed: completed)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
}

extension SearchViewController:  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! PeopleCell
        cell.user = user
        cell.delegate = self
        
        return cell
    }
}

extension SearchViewController: PeopleCellDelegate {
    func goToProfileUserVC(withUser user: UserModel) {
        performSegue(withIdentifier: "SearchToProfileUserSegue", sender: user)
    }
}
