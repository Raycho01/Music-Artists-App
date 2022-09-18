//
//  FileManager.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 1.06.22.
//

import UIKit

final class CacheManager {
    
    static func saveImage(webURL: String, image: UIImage) {
        
        let documentDirectoryPath = URL.documents

        guard let data = image.jpegData(compressionQuality: 1),
              let fileName = webURL.components(separatedBy: "/").last else { return }
        
        let fileURL = documentDirectoryPath.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image.")
            } catch let removeError {
                print("Couldn't remove file at path: ", removeError)
            }

        }
        // hardcoded fifo method, because i don't know who should make this decision
        SizeManager.checkAndRemove(for: fileURL, sizeOfNewFile: UInt64(data.count), method: .FIFO)

        try? data.write(to: fileURL, options: Data.WritingOptions.atomic)

    }



    static func loadImageFromDiskWith(fileName: String) -> UIImage? {

        guard let imageName = fileName.components(separatedBy: "/").last else {
            return nil
        }
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(imageName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }

        return nil
    }
    
}
