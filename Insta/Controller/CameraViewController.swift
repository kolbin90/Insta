//
//  CameraViewController.swift
//  Insta
//
//  Created by Apple User on 9/18/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class CameraViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photoImageView.addGestureRecognizer(tapGesture)
        photoImageView.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func postBtn_TchUpIns(_ sender: Any) {
        if let profileImg = self.selectedImage, let profileImgData = profileImg.jpegData(compressionQuality: 0.3) {
            ProgressHUD.show("Posting")
            let photoID = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("posts").child(photoID)
            let profileImgMetadata = StorageMetadata()
            profileImgMetadata.contentType = "image/jpg"
            storageRef.putData(profileImgData, metadata: profileImgMetadata, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                storageRef.downloadURL(completion: { (profileImgUrl, error) in
                    guard let profileImgUrlString = profileImgUrl?.absoluteString
                        else
                    {
                        return
                    }
                    self.sendPostInfoToDatabase(photoUrlString: profileImgUrlString)
                    //self.setPostInformation(profileImgUrl: profileImgUrlString, email: email, username: username, uID: uID, onSuccess: onSuccess)
                })
            })
        } else {
            ProgressHUD.showError("Profile image can't be empty" )
        }
    }
    
    func sendPostInfoToDatabase(photoUrlString: String){
        let ref = Database.database().reference()
        let postsRef = ref.child("posts")//.child(uID)
        let newPostRef = postsRef.childByAutoId()
        newPostRef.setValue(["photoUrlString":photoUrlString])
        newPostRef.setValue(["photoUrlString":photoUrlString]) { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success ")
        }
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = image
            selectedImage = image
        }
        dismiss(animated: true, completion: nil)
    }
}
