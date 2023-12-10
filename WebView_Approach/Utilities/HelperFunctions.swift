//
//  HelperFunctions.swift
//  WebView_Approach
//
//  Created by Adam Essam on 08/12/2023.
//

import UIKit

func convertImageToBase64(imageName: String) -> String? {
    guard let image = UIImage(named: imageName),
          let imageData = image.pngData() else { return nil }
    
    return imageData.base64EncodedString()
}

extension UIViewController {
     func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
