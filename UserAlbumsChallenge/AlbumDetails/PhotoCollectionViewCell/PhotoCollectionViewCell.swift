//
//  PhotoCollectionViewCell.swift
//  UserAlbumsChallenge
//
//  Created by mac on 21/12/2024.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak private var photoImageView: UIImageView!
    
    //MARK: - Properties
    static let identifier = String(describing: PhotoCollectionViewCell.self)
    
    //MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.cancelLoad()
        photoImageView.image = nil
    }
    
    func configure(photoURL: URL) {
        photoImageView.loadImage(from: photoURL)
    }
}
