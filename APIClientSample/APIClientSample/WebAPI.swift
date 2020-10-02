//
//  WebAPI.swift
//  APIClientSample
//
//  Created by home on 2020/10/01.
//  Copyright © 2020 Swift-beginners. All rights reserved.
//

import Foundation

typealias Input = Request

// Requestの構成要素であるURLとクエリ文字列、HTTPヘッダー、ペイロードについて定義
typealias Request = (
    // リクエストの向き先の URL。
    url: URL,
    
    // クエリ文字列。クエリは URLQueryItemという標準のクラスを使っている。
    queries: [URLQueryItem],
    
    // HTTP ヘッダー。ヘッダー名と値の辞書になっている。
    headers: [String: String],
    
    // HTTP メソッドとペイロード（body）の組み合わせ。
    // GET にはペイロードがなく、PUT や POST にはペイロードがあることを
    // 表現するために、後述する enum を使っている。
    methodAndPayload: HTTPMethodAndPayload
)

// Requestで定義したmethodAndPayloadの型であるHTTPMethodAndPayloadを説明している部分
enum HTTPMethodAndPayload {
    /// GET メソッドの定義。
    case get
    
    /// POST メソッドの定義（必要になるまでは省略）。
    // case post(payload: Data?)
    
    /// メソッドの文字列表現。
    var method: String {
        switch self {
        case .get:
            return "GET"
        }
    }
    
    /// ペイロード。ペイロードがないメソッドの場合は nil。
    var body: Data? {
        switch self {
        case .get:
            // GET はペイロードを取れないので nil。
            return nil
        }
    }
}

enum WebAPI {
    // ビルドを通すために call 関数を用意しておく。
    static func call(with input: Input) {
        // TODO: もう少しインターフェースが固まったら実装する。
    }
}

// APIの出力をあらわすenum
enum Output {
    // レスポンスがある場合
    case hasResponse(Response)
    
    // 通信エラーでレスポンスがない場合
    case noResponse(ConnectionError)
}

// 通信エラー
enum ConnectionError {
    // データまたはレスポンスが存在しない場合のエラー。
    case noDataOrNoResponse(debugInfo: String)
}

// APIのレスポンス。構成要素は以下3つ。
typealias Response = (
    // レスポンスの意味をあらわすステータスコード
    statusCode: HTTPStatus,
    
    // HTTPヘッダー
    headers: [String: String],
    
    // レスポンスの本文
    payload: Data
)

