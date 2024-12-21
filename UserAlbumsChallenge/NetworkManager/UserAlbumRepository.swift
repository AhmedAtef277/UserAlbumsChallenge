//
//  UserAlbumRepository.swift
//  UserAlbumsChallenge
//
//  Created by mac on 21/12/2024.
//

import Foundation

protocol UserAlbumRepositoryType {
    func getUserProfile(userId: Int) async throws -> UserProfile
    func getUserAlbums(userId: Int) async throws -> [Album]
}

protocol AlbumDetailsRepositoryType {
    func getAlbumPhotos(albumId: Int) async throws -> [Photo]
}

struct UserAlbumRepository: UserAlbumRepositoryType {
    
    private let networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getUserProfile(userId: Int) async throws -> UserProfile {
        try await networkManager.request(.getUserProfile(userId: userId), responseType: UserProfile.self)
    }

    func getUserAlbums(userId: Int) async throws -> [Album] {
        try await networkManager.request(.getUserAlbums(userId: userId), responseType: [Album].self)
    }

}

extension UserAlbumRepository: AlbumDetailsRepositoryType {
    func getAlbumPhotos(albumId: Int) async throws -> [Photo] {
        try await networkManager.request(.getAlbumPhotos(albumId: albumId), responseType: [Photo].self)
    }
}
