//
//  URLextension.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 6.06.22.
//

import Foundation

extension URL {

    static var documents: URL {
        return FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    var fileSize: UInt64? {
        return attributes?[.size] as? UInt64
    }

    var fileSizeString: String {
        guard let fileSize = fileSize else {
            return "No file size."
        }

        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

}
