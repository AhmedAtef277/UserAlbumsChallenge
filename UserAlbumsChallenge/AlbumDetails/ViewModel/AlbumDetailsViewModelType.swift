//
//  AlbumDetailsViewModelType.swift
//  UserAlbumsChallenge
//
//  Created by mac on 21/12/2024.
//

import Foundation
import Combine

protocol AlbumDetailsViewModelType {
    var albumPhotosPubliser: AnyPublisher<([Photo], albumTitle: String)?, Never> { get }
}
