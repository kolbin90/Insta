//
//  CameraViewController.swift
//  Insta
//
//  Created by Apple User on 9/18/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photoImageView.addGestureRecognizer(tapGesture)
        photoImageView.isUserInteractionEnabled = true
    }
    override func viewDidAppear(_ animated: Bool) {
        handlePost()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handlePost(){
        if selectedImage != nil {
            clearButton.isEnabled = true
            postButton.isEnabled = true
            postButton.backgroundColor = .black
        } else {
            clearButton.isEnabled = false
            postButton.isEnabled = false
            postButton.backgroundColor = .lightGray
        }
    }
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    func clear() {
        textView.text = ""
        photoImageView.image = UIImage(named: "placeholder-photo")
        selectedImage = nil
        handlePost()
    }
    
    @IBAction func postBtn_TchUpIns(_ sender: Any) {
        if let postImg = self.selectedImage, let postImgData = postImg.jpegData(compressionQuality: 0.3) {
            let ratio = postImg.size.width / postImg.size.height
            HelperService.updloadDataToServer(data: postImgData, ratio: ratio, caption: textView.text) {
                self.clear()
                self.tabBarController?.selectedIndex = 0
            }
        } else {
            ProgressHUD.showError("Post image can't be empty" )
        }
    }
    
    @IBAction func clearBtn_TouchUpInside(_ sender: Any) {
        clear()
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
