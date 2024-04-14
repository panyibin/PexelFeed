//
//  Models.swift
//  PexelFeed
//
//  Created by yibin on 2024/4/14.
//

import Foundation

struct Photo:Decodable {
    let id:Int
    let url:String
    let photographer:String
    let src: Src
    let alt:String
    
    struct Src: Decodable {
        let small:String
        let large:String
        let portrait:String
        let landscape:String
    }
}

struct PexelsResponse :Decodable {
    let photos:[Photo]
}
