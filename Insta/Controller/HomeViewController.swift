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

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    func loadPosts() {
        Database.database().reference().child("posts").observe(.childAdded) { (dataSnapsot) in
            print(dataSnapsot.value)
        }
        
    }
    
    @IBAction func logoutBtn_TchUpIns(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        present(signInViewController, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCelll", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.backgroundColor = .red
        return cell 
    }
}
