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
    // コールバックつきのcall関数を用意
    // コールバック関数に与えられる引数は、Output型（レスポンスか通信エラーのどちらか）
    static func call(with input: Input, _ block: @escaping (Output) -> Void) {
        // 実際にサーバーと通信するコードはまだはっきりしていないので、
        // Timer を使って非同期なコード実行だけを再現する
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            
            // 仮のレスポンス
            let response: Response = (
                statusCode: .ok,
                headers: [:],
                payload: "this is a response text".data(using: .utf8)!
            )
            
            // 仮のレスポンスでコールバックを呼び出す
            block(.hasResponse(response))
        }
    }
    
    static func call(with input: Input) {
        self.call(with: input) { _ in
            // NOTE: コールバックでは何もしない
        }
    }
    
    // InputからURLRequestを生成
    static private func createURLRequest(by input: Input) -> URLRequest {
        // URLからURLRequeastを作成
        var request = URLRequest(url: input.url)
        
        // HTTPメソッドを設定
        request.httpMethod = input.methodAndPayload.method
        
        // リクエストの本文を設定
        request.httpBody = input.methodAndPayload.body
        
        // HTTPヘッダを設定
        request.allHTTPHeaderFields = input.headers
        
        return request
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

enum HTTPStatus {
    // HTTPステータスコードでは200にあたる
    case ok
    
    // notFoundのHTTPステータスコードは404
    case notFound
    
    // その他
    case unsupported(code: Int)
    
    static func from(code: Int) -> HTTPStatus {
        switch code {
        case 200:
            // 200はOKの意味
            return .ok
        case 404:
            // 404はnotFoundの意味
            return .notFound
        default:
            // それ以外はまだ対応しない
            return .unsupported(code: code)
        }
    }
}
