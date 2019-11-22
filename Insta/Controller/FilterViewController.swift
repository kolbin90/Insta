//
//  FilterViewController.swift
//  Insta
//
//  Created by Apple User on 11/21/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var postImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        postImageView.image = postImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func closeBtn_TchUpIns(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func nextBtn_TchUpIns(_ sender: Any) {
    }
    
}

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        
        
        return cell
    }
}
