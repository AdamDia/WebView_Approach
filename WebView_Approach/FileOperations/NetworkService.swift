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
    private let monitor = NWPathMonitor()
    
    func isNetworkAvailable(completion: @escaping (Bool) -> Void) {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                completion(true)
            } else {
                completion(false)
            }
            self.monitor.cancel()
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func downloadFile(from url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        isNetworkAvailable { isAvailable in
            guard isAvailable else {
                completion(.failure(NetworkError.noInternetConnection))
                return
            }
            let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
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
            task.resume()
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
