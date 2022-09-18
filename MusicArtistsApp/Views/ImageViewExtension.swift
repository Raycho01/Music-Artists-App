//
//  ImageViewExtension.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 2.06.22.
//

import UIKit

extension UIImageView {
    
    func setImageWith(url: URL, placeholderImage: UIImage) {

        self.image = placeholderImage
        
        if let image = CacheManager.loadImageFromDiskWith(fileName: url.absoluteString) {
            self.image = image
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil, let data = data, let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
            
            CacheManager.saveImage(webURL: url.absoluteString, image: image)
            
        }
        task.resume()
        
    }
    
    func setImageColor(color: UIColor) {
        
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
}
