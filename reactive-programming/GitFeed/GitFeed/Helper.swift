//
//  Helper.swift
//  GitFeed
//
//  Created by Long Vu on 7/13/21.
//  Copyright © 2021 Ray Wenderlich. All rights reserved.
//

import Foundation

func cachedFileURL(_ fileName: String) -> URL {
  return FileManager.default
    .urls(for: .cachesDirectory, in: .allDomainsMask)
    .first!
    .appendingPathComponent(fileName)
}
