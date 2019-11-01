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
    static func updloadDataToServer(data: Data, caption: String, onSucces: @escaping () -> Void) {
        ProgressHUD.show("Posting")
        let photoID = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(photoID)
        let profileImgMetadata = StorageMetadata()
        profileImgMetadata.contentType = "image/jpg"
        storageRef.putData(data, metadata: profileImgMetadata, completion: { (metadata, error) in
            if error != nil {
                return
            }
            storageRef.downloadURL(completion: { (profileImgUrl, error) in
                guard let profileImgUrlString = profileImgUrl?.absoluteString
                    else
                {
                    return
                }
                self.sendPostInfoToDatabase(photoUrlString: profileImgUrlString, caption: caption) {
                    onSucces()
                }
            })
        })
    }
    
    static func sendPostInfoToDatabase(photoUrlString: String, caption: String, onSucces: @escaping () -> Void){
        guard let newPostId = Api.post.REF_POSTS.childByAutoId().key else {
            return
        }
        
        Api.feed.REF_FEED.child(Api.user.CURRENT_USER!.uid).child(newPostId).setValue(true)

        let newPostRef = Api.post.REF_POSTS.child(newPostId)
        guard let uid = Api.user.CURRENT_USER?.uid else {
            return
        }
        newPostRef.setValue(["photoUrlString":photoUrlString,"captionText":caption,"uid":uid]) { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            Api.user_posts.REF_USER_POSTS.child(uid).child(newPostId).setValue(true, withCompletionBlock: { (error, ref) in
                if let error = error {
                    ProgressHUD.showError(error.localizedDescription)
                    return
                }
                ProgressHUD.showSuccess("Success ")
                onSucces()
            })
        }
    }
}
