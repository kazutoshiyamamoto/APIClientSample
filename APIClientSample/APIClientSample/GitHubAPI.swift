//
//  GitHubAPI.swift
//  APIClientSample
//
//  Created by home on 2020/10/02.
//  Copyright © 2020 Swift-beginners. All rights reserved.
//

import Foundation

// 型Aか型Bのどちらかのオブジェクトを表す型。
// たとえば、Either<String, Int>は文字列か整数のどちらかを意味する。
// なお、慣例的にどちらの型かを左右で表現することが多い。
// Result型を使えばここいらなくなるかも？
enum Either<Left, Right> {
    /// Eigher<A, B> の A の方の型。
    case left(Left)
    
    /// Eigher<A, B> の B の方の型。
    case right(Right)
    
    // もし、左側の型ならその値を、右側の型ならnilを返す。
    var left: Left? {
        switch self {
        case let .left(x):
            return x
            
        case .right:
            return nil
        }
    }
    
    // もし、右側の型ならその値を、左側の型ならnilを返す。
    var right: Right? {
        switch self {
        case .left:
            return nil
            
        case let .right(x):
            return x
        }
    }
}

// GitHub Zen APIの結果（現在のCodableにあたる？）
struct GitHubZen {
    let text: String
    
    // レスポンスからわかりやすいオブジェクトへと変換する関数。
    // ただし、サーバーがエラーを返してきた場合などは変換できないので、
    // その場合はエラーを返す。つまり、戻り値はエラーがわかりやすいオブジェクトになる。
    // このような、「どちらか」を意味するEitherという型で表現する。
    // GitHubZenが左でなく右なのは、正しいとRightをかけた慣例。
    // Result型を使えばここいらなくなるかも？
    static func from(response: Response) -> Either<TransformError, GitHubZen> {
        
    }
    
    // GitHubZenAPIの変換で起きうるエラーの一覧
    enum TransformError {
        // HTTPステータスコードがOK以外だった場合のエラー
        case unexpectedStatusCode(debugInfo: String)
        
        // ペイロードが壊れた文字列だった場合のエラー
        case malformedData(debugInfo: String)
    }
}
