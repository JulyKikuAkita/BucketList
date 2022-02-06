//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Ifang Lee on 2/6/22.
//

import Foundation

extension FileManager {
    static var documentDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
