//
//  FileDownloader.swift
//  WebView_Approach
//
//  Created by Adam Essam on 06/12/2023.
//

import Foundation

protocol FileDownloading {
    func downloadFileIfNeeded(completion: @escaping (URL?) -> Void)
}

class FileDownloader: FileDownloading {
    
    private let networkService: NetworkService
    private let fileManagerService: FileManagerService
    private let unzipService: UnzipService
    private let hasDownloadedFileKey = "hasDownloadedFile"
    private let hasUnzippedFileKey = "hasUnzippedFile"
    private let downloadURLString = "https://pstaticlanguage.blob.core.windows.net/consumer-kit/simplified-wrapper.zip"

    init(networkService: NetworkService, fileManagerService: FileManagerService, unzipService: UnzipService) {
        self.networkService = networkService
        self.fileManagerService = fileManagerService
        self.unzipService = unzipService
    }

    func downloadFileIfNeeded(completion: @escaping (URL?) -> Void) {
        let defaults = UserDefaults.standard

        if defaults.bool(forKey: hasUnzippedFileKey) {
            completion(getIndexPath())
            return
        }

        if defaults.bool(forKey: hasDownloadedFileKey) {
            unzipDownloadedFile(completion: completion)
            return
        }

        guard let url = URL(string: downloadURLString) else {
            print("Invalid URL for file download.")
            completion(nil)
            return
        }

        downloadAndUnzipFile(from: url, completion: completion)
    }

    private func getIndexPath() -> URL? {
        let documentsDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let contentDirectory = documentsDirectory?.appendingPathComponent("unzippedContent", isDirectory: true)
        return contentDirectory?.appendingPathComponent("index.html")
    }

    private func unzipDownloadedFile(completion: @escaping (URL?) -> Void) {
        let documentsDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        guard let zipFilePath = documentsDirectory?.appendingPathComponent("simplified-wrapper.zip"),
              let contentDirectory = documentsDirectory?.appendingPathComponent("unzippedContent", isDirectory: true) else {
            completion(nil)
            return
        }

        unzipService.unzipFile(at: zipFilePath, to: contentDirectory) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    UserDefaults.standard.set(true, forKey: self?.hasUnzippedFileKey ?? "")
                    completion(self?.getIndexPath())
                case .failure(let error):
                    print("An error occurred while unzipping: \(error)")
                    completion(nil)
                }
            }
        }
    }

    private func downloadAndUnzipFile(from url: URL, completion: @escaping (URL?) -> Void) {
        networkService.downloadFile(from: url) { [weak self] result in
            switch result {
            case .success(let localURL):
                self?.moveAndUnzipFile(localURL, completion: completion)
            case .failure(let error):
                print("Error downloading file: \(error)")
                completion(nil)
            }
        }
    }

    private func moveAndUnzipFile(_ localURL: URL, completion: @escaping (URL?) -> Void) {
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let zipFilePath = documentsDirectory.appendingPathComponent("simplified-wrapper.zip")
            try fileManagerService.moveItem(at: localURL, to: zipFilePath)
            unzipDownloadedFile(completion: completion)
        } catch {
            print("An error occurred during file operations: \(error)")
            completion(nil)
        }
    }
}


