//
//  APIService.swift
//  UserAlbumsChallenge
//
//  Created by mac on 20/12/2024.
//

import Moya
import Foundation

enum APIService {
    case getUserProfile(userId: Int)
    case getUserAlbums(userId: Int)
    case getAlbumPhotos(albumId: Int)
}

extension APIService: TargetType {
    var baseURL: URL {
        URL(string: "https://jsonplaceholder.typicode.com")!
    }

    var path: String {
        switch self {
        case .getUserProfile(let userId):
            return "/users/\(userId)"
        case .getUserAlbums:
            return "/albums"
        case .getAlbumPhotos:
            return "/photos"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUserProfile, .getUserAlbums, .getAlbumPhotos:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getUserAlbums(let userId):
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.queryString)
        case .getAlbumPhotos(let albumId):
            return .requestParameters(parameters: ["albumId": albumId], encoding: URLEncoding.queryString)
        case .getUserProfile:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

