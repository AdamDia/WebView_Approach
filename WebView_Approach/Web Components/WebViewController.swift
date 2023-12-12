//
//  WebViewController.swift
//  WebView_Approach
//
//  Created by Adam Essam on 03/12/2023.
//
import UIKit
import WebKit
import RxSwift
import RxCocoa

class WebViewController: UIViewController, WKNavigationDelegate {
    
    
    var webView: WKWebView!
    private let disposeBag = DisposeBag()
    private var loadingIndicator: UIActivityIndicatorView!
    private lazy var webContentLoader: WebContentLoader = {
        return WebContentLoader(webView: self.webView, webContentModifier: self.webContentModifier)
    }()
    private let webContentModifier: WebContentModifier
    private let viewModel: WebContentViewModelProtocol
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
        prepareLoadingIndicator()
        view.backgroundColor = .white
    }
    
    
    //  Dependency injection for ViewModel
    init(viewModel: WebContentViewModelProtocol) {
        self.viewModel = viewModel
        self.webContentModifier = WebContentModifier()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func prepareLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = .black
        webView.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor)
        ])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.loadContent()
    }
    
    private func bindViewModel() {
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.htmlContent
            .subscribe(onNext: { [weak self] webContent in
                self?.webContentLoader.loadWebViewWithContent(webContent.html, originalPath: webContent.originalPath)
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            })
            .disposed(by: disposeBag)
        
    }
    
    // Handles post-load modifications to the web content
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let script = getButtonClickScript(imageName: "micky")
        webView.evaluateJavaScript(script) { result, error in
            if let error = error {
                print("Error injecting script: \(error)")
            }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        // Returns the URL to the documents directory
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getButtonClickScript(imageName: String) -> String {
        guard let image = convertImageToBase64(imageName: imageName) else { return "" }
        return """
           function handleButtonClick() {
               var images = document.getElementsByTagName('img');
               for (var i = 0; i < images.length; i++) {
                   if (images[i].src.includes('image.jpeg')) {
                       images[i].src = 'data:image/png;base64,\(image)';
                       break;
                   }
               }
           }
           """
    }
}
