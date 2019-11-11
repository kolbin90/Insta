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
    
    static func logout(onSuccess: @escaping() -> Void, onError: @escaping(_ errorString: String?) -> Void) {
        do {
            try Auth.auth().signOut()
            onSuccess()
        } catch let logoutError{
            onError(logoutError.localizedDescription)
        }
    }
    
    static func setUserInformation(profileImgUrl: String, email: String, username:String, uID:String, onSuccess: @escaping() -> Void) {
        let ref = Database.database().reference()
        let usersRef = ref.child("users").child(uID)
        usersRef.setValue(["username":username, "username_lowercase": username.lowercased(),"email":email,"profileImageUrl":profileImgUrl])
        onSuccess()
    }
    
    static func updateUserInformation(username:String?, email: String?, imageData: Data?, onSuccess: @escaping() -> Void, onError: @escaping(_ errorString: String?) -> Void) {
        var newDataDict = [String:String]()
        if let username = username {
            newDataDict["username"] =  username
            newDataDict["username_lowercase"] = username.lowercased()
        }
        if let email = email {
            newDataDict["email"] = email
            Api.user.CURRENT_USER?.updateEmail(to: email, completion: { (error) in
                if let errorString = error?.localizedDescription {
                    onError(errorString)
                } else {
                    if let imageData = imageData {
                        let uID = (Api.user.CURRENT_USER?.uid)!
                        let storageRef = Storage.storage().reference().child("profileImages").child(uID)
                        let profileImgMetadata = StorageMetadata()
                        profileImgMetadata.contentType = "image/jpg"
                        storageRef.putData(imageData, metadata: profileImgMetadata, completion: { (metadata, error) in
                            if error != nil {
                                return
                            }
                            storageRef.downloadURL(completion: { (profileImgUrl, error) in
                                guard let profileImgUrlString = profileImgUrl?.absoluteString else {
                                    return
                                }
                                newDataDict["profileImageUrl"] = profileImgUrlString
                                Api.user.REF_CURRNT_USER?.updateChildValues(newDataDict, withCompletionBlock: { (error, ref) in
                                    if let errorString = error?.localizedDescription {
                                        onError(errorString)
                                    } else {
                                        onSuccess()
                                    }
                                })
                            })
                        })
                    } else {
                        Api.user.REF_CURRNT_USER?.updateChildValues(newDataDict, withCompletionBlock: { (error, ref) in
                            if let errorString = error?.localizedDescription {
                                onError(errorString)
                            } else {
                                onSuccess()
                            }
                        })
                    }
                }
            })
        } else {
            if let imageData = imageData {
                let uID = (Api.user.CURRENT_USER?.uid)!
                let storageRef = Storage.storage().reference().child("profileImages").child(uID)
                let profileImgMetadata = StorageMetadata()
                profileImgMetadata.contentType = "image/jpg"
                storageRef.putData(imageData, metadata: profileImgMetadata, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    storageRef.downloadURL(completion: { (profileImgUrl, error) in
                        guard let profileImgUrlString = profileImgUrl?.absoluteString else {
                            return
                        }
                        newDataDict["profileImageUrl"] = profileImgUrlString
                        Api.user.REF_CURRNT_USER?.updateChildValues(newDataDict, withCompletionBlock: { (error, ref) in
                            if let errorString = error?.localizedDescription {
                                onError(errorString)
                            } else {
                                onSuccess()
                            }
                        })
                    })
                })
            } else {
                Api.user.REF_CURRNT_USER?.updateChildValues(newDataDict, withCompletionBlock: { (error, ref) in
                    if let errorString = error?.localizedDescription {
                        onError(errorString)
                    } else {
                        onSuccess()
                    }
                })
            }
        }
    }
    
}
