//
//  KingfisherWrapper.swift
//  UserAlbumsChallenge
//
//  Created by mac on 22/12/2024.
//

import UIKit
import Kingfisher

/// Protocol to abstract image loading functionality
public protocol ImageLoader {
    /// Loads an image from a URL and displays it in the calling UIImageView
    /// - Parameters:
    ///   - url: The URL of the image to load
    ///   - placeholder: An optional placeholder image to display while loading
    ///   - showIndicator: Whether to show a loading indicator while loading
    ///   - completion: Completion handler with success or failure result
    func loadImage(
        from url: URL,
        placeholder: UIImage?,
        showIndicator: Bool,
        completion: ((Result<Void, Error>) -> Void)?
    )

    /// Cancels an image download in progress for the calling UIImageView
    func cancelLoad()
}

/// Extension for UIImageView to conform to ImageLoader protocol
extension UIImageView: ImageLoader {

    public func loadImage(
        from url: URL,
        placeholder: UIImage? = nil,
        showIndicator: Bool = true,
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) {
        if showIndicator {
            self.kf.indicatorType = .activity
        } else {
            self.kf.indicatorType = .none
        }

        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.transition(.fade(0.3))],
            completionHandler: { result in
                switch result {
                case .success:
                    completion?(.success(()))
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        )
    }

    public func cancelLoad() {
        self.kf.cancelDownloadTask()
    }
}
