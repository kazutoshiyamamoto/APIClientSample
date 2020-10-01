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

