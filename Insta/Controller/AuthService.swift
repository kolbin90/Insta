//
//  AuthService.swift
//  Insta
//
//  Created by Apple User on 10/3/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    static func signIn(email: String, password: String, OnSuccess: @escaping() -> Void, onError: @escaping(_ errorString: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            OnSuccess()
        }
    }
    
    static func signOn(username:String, email: String, password: String, imageData: Data, onSuccess: @escaping() -> Void, onError: @escaping(_ errorString: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
            }
            let uID = (user?.user.uid)!
            let storageRef = Storage.storage().reference().child("profileImages").child(uID)
            let profileImgMetadata = StorageMetadata()
            profileImgMetadata.contentType = "image/jpg"
            storageRef.putData(imageData, metadata: profileImgMetadata, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                storageRef.downloadURL(completion: { (profileImgUrl, error) in
                    guard let profileImgUrlString = profileImgUrl?.absoluteString
                        else {
                            return
                    }
                    self.setUserInformation(profileImgUrl: profileImgUrlString, email: email, username: username, uID: uID, onSuccess: onSuccess)
                })
            })
        }
    }
    
    static func setUserInformation(profileImgUrl: String, email: String, username:String, uID:String, onSuccess: @escaping() -> Void) {
        let ref = Database.database().reference()
        let usersRef = ref.child("users").child(uID)
        usersRef.setValue(["username":username,"email":email,"profileImageUrl":profileImgUrl])
        onSuccess()
    }
    
}
