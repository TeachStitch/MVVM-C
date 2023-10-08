//
//  UIImage.swift
//

import UIKit

extension UIImageView {
    
    func downloadImage(from url: URL, placeholder: UIImage? = nil, contentMode mode: UIView.ContentMode = .scaleAspectFit, completion: ResultClosure<UIImage, Error>? = nil) {
        contentMode = mode
        image = placeholder
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data,
                error == nil,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion?(.failure(error ?? NSError()))
                }
                return
            }
            
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                completion?(.success(image))
            }
        }.resume()
    }
    
    func downloadImage(from link: String, placeholder: UIImage? = nil, contentMode mode: UIView.ContentMode = .scaleAspectFit, completion: ResultClosure<UIImage, Error>? = nil) {
        guard let url = URL(string: link) else {
            completion?(.failure(NSError()))
            return
        }
        downloadImage(from: url, placeholder: placeholder, contentMode: contentMode, completion: completion)
    }
}

// MARK: - Resize
extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func withInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: size.width + insets.left + insets.right,
                   height: size.height + insets.top + insets.bottom), false, scale)
        _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}

// MARK: - JPEGQuality
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
