//
//  MockFileDownloader.swift
//  WebView_ApproachTests
//
//  Created by Adam Essam on 11/12/2023.
//

import Foundation
@testable import WebView_Approach

class MockFileDownloader: FileDownloading {
    var result: FileDownloadResult?

    func downloadFileIfNeeded(completion: @escaping (FileDownloadResult) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let result = self.result {
                completion(result)
            }
        }
    }
}


