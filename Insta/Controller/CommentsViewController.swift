//
//  CommentsViewController.swift
//  Insta
//
//  Created by Apple User on 10/9/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var constrainToButtom: NSLayoutConstraint!
    
    var postId: String!
    var users = [UserModel]()
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        tableView.dataSource = self
        tableView.estimatedRowHeight = 77
        tableView.rowHeight = UITableView.automaticDimension
        sendButton.isEnabled = false
        handleTextField()
        loadComments()
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CommentsToProfileUserSegue" {
            let profileUserVC = segue.destination as! ProfileUserViewController
            let user = sender as! UserModel
            profileUserVC.user = user
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(_ notification : NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.constrainToButtom.constant = keyboardFrame.height - self.view.safeAreaInsets.bottom
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
        Api.post_comments.observePost_Comments(withPostId: postId) { (commentId) in
            Api.comment.observeComment(withCommentId: commentId, completion: { (comment) in
                self.fetchUser(uid: comment.uid!,completed: {
                    self.comments.append(comment)
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {Api.user.observeUser(withUid: uid) { (user) in
        self.users.append(user)
        completed()
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

        guard let newCommentId = Api.comment.REF_COMMENT.childByAutoId().key else {
            return
        }
        let newCommentRef = Api.comment.REF_COMMENT.child(newCommentId)
        guard let uid = Api.user.CURRENT_USER?.uid else {
            return
        }
        newCommentRef.setValue(["commentText":commentTextField.text!,"uid":uid]) { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            let words = self.commentTextField.text!.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            for var word in words {
                if word.hasPrefix("#") {
                    word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                    let newHashtagRef = Api.hashtag.REF_HASHTAG.child(word.lowercased())
                    newHashtagRef.updateChildValues([self.postId!: true], withCompletionBlock: { (error, ref) in
                        print(error)
                        print(ref)
                    })  //([self.postId: true])
                }
            }
            
            Api.post_comments.REF_POST_COMMENTS.child(self.postId).child(newCommentId).setValue(true, withCompletionBlock: { (error, ref) in
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
        cell.delegate = self
        return cell
    }
}

extension CommentsViewController: CommentCellDelegate {
    func goToProfileUserVC(withUser user: UserModel) {
        performSegue(withIdentifier: "CommentsToProfileUserSegue", sender: user)
    }
}
