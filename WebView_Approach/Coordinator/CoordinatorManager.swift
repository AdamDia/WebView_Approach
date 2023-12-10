//
//  CoordinatorManager.swift
//  WebView_Approach
//
//  Created by Adam Essam on 09/12/2023.
//

import UIKit

protocol Coordinator {
    func start()
}


class WebCoordinator: Coordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let webViewController = createWebViewController()
        navigationController.pushViewController(webViewController, animated: true)
    }
    
    private func createWebViewController() -> WebViewController {
        let fileDownloader = FileDownloader(
            networkService: NetworkServiceManager(),
            fileManagerService: FileManagerServiceImpl(),
            unzipService: UnzipServiceImpl()
        )
        let viewModel = WebContentViewModel(fileDownloader: fileDownloader)
        return WebViewController(viewModel: viewModel)
    }
}
