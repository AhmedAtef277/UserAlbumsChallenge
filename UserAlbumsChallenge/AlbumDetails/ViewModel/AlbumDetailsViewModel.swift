//
//  AlbumDetailsViewModel.swift
//  UserAlbumsChallenge
//
//  Created by mac on 21/12/2024.
//

import Foundation
import Combine

final class AlbumDetailsViewModel: AlbumDetailsViewModelType {
    
    @Published private var albumPhotos: ([Photo], albumTitle: String)?
    private let selectedAlbumId: Int
    private let selectedAlbumTitle: String
    private let repository: AlbumDetailsRepositoryType
    
    init(repository: AlbumDetailsRepositoryType = UserAlbumRepository(),
         selectedAlbumId: Int,
         selectedAlbumTitle: String) {
        self.repository = repository
        self.selectedAlbumId = selectedAlbumId
        self.selectedAlbumTitle = selectedAlbumTitle
        loadAlbumPhotos()
    }
    
    func loadAlbumPhotos() {
        Task { @MainActor in
            do {
                let albumPhotos = try await repository.getAlbumPhotos(albumId: selectedAlbumId)
                self.albumPhotos = (albumPhotos, selectedAlbumTitle)
            } catch {
                
            }
        }
    }
    
    var albumPhotosPubliser: AnyPublisher<([Photo], albumTitle: String)?, Never> {
        $albumPhotos
            .eraseToAnyPublisher()
    }
}
