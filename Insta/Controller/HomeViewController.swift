//
//  HomeViewController.swift
//  Insta
//
//  Created by Apple User on 9/18/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit
import FirebaseAuth
class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
