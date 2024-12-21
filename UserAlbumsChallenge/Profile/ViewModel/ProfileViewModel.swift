//
//  ProfileViewModel.swift
//  UserAlbumsChallenge
//
//  Created by mac on 21/12/2024.
//

import Foundation
import Combine

final class ProfileViewModel: ProfileViewModelType {
    
    private let repository: UserAlbumRepositoryType
    private let router: ProfileRouterType
    @Published private var userProfile: UserProfile?
    @Published private var userAlbums: [Album]?
    private let randomUser = (1...10).randomElement()
    
    init(repository: UserAlbumRepositoryType = UserAlbumRepository(),
         router: ProfileRouterType = ProfileRouter()) {
        self.repository = repository
        self.router = router
        loadUserProfile()
        loadUserAlbums()
    }
    
    private func loadUserProfile() {
        Task { @MainActor in
            do {
                let userProfile = try await repository.getUserProfile(userId: randomUser ?? 1)
                self.userProfile = userProfile
            } catch {
                
            }
        }
    }
    
    private func loadUserAlbums() {
        Task { @MainActor in
            do {
                let userAlbums = try await repository.getUserAlbums(userId: randomUser ?? 1)
                self.userAlbums = userAlbums
            } catch {
                
            }
        }
    }

    
}

// MARK: - Outputs
extension ProfileViewModel {
    var userProfilePubliser: AnyPublisher<UserProfile?, Never> {
        $userProfile
            .eraseToAnyPublisher()
    }
    
    var userAlbumsPubliser: AnyPublisher<[Album]?, Never> {
        $userAlbums
            .eraseToAnyPublisher()
    }
    func getFullAddress() -> String {
        "\(userProfile?.address.city ?? "") \(userProfile?.address.street ?? "")"
    }
    
    func didSelectAlbum(With id: Int, albumTitle: String, source: ViewControllerType) {
        router.navigateToAlbumPhotos(with: id, albumTitle: albumTitle, source: source)
    }
    
    func getItem(at indexPath: IndexPath) -> Album? {
        userAlbums?[indexPath.row]
    }
    
    func getAlbumsCount() -> Int {
        userAlbums?.count ?? 0
    }
}
