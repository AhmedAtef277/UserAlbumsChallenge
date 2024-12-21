//
//  ProfileViewModel.swift
//  UserAlbumsChallenge
//
//  Created by mac on 21/12/2024.
//

import Foundation
import Combine

final class ProfileViewModel {
    
    // MARK: - Properties
    @Published private var userProfile: UserProfile?
    @Published private var userAlbums: [Album]?
    @Published private var errorMessage: String?

    private let repository: UserAlbumRepositoryType
    private let router: ProfileRouterType
    private let randomUser = (1...10).randomElement()
    
    // MARK: - Init
    init(repository: UserAlbumRepositoryType = UserAlbumRepository(),
         router: ProfileRouterType = ProfileRouter()) {
        self.repository = repository
        self.router = router
        loadUserProfile()
        loadUserAlbums()
    }
    
    // MARK: - Private methods
    private func loadUserProfile() {
        Task { @MainActor in
            do {
                let userProfile = try await repository.getUserProfile(userId: randomUser ?? 1)
                self.userProfile = userProfile
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func loadUserAlbums() {
        Task { @MainActor in
            do {
                let userAlbums = try await repository.getUserAlbums(userId: randomUser ?? 1)
                self.userAlbums = userAlbums
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

// MARK: - Inputs
extension ProfileViewModel: ProfileViewModelInputType {
    func didSelectAlbum(With id: Int, albumTitle: String, source: ViewControllerType) {
        router.navigateToAlbumPhotos(with: id, albumTitle: albumTitle, source: source)
    }
}

// MARK: - Outputs
extension ProfileViewModel: ProfileViewModelOtputType {
    var userProfilePubliser: AnyPublisher<UserProfile?, Never> {
        $userProfile
            .eraseToAnyPublisher()
    }
    
    var userAlbumsPubliser: AnyPublisher<[Album]?, Never> {
        $userAlbums
            .eraseToAnyPublisher()
    }
    
    var errorMessagePubliser: AnyPublisher<String?, Never> {
        $errorMessage
            .eraseToAnyPublisher()
    }
    
    func getFullAddress() -> String {
        "\(userProfile?.address.city ?? "") \(userProfile?.address.street ?? "")"
    }
    
    func getItem(at indexPath: IndexPath) -> Album? {
        userAlbums?[indexPath.row]
    }
    
    func getAlbumsCount() -> Int {
        userAlbums?.count ?? 0
    }
}
