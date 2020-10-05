//
//  APIClientSampleTests.swift
//  APIClientSampleTests
//
//  Created by home on 2020/09/30.
//  Copyright © 2020 Swift-beginners. All rights reserved.
//

import XCTest
@testable import APIClientSample

class APIClientSampleTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testRequest() {
        // リクエストを作成する。
        let input: Request = (
            // GitHub の Zen API を指定。
            url: URL(string: "https://api.github.com/zen")!,
            
            // Zen API はパラメータを取らない。
            queries: [],
            
            // 特にヘッダーもいらない。
            headers: [:],
            
            // HTTP メソッドは GET のみ対応している。
            methodAndPayload: .get
        )
        
        // この内容で API を呼び出す（注: WebAPI.call は後で定義する）。
        WebAPI.call(with: input)
    }
    
    func testResopnse() {
        // 仮のレスポンスを定義する。
        let response: Response = (
            statusCode: .ok,
            
            // 読み取るべきヘッダーは特になし
            headers: [:],
            
            payload: "this is a response text".data(using: .utf8)!
        )
        
        // GitHubZen.from関数を呼び出してみる
        let errorOrZen = GitHubZen.from(response: response)
        
        // 結果は、エラーか禅なフレーズのどちらか
        switch errorOrZen {
        case let .left(error):
            // 上の仮のレスポンスであれば、エラーにはならないはず
            // そういう場合は、XCTFail という関数でこちらにきてしまったことをわかるようにする。
            XCTFail("\(error)")
            
        case let .right(zen):
            // 上の仮のレスポンスの禅なフレーズをちゃんと読み取れたかどうか検証したい
            // そういう場合は、XCTAssertEqual という関数で内容があっているかどうかを検証する
            XCTAssertEqual(zen.text, "this is a response text")
        }
    }
}

class ExampleAsyncTests: XCTestCase {
    func testAsync() {
        // XCTestExpectationオブジェクトを作成する。
        // これを作成した時点で、動作確認のモードが非同期モードになる。
        let expectation = self.expectation(description: "非同期に待つ")
        
        // 1秒経過したら、expectation.fulfill を実行する。
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            expectation.fulfill()
        }
        
        // 動作確認が完了するまで、10 秒待つ。
        // 10 秒たっても expectation.fulfill が呼ばれなければ、
        // 何かがおかしいので、わかりやすいエラーがでるようにしておく。
        self.waitForExpectations(timeout: 10)
        
        // ここは expectation.fulfill が呼ばれるかタイムアウトするまで
        // 実行されない。
    }
}
