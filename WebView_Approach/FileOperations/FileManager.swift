//
//  FileManager.swift
//  WebView_Approach
//
//  Created by Adam Essam on 10/12/2023.
//

import Foundation

protocol FileManagerService {
    func moveItem(at: URL, to: URL) throws
}

class FileManagerServiceImpl: FileManagerService {
    func moveItem(at: URL, to: URL) throws {
        try FileManager.default.moveItem(at: at, to: to)
    }
}
