//
//  URLSessionMock.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 9.09.2024.
//

import Foundation

@testable import recipes_uikit

final class URLSessionMock: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        guard let data = data, let response = response else {
            throw URLError(.badServerResponse)
        }
        return (data, response)
    }
}
