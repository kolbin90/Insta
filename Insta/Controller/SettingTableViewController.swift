//
//  SettingTableViewController.swift
//  Insta
//
//  Created by Apple User on 11/7/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Edit Profile"
        
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        Api.user.observeCurrentUser { (user) in
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            if let profileImageUrl = URL(string: user.profileImageUrl!) {
                self.profileImageView.sd_setImage(with: profileImageUrl, completed: nil)
            }
        }
    }
    
    @IBAction func changeImageBtn_TchUpIns(_ sender: Any) {
    }
    @IBAction func saveBtn_TchUpIns(_ sender: Any) {
    }
    @IBAction func logoutBtn_TchUpIns(_ sender: Any) {
    }
    
}
