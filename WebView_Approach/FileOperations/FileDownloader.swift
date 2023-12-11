//
//  FileDownloader.swift
//  WebView_Approach
//
//  Created by Adam Essam on 06/12/2023.
//

import Foundation

typealias FileDownloadResult = Result<URL, FileDownloaderError>

enum FileDownloaderError: Error {
    case invalidURL
    case unzipFailed(Error)
    case downloadFailed(NetworkError)
    case fileOperationFailed(Error)
}

protocol FileDownloading {
    func downloadFileIfNeeded(completion: @escaping (FileDownloadResult) -> Void)
}

class FileDownloader: FileDownloading {
    
    private let networkService: NetworkService
    private let fileManagerService: FileManagerService
    private let unzipService: UnzipService
    private let hasDownloadedFileKey = "hasDownloadedFile"
    private let hasUnzippedFileKey = "hasUnzippedFile"
    private let downloadURLString = "https://pstaticlanguage.blob.core.windows.net/consumer-kit/simplified-wrapper.zip"
    private var userDefaults: UserDefaultsProtocol
    
    init(networkService: NetworkService, fileManagerService: FileManagerService, unzipService: UnzipService, userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.networkService = networkService
        self.fileManagerService = fileManagerService
        self.unzipService = unzipService
        self.userDefaults = userDefaults
    }


    func downloadFileIfNeeded(completion: @escaping (FileDownloadResult) -> Void) {
        
        if userDefaults.bool(forKey: hasUnzippedFileKey) {
            switch getIndexPath() {
            case .success(let indexPath):
                completion(.success(indexPath))
            case .failure(let error):
                completion(.failure(error))
            }
            return
        }
        
        if userDefaults.bool(forKey: hasDownloadedFileKey) {
            unzipDownloadedFile(completion: completion)
            return
        }
        
        guard let url = URL(string: downloadURLString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        downloadAndUnzipFile(from: url, completion: completion)
    }
    
    private func getIndexPath() -> FileDownloadResult {
        let documentsDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let contentDirectory = documentsDirectory?.appendingPathComponent("unzippedContent", isDirectory: true)
        if let indexPath = contentDirectory?.appendingPathComponent("index.html") {
            return .success(indexPath)
        } else {
            return .failure(.invalidURL)
        }
    }
    
    private func unzipDownloadedFile(completion: @escaping (FileDownloadResult) -> Void) {
        let documentsDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let zipFilePath = documentsDirectory?.appendingPathComponent("simplified-wrapper.zip")
        let contentDirectory = documentsDirectory?.appendingPathComponent("unzippedContent", isDirectory: true)
        
        if zipFilePath == nil || contentDirectory == nil {
            completion(.failure(.fileOperationFailed(FileDownloaderError.invalidURL)))
            return
        }
        
        unzipService.unzipFile(at: zipFilePath!, to: contentDirectory!) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.userDefaults.set(true, forKey: self?.hasUnzippedFileKey ?? "")
                    completion(.success(contentDirectory!.appendingPathComponent("index.html")))
                case .failure(let error):
                    completion(.failure(.unzipFailed(error)))
                }
            }
        }
    }
    
    
    private func downloadAndUnzipFile(from url: URL, completion: @escaping (FileDownloadResult) -> Void) {
        networkService.downloadFile(from: url) { [weak self] result in
            switch result {
            case .success(let localURL):
                self?.userDefaults.set(true, forKey: self?.hasDownloadedFileKey ?? "")
                self?.moveAndUnzipFile(localURL, completion: completion)
            case .failure(let error):
                print("Network service failed with error: \(error)")
                if let networkError = error as? NetworkError {
                    completion(.failure(.downloadFailed(networkError)))
                } else {
                    completion(.failure(.downloadFailed(NetworkError.invalidResponse)))
                }
            }
        }
    }
    
    private func moveAndUnzipFile(_ localURL: URL, completion: @escaping (FileDownloadResult) -> Void) {
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let zipFilePath = documentsDirectory.appendingPathComponent("simplified-wrapper.zip")
            try fileManagerService.moveItem(at: localURL, to: zipFilePath)
            unzipDownloadedFile(completion: completion)
        } catch {
            completion(.failure(.fileOperationFailed(error)))
        }
    }
}


