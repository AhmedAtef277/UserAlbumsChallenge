//
//  AlbumDetailsViewModel.swift
//  UserAlbumsChallenge
//
//  Created by mac on 21/12/2024.
//

import Foundation
import Combine

final class AlbumDetailsViewModel {
    
    // MARK: - Properties
    @Published private var albumPhotos: [Photo]?
    @Published private var errorMessage: String?

    private var filteredPhotos: [Photo] = []
    private let selectedAlbumId: Int
    private let repository: AlbumDetailsRepositoryType
    let selectedAlbumTitle: String
    
    // MARK: - Init
    init(repository: AlbumDetailsRepositoryType = UserAlbumRepository(),
         selectedAlbumId: Int,
         selectedAlbumTitle: String) {
        self.repository = repository
        self.selectedAlbumId = selectedAlbumId
        self.selectedAlbumTitle = selectedAlbumTitle
        loadAlbumPhotos()
    }
    
    // MARK: - Private methods
    private func loadAlbumPhotos() {
        Task { @MainActor in
            do {
                let albumPhotos = try await repository.getAlbumPhotos(albumId: selectedAlbumId)
                self.albumPhotos = albumPhotos
                self.filteredPhotos = albumPhotos
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func filterPhotosBy(title searchText: String) -> [Photo] {
        if let filteredPhotos = searchText.isEmpty ? albumPhotos : albumPhotos?.filter({ $0.title.localizedCaseInsensitiveContains(searchText) }) {
            return filteredPhotos
        }
        return []
    }
}

//MARK: - Inputs
extension AlbumDetailsViewModel: AlbumDetailsViewModelInputType {
    func updateFilteredPhotos(accordingTo searchText: String) {
        filteredPhotos = filterPhotosBy(title: searchText)
    }
}

// MARK: - Outputs
extension AlbumDetailsViewModel: AlbumDetailsViewModelOutputType {
    var albumPhotosPublisher: AnyPublisher<[Photo]?, Never> {
        $albumPhotos
            .eraseToAnyPublisher()
    }
    
    var errorMessagePublisher: AnyPublisher<String?, Never> {
        $errorMessage
            .eraseToAnyPublisher()
    }
    
    func getAlbumPhotos(at indexPath: IndexPath) -> Photo {
        guard let photo = albumPhotos?[indexPath.row] else { fatalError() }
        return photo
    }
    
    func getFilteredPhotosCount() -> Int {
        filteredPhotos.count
    }
}

