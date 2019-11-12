//
//  SettingTableViewController.swift
//  Insta
//
//  Created by Apple User on 11/7/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit
protocol SettingTableViewControllerDelegate {
    func updateUser()
}

class SettingTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var newProfileImage:UIImage?
    var originalUsername: String!
    var oroginalEmail: String!
    var delegate: SettingTableViewControllerDelegate?
    
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
            self.originalUsername = user.username
            self.oroginalEmail = user.email
            if let profileImageUrl = URL(string: user.profileImageUrl!) {
                self.profileImageView.sd_setImage(with: profileImageUrl, completed: nil)
            }
        }
    }
    
    func prepareDataToSave(onSussess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var newUsername: String?
        var newEmail: String?
        var profileImageData: Data?
        
        if originalUsername != usernameTextField.text {
            newUsername = usernameTextField.text
            originalUsername = usernameTextField.text
        }
        if oroginalEmail != emailTextField.text {
            newEmail = emailTextField.text
            oroginalEmail = emailTextField.text
        }
        if newProfileImage != nil {
            profileImageData = newProfileImage!.jpegData(compressionQuality: 0.3)
        }
        
        AuthService.updateUserInformation(username: newUsername, email: newEmail, imageData: profileImageData, onSuccess: {
            onSussess()
        }) { (errorString) in
            onError(errorString!)
        }
    }
    
    @IBAction func changeImageBtn_TchUpIns(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveBtn_TchUpIns(_ sender: Any) {
        ProgressHUD.show("Waiting...")
        prepareDataToSave(onSussess: {
            ProgressHUD.showSuccess("Success")
            self.delegate?.updateUser()
        }) { (errorString) in
            ProgressHUD.showError(errorString)
        }
    }
    
    @IBAction func logoutBtn_TchUpIns(_ sender: Any) {
        AuthService.logout(onSuccess: {
            self.dismiss(animated: true, completion: nil)
        }) { (errorString) in
            ProgressHUD.showError(errorString)
        }
    }
    
}
extension SettingTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
            newProfileImage = image
        }
        dismiss(animated: true, completion: nil)
    }
}
