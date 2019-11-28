//
//  FilterViewController.swift
//  Insta
//
//  Created by Apple User on 11/21/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func useFiltredImage(image: UIImage)
}
class FilterViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var postImageHeightConstraint: NSLayoutConstraint!
    
    var delegate: FilterViewControllerDelegate?
    
    var postImage: UIImage?
    let filterNames: [String] = ["CIPhotoEffectTonal","CIPhotoEffectNoir","CIMaximumComponent","CIMinimumComponent","CIDotScreen", "CISepiaTone", "CIFalseColor", "CIColorInvert", "CIColorPosterize", "CIPhotoEffectChrome", "CIPhotoEffectInstant"]
    var filtredImages = [UIImage]()
    let ciContext = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        postImageHeightConstraint.constant = UIScreen.main.bounds.width / (postImage!.size.width / postImage!.size.height)
        postImageView.image = postImage
        filterImages()
    }
    func filterImages() {
        let resizedImage = resizeImage(image: postImage!, newWidht: 100)
        for name in filterNames {
            if let filtredimage = filterImage(image: resizedImage, filterName: name) {
                filtredImages.append(filtredimage)
            }
        }
    }
    
    func filterImage(image: UIImage, filterName: String) -> UIImage? {
        let originalOrientation = postImage!.imageOrientation
        let ciImage = CIImage(image: postImage!)
        let filter = CIFilter(name: filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let filtredImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImage = ciContext.createCGImage(filtredImage, from: filtredImage.extent)
            return UIImage(cgImage: cgImage!, scale: 1.0, orientation: originalOrientation)
        }
        return nil
    }
    
    func resizeImage(image: UIImage, newWidht: CGFloat) -> UIImage {
        let scale = newWidht / image.size.width
        let newHeight = scale * image.size.height
        
        UIGraphicsBeginImageContext(CGSize(width: newWidht, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidht, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    @IBAction func closeBtn_TchUpIns(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func nextBtn_TchUpIns(_ sender: Any) {
        delegate?.useFiltredImage(image: postImageView.image!)
        dismiss(animated: true, completion: nil)
    }
    
}

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtredImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
       
        cell.filterImageView.image = filtredImages[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let filtredImage = filterImage(image: postImage!, filterName: filterNames[indexPath.item]) {
            postImageView.image = filtredImage
        }
    }
}
