//
//  ProfileRouter.swift
//  UserAlbumsChallenge
//
//  Created by mac on 21/12/2024.
//

import Foundation

protocol ProfileRouterType {
    func navigateToAlbumPhotos(with albumId: Int,
                               albumTitle: String,
                               source: ViewControllerType)
}

struct ProfileRouter: ProfileRouterType {
    func navigateToAlbumPhotos(with albumId: Int,
                               albumTitle: String,
                               source: ViewControllerType) {
        let viewModel = AlbumDetailsViewModel(selectedAlbumId: albumId, selectedAlbumTitle: albumTitle)
        let controller = AlbumDetailsViewController(viewModel: viewModel)
        source.push(viewController: controller, animated: true)
    }
}
