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
    
    var selectedImage:UIImage?
    
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
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    @IBAction func saveBtn_TchUpIns(_ sender: Any) {
        if let profileImg = self.selectedImage, let profileImgData = profileImg.jpegData(compressionQuality: 0.3) {
            AuthService.updateUserInformation(username: usernameTextField.text!, email: emailTextField.text!, imageData: profileImgData, onSuccess: {
                ProgressHUD.showSuccess("Success")
            }) { (errorString) in
                ProgressHUD.showError(errorString!)
            }
        } else {
            AuthService.updateUserInformation(username: usernameTextField.text!, email: emailTextField.text!, imageData: nil, onSuccess: {
                ProgressHUD.showSuccess("Success")
            }) { (errorString) in
                ProgressHUD.showError(errorString!)
            }
            
        }
    }
    @IBAction func logoutBtn_TchUpIns(_ sender: Any) {
    }
    
}
extension SettingTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
            selectedImage = image
        }
        dismiss(animated: true, completion: nil)
    }
}
