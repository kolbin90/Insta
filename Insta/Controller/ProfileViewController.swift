//
//  ProfileViewController.swift
//  Insta
//
//  Created by Apple User on 9/18/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        fetchUser()
    }
    
    func fetchUser() {
        Api.user.observeCurrentUser { (user) in
            self.user = user
            self.collectionView.reloadData()
        }
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user {
            headerCell.user = user
        }
        return headerCell
    }
}
