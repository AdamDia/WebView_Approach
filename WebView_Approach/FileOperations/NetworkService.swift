//
//  NetworkService.swift
//  WebView_Approach
//
//  Created by Adam Essam on 10/12/2023.
//

import Foundation

protocol NetworkService {
    func downloadFile(from url: URL, completion: @escaping (Result<URL, Error>) -> Void)
}

class NetworkServiceManager: NetworkService {
    func downloadFile(from url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
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

enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case invalidLocalURL
    
    var errorDescription: String? {
           switch self {
           case .invalidResponse:
               return "The server responded with an invalid response."
           case .invalidLocalURL:
               return "The downloaded file's URL is invalid."
           }
       }
}
