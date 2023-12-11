//
//  ImageConversionUtils.swift
//  WebView_Approach
//
//  Created by Adam Essam on 11/12/2023.
//


import UIKit

func convertImageToBase64(imageName: String) -> String? {
    guard let image = UIImage(named: imageName),
          let imageData = image.pngData() else { return nil }
    
    return imageData.base64EncodedString()
}
