//
//  URLSession+URLSessionProtocol.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 9.09.2024.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
