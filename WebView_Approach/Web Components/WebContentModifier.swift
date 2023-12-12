//
//  WebContentModifier.swift
//  WebView_Approach
//
//  Created by Adam Essam on 12/12/2023.
//

import Foundation

class WebContentModifier {
    func modifyContent(_ htmlContent: String, imageName: String) -> String {
        var modifiedHtmlContent = htmlContent
        
        if let base64ImageString = convertImageToBase64(imageName: imageName) {
            let script = """
                <script>
                document.addEventListener('DOMContentLoaded', (event) => {
                    document.getElementById('the_other_image').src = 'data:image/png;base64,\(base64ImageString)';
                });
                </script>
            """
            modifiedHtmlContent = modifiedHtmlContent.replacingOccurrences(of: "</head>", with: "\(script)</head>")
        }
        
        return modifiedHtmlContent
    }
}
