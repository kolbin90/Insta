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
    @IBOutlet weak var constrainToButtom: NSLayoutConstraint!
    
    var postId: String!
    var users = [User]()
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 77
        tableView.rowHeight = UITableView.automaticDimension
        sendButton.isEnabled = false
        handleTextField()
        loadComments()
        //tableView.keyboardDismissMode = .onDrag
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ : )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ : )), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(_ notification : NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            UIView.animate(withDuration: 0.3) {
                print(keyboardFrame)
                self.constrainToButtom.constant = keyboardFrame.height - self.view.safeAreaInsets.bottom
                print(self.constrainToButtom.constant)
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(_ notification : NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constrainToButtom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func loadComments() {
        Database.database().reference().child("post-comments").child(postId).observe(.childAdded) { (snapshot) in
            let commentKey = snapshot.key
            Database.database().reference().child("comments").child(commentKey).observeSingleEvent(of: .value, with: { (commentSnapshot) in
                if let dict = commentSnapshot.value as? [String:Any] {
                    let comment = Comment.transformToImagePost(dict: dict)
                    self.fetchUser(uid: comment.uid!,completed: {
                        self.comments.append(comment)
                       // self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                    })
                }
            })
        }
    }
            func fetchUser(uid: String, completed: @escaping () -> Void) {
                Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                    if let dict = snapshot.value as? [String: Any] {
                        let user = User.transformToUser(dict: dict)
                        self.users.append(user)
                        completed()
                    }
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
            self.view.endEditing(true)

        }
    }
    
    @IBAction func sendBtn_TchUpIns(_ sender: Any) {
        sendCommentInfoToDatabase()
    }
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.comment = comment
        cell.user = user
        return cell
    }
}
