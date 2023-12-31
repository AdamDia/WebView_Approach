//
//  NetworkService.swift
//  WebView_Approach
//
//  Created by Adam Essam on 10/12/2023.
//

import Foundation
import Network

protocol NetworkService {
    func downloadFile(from url: URL, completion: @escaping (Result<URL, Error>) -> Void)
}

class NetworkServiceManager: NetworkService {
    private let session: URLSession
    private let networkChecker: NetworkChecking
    
    
    init(session: URLSession = .shared, networkChecker: NetworkChecking = NetworkChecker()) {
            self.session = session
        self.networkChecker = networkChecker
    }
    
    
    func downloadFile(from url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        networkChecker.isNetworkAvailable { [weak self] isAvailable in
            guard isAvailable else {
                completion(.failure(NetworkError.noInternetConnection))
                return
            }
            let task = self?.session.downloadTask(with: url) { localURL, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                guard let localURL = localURL else {
                    completion(.failure(NetworkError.invalidLocalURL))
                    return
                }
                completion(.success(localURL))
            }
            task?.resume()
        }
    }
}

//MARK: - Netwrok Error
    enum NetworkError: Error, LocalizedError {
        case invalidResponse
        case invalidLocalURL
        case noInternetConnection
        
        var errorDescription: String? {
            switch self {
            case .invalidResponse:
                return "The server responded with an invalid response."
            case .invalidLocalURL:
                return "The downloaded file's URL is invalid."
            case .noInternetConnection:
                return "No internet connection is available."
            }
        }
    }
