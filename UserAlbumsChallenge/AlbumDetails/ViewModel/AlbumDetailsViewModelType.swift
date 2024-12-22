//
//  AlbumDetailsViewModelType.swift
//  UserAlbumsChallenge
//
//  Created by mac on 21/12/2024.
//

import Foundation
import Combine

typealias AlbumDetailsViewModelType = AlbumDetailsViewModelOutputType & AlbumDetailsViewModelInputType

protocol AlbumDetailsViewModelOutputType {
    var albumPhotosPublisher: AnyPublisher<[Photo]?, Never> { get }
    var errorMessagePublisher: AnyPublisher<String?, Never> { get }
    var selectedAlbumTitle: String { get }
    func getAlbumPhotos(at indexPath: IndexPath) -> Photo
    func getFilteredPhotosCount() -> Int
    
}

protocol AlbumDetailsViewModelInputType {
    func updateFilteredPhotos(accordingTo searchText: String)
}

