//
//  GitHubAPI.swift
//  APIClientSample
//
//  Created by home on 2020/10/02.
//  Copyright © 2020 Swift-beginners. All rights reserved.
//

import Foundation

// GitHub Zen APIの結果（現在のCodableにあたる？）
struct GitHubZen {
    let text: String
    
    // レスポンスからわかりやすいオブジェクトへ変換する関数
    static func from(response: Response) -> GitHubZen {
        
    }
}
