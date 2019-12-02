//
//  HelperService.swift
//  Insta
//
//  Created by Apple User on 10/24/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
class HelperService {
    static func updloadDataToServer(imageData: Data, videoUrl: URL?, ratio: CGFloat, caption: String, onSuccess: @escaping () -> Void) {
        ProgressHUD.show("Posting")
        if let videoUrl = videoUrl {
            uploadVideoToServer(videoUrl: videoUrl) { (videoUrlString) in
                uploadImageToServer(imageData: imageData, onSuccess: { (imageUrlString) in
                    sendPostInfoToDatabase(photoUrlString: imageUrlString, videoUrlString: videoUrlString, ratio: ratio, caption: caption, onSuccess: {
                        ProgressHUD.showSuccess("Success ")
                        onSuccess()
                    })
                })
            }
        } else {
            uploadImageToServer(imageData: imageData) { (imageUrlString) in
                sendPostInfoToDatabase(photoUrlString: imageUrlString, ratio: ratio, caption: caption, onSuccess: {
                    ProgressHUD.showSuccess("Success ")
                    onSuccess()
                })
            }
        }
    }
    
    static func uploadImageToServer(imageData: Data, onSuccess: @escaping (String) -> Void) {
        ProgressHUD.show("Posting")
        let photoID = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(photoID)
        let profileImgMetadata = StorageMetadata()
        profileImgMetadata.contentType = "image/jpg"
        storageRef.putData(imageData, metadata: profileImgMetadata, completion: { (metadata, error) in
            if error != nil {
                return
            }
            storageRef.downloadURL(completion: { (profileImgUrl, error) in
                guard let profileImgUrlString = profileImgUrl?.absoluteString
                    else
                {
                    return
                }
                onSuccess(profileImgUrlString)
                
            })
        })
    }
    
    static func uploadVideoToServer(videoUrl: URL, onSuccess: @escaping (String) -> Void) {
        let videoID = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(videoID)
        storageRef.putFile(from: videoUrl, metadata: nil) { (metadata, error) in
            if error != nil {
                return
            }
            storageRef.downloadURL(completion: { (videoUrl, error) in
                guard let videoUrlString = videoUrl?.absoluteString
                    else
                {
                    return
                }
                onSuccess(videoUrlString)
            })
        }
    }
    
    
    static func sendPostInfoToDatabase(photoUrlString: String, videoUrlString: String? = nil, ratio: CGFloat, caption: String, onSuccess: @escaping () -> Void){
        guard let newPostId = Api.post.REF_POSTS.childByAutoId().key else {
            return
        }
        
        Api.feed.REF_FEED.child(Api.user.CURRENT_USER!.uid).child(newPostId).setValue(true)

        let newPostRef = Api.post.REF_POSTS.child(newPostId)
        guard let uid = Api.user.CURRENT_USER?.uid else {
            return
        }
        
        let words = caption.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                let newHashtagRef = Api.hashtag.REF_HASHTAG.child(word.lowercased())
                newHashtagRef.updateChildValues([newPostId: true])
            }
        }
        let timestamp = Int(Date().timeIntervalSince1970)
        var dict = ["photoUrlString":photoUrlString, "ratio": ratio,"captionText":caption,"uid":uid,"likeCount":0, "timestamp": timestamp] as [String : Any]
        if let videoUrlString = videoUrlString {
            dict["videoUrlString"] = videoUrlString
        }
        newPostRef.setValue(dict) { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            Api.user_posts.REF_USER_POSTS.child(uid).child(newPostId).setValue(true, withCompletionBlock: { (error, ref) in
                if let error = error {
                    ProgressHUD.showError(error.localizedDescription)
                    return
                }
                onSuccess()
            })
        }
    }
}
