//
//  CommentsViewController.swift
//  Insta
//
//  Created by Apple User on 10/9/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CommentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let postId = "-Lqj-9vmMg5MdkslU7MO"
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.isEnabled = false
        handleTextField()
        loadComments()
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tableView.endEditing(true)
    }
    
    func loadComments() {
        Database.database().reference().child("post-comments").child(postId).observe(.childAdded) { (snapshot) in
            let commentKey = snapshot.key
            Database.database().reference().child("comments").child(commentKey).observeSingleEvent(of: .value, with: { (commentSnapshot) in
                print(commentSnapshot.value)
            })
        }
    }
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let comment  = commentTextField.text, !comment.isEmpty else {
            sendButton.setTitleColor(.lightGray, for: .normal)
            sendButton.isEnabled = false
            return
        }
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.isEnabled = true
    }
    

    
    func sendCommentInfoToDatabase(){
        let ref = Database.database().reference()
        let commentsRef = ref.child("comments")
        guard let newCommentId = commentsRef.childByAutoId().key else {
            return
        }
        let newCommentRef = commentsRef.child(newCommentId)
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        newCommentRef.setValue(["commentText":commentTextField.text!,"uid":uid]) { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            Database.database().reference().child("post-comments").child(self.postId).child(newCommentId).setValue(true, withCompletionBlock: { (error, ref) in
                if let error = error {
                    ProgressHUD.showError(error.localizedDescription)
                }
            })
            self.commentTextField.text = ""
            self.sendButton.setTitleColor(.lightGray, for: .normal)
            self.sendButton.isEnabled = false
        }
    }
    
    @IBAction func sendBtn_TchUpIns(_ sender: Any) {
        sendCommentInfoToDatabase()
    }
}
