//
//  ProfileViewModelType.swift
//  UserAlbumsChallenge
//
//  Created by mac on 21/12/2024.
//

import Foundation
import Combine

protocol ProfileViewModelType {
    var userProfilePubliser: AnyPublisher<UserProfile?, Never> { get }
    var userAlbumsPubliser: AnyPublisher<[Album]?, Never> { get }
    func getFullAddress() -> String
    func didSelectAlbum(With id: Int, albumTitle: String, source: ViewControllerType)
    func getItem(at indexPath: IndexPath) -> Album?
    func getAlbumsCount() -> Int
}
