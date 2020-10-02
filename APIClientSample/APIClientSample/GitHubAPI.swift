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
        switch response.statusCode {
        case .ok:
            // HTTPステータスがOKだったら、ペイロードの中身を確認する
            // ZenAPIはUTF-8で符号化された文字列を返すはずのでDataをUTF-8 として解釈してみる
            guard let string = String(data: response.payload, encoding: .utf8) else {
                // もし、DataがUTF-8の文字列でなければ、誤って画像などを受信してしまったのかもしれない
                // この場合は、malformedDataエラーを返す（エラーの型は左なので .left を使う）
                return .left(.malformedData(debugInfo: "not UTF-8 string"))
            }
            
            // もし、内容をUTF-8で符号化された文字列として読み取れたなら、
            // その文字列からGitHubZenを作って返す（エラーではない型は右なので .right を使う）
            return .right(GitHubZen(text: string))
            
        default:
            // もし、HTTPステータスコードがOK以外であれば、エラーとして扱う
            // たとえば、GitHub APIを呼び出しすぎたときは200OKではなく403Forbiddenが返るのでこちらにくる
            return .left(.unexpectedStatusCode(
                // エラーの内容がわかりやすいようにステータスコードを入れて返す
                debugInfo: "\(response.statusCode)")
            )
        }
    }
    
    // GitHubZenAPIの変換で起きうるエラーの一覧
    enum TransformError {
        // HTTPステータスコードがOK以外だった場合のエラー
        case unexpectedStatusCode(debugInfo: String)
        
        // ペイロードが壊れた文字列だった場合のエラー
        case malformedData(debugInfo: String)
    }
}
