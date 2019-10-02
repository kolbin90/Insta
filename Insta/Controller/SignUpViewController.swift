//
//  SignUpViewController.swift
//  Insta
//
//  Created by Apple User on 9/18/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBtn.isEnabled = false
        
        usernameTextField.backgroundColor = .clear
        usernameTextField.tintColor = .white
        usernameTextField.textColor = .white
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerUsername = CALayer()
        bottomLayerUsername.frame = CGRect(x: 0, y: 29, width: usernameTextField.frame.width, height: 0.85)
        bottomLayerUsername.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        usernameTextField.layer.addSublayer(bottomLayerUsername)
        
        emailTextField.backgroundColor = .clear
        emailTextField.tintColor = .white
        emailTextField.textColor = .white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: emailTextField.frame.width, height: 0.85)
        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.tintColor = .white
        passwordTextField.textColor = .white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: passwordTextField.frame.width, height: 0.85)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)
        
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImageView))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        handleTextField()
    }
    
    
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let userName = usernameTextField.text, !userName.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpBtn.setTitleColor(.lightGray, for: .normal)
            signUpBtn.isEnabled = false
            return
        }
        signUpBtn.setTitleColor(.white, for: .normal)
        signUpBtn.isEnabled = true
    }
    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func dismissByClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtn_TchUpIns(_ sender: Any) {

        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            let uID = (user?.user.uid)!
            let storageRef = Storage.storage().reference().child("profileImages").child(uID)
            if let profileImg = self.selectedImage, let profileImgData = profileImg.jpegData(compressionQuality: 0.3) {
                var profileImgMetadata = StorageMetadata()
                profileImgMetadata.contentType = "image/jpg"
                storageRef.putData(profileImgData, metadata: profileImgMetadata, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    storageRef.downloadURL(completion: { (profileImgUrl, error) in
                        guard let profileImgUrlString = profileImgUrl?.absoluteString
                            else {
                                return
                        }
                        self.setUserInformation(profileImgUrl: profileImgUrlString, email: self.emailTextField.text!, username: self.usernameTextField.text!, uID: uID)
                    })
                })
            }
        }
        
        
    }
    
    func setUserInformation(profileImgUrl: String, email: String, username:String, uID:String) {
        let ref = Database.database().reference()
        let usersRef = ref.child("users").child(uID)
        usersRef.setValue(["username":username,"email":email,"profileImageUrl":profileImgUrl])
        self.performSegue(withIdentifier: "signUnToTabBar", sender: nil)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            selectedImage = image
        }
        dismiss(animated: true, completion: nil)
    }
}
