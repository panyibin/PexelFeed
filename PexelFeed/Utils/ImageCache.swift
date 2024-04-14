//
//  ImageCache.swift
//  PexelFeed
//
//  Created by yibin on 2024/4/14.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    var cache:[String:Data] = [:]
    
    private init(){}
}
