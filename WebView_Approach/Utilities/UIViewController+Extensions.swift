//
//  UIViewController+Extensions.swift
//  WebView_Approach
//
//  Created by Adam Essam on 11/12/2023.
//

import UIKit

extension UIViewController {
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
