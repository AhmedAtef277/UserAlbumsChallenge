//
//  PhotoCollectionViewCell.swift
//  UserAlbumsChallenge
//
//  Created by mac on 21/12/2024.
//

import UIKit
import Kingfisher

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak private var photoImageView: UIImageView!
    
    //MARK: - Properties
    static let identifier = String(describing: PhotoCollectionViewCell.self)
    
    //MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.kf.cancelDownloadTask()
        photoImageView.image = nil
    }
    
    func configure(photoURL: URL) {
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(with: photoURL, options: [.retryStrategy(DelayRetryStrategy(
            maxRetryCount: 5,
            retryInterval: .seconds(3)
          ))])
    }
}
