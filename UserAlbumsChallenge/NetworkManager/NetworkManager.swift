//
//  NetworkManager.swift
//  UserAlbumsChallenge
//
//  Created by mac on 20/12/2024.
//

import Foundation
import Moya

protocol NetworkManagerType {
    func request<T: Decodable>(_ target: APIService, responseType: T.Type) async throws -> T
}

struct NetworkManager: NetworkManagerType {
    private let provider: MoyaProvider<APIService>

    init(provider: MoyaProvider<APIService> = MoyaProvider<APIService>()) {
        self.provider = provider
    }

    func request<T: Decodable>(_ target: APIService, responseType: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(responseType, from: response.data)
                        continuation.resume(returning: decodedResponse)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
