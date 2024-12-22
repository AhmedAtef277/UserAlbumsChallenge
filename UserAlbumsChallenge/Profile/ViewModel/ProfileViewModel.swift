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
    @Published private var isLoading: Bool = false

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
                isLoading = true
                defer { isLoading = false }
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
                isLoading = true
                defer { isLoading = false }
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
    var userProfilePublisher: AnyPublisher<UserProfile?, Never> {
        $userProfile
            .eraseToAnyPublisher()
    }
    
    var userAlbumsPublisher: AnyPublisher<[Album]?, Never> {
        $userAlbums
            .eraseToAnyPublisher()
    }
    
    var errorMessagePublisher: AnyPublisher<String?, Never> {
        $errorMessage
            .eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading
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
