//
//  UnzipService.swift
//  WebView_Approach
//
//  Created by Adam Essam on 10/12/2023.
//

import UIKit
import Zip

protocol UnzipService {
    func unzipFile(at: URL, to destination: URL, completion: @escaping (Result<Void, Error>) -> Void)
}

class UnzipServiceImpl: UnzipService {
    func unzipFile(at: URL, to destination: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Zip.unzipFile(at, destination: destination, overwrite: true, password: nil)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}