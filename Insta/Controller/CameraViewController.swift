//
//  CameraViewController.swift
//  Insta
//
//  Created by Apple User on 9/18/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    
    var selectedImage: UIImage?
    var videoUrl: URL?

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
        pickerController.mediaTypes = ["public.image", "public.movie"]
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
            HelperService.updloadDataToServer(imageData: postImgData, videoUrl: videoUrl, ratio: ratio, caption: textView.text) {
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
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            if let thumbnailImage = createThumbnailImage(forVideoUrl: videoUrl) {
                selectedImage = thumbnailImage
                photoImageView.image = thumbnailImage
                self.videoUrl = videoUrl
                dismiss(animated: true, completion: nil)
            }
        }
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //photoImageView.image = image
            //selectedImage = image
            dismiss(animated: true) {
                ProgressHUD.show("Loading...")
                let cameraStoryboard = UIStoryboard(name: "Camera", bundle: nil)
                let filterVC = cameraStoryboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
                filterVC.postImage = image
                filterVC.delegate = self
                let navController = UINavigationController(rootViewController: filterVC)
                self.present(navController, animated: true, completion: {
                    ProgressHUD.dismiss()
                })
            }
        }
    }
    
    func createThumbnailImage(forVideoUrl videoUrl: URL) -> UIImage? {
        let asset = AVAsset(url: videoUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 10), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let error{
            print(error)
        }
        return nil
    }
}

extension CameraViewController: FilterViewControllerDelegate {
    func useFiltredImage(image: UIImage) {
        selectedImage = image
        photoImageView.image = image
    }
}
