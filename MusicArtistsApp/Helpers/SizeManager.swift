//
//  SizeManager.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 2.06.22.
//

import Foundation

final class SizeManager {
    
    enum Method {
        case FIFO
        case LIFO
    }
    
    static let maxAllowedBytes = 10_000_000
    
    fileprivate static func calculateSize(of fileURLs: [URL]) -> UInt64 {
        
        var size: UInt64 = 0
        
        fileURLs.forEach { url in
            guard let fileSize = url.fileSize else {
                return
            }
            size += fileSize
        }
        
        return size
    }
    
    static func checkAndRemove(for filePath: URL, sizeOfNewFile: UInt64, method: Method) {
        
        let fileURLs = try! FileManager.default.contentsOfDirectory(at: URL.documents, includingPropertiesForKeys: nil)
        
        // hardcoded allowed size, because i don't know how much is acceptable (this way we can test it with two pictures)
        if calculateSize(of: fileURLs) + sizeOfNewFile > maxAllowedBytes {
            
            switch method {
            case .FIFO:
                do {
                    if let lastFile = fileURLs.last {
                        try FileManager.default.removeItem(at: lastFile)
                    }
                } catch {
                    print("Memory optimizing error...")
                }
            case .LIFO:
                do {
                    if let firstFile = fileURLs.first {
                        try FileManager.default.removeItem(at: firstFile)
                    }
                } catch {
                    print("Memory optimizing error...")
                }
            }
        }
        
    }
    
}
