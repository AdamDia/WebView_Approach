//
//  NetworkChecking.swift
//  WebView_Approach
//
//  Created by Adam Essam on 10/12/2023.
//

import Network

protocol NetworkChecking {
    func isNetworkAvailable(completion: @escaping (Bool) -> Void)
}

class NetworkChecker: NetworkChecking {
    private let monitor = NWPathMonitor()

    func isNetworkAvailable(completion: @escaping (Bool) -> Void) {
        monitor.pathUpdateHandler = { path in
            completion(path.status == .satisfied)
            self.monitor.cancel()
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}

