//
//  APIManager.swift
//  MobileDataUsage
//
//  Created by Anson on 14/9/19.
//  Copyright © 2019 Anson. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIManager {
    static let sharedInstance = APIManager()
    var session = URLSession.shared
    private let engine: NetworkEngine
    typealias CompletionHandler = (_ apiResponseHandler: APIResponseHandler, _ error: Error?) -> Void
    
    init(session: NetworkEngine = URLSession.shared) {
        self.engine = session
    }
    
    func getJSONRequest(method: String, url: String, completed: @escaping CompletionHandler) {
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = method
        engine.performRequest(withRequest: request as URLRequest) { (data, response, error) in
            if(error != nil) {
                let apiResponseHandler: APIResponseHandler = APIResponseHandler(json: nil)
                completed(apiResponseHandler, error)
            } else {
                do {
                    let json = try JSON(data: data!)
                    let apiResponseHandler: APIResponseHandler = APIResponseHandler(json: json)
                    completed(apiResponseHandler, nil)
                } catch {
                    print(error)
                }
            }
        }
    }
}

// MARK: - Response Handler
struct APIResponseHandler {
    var jsonObject: Any?
    var help: String?
    var result: Any?
    var success: Bool?
    var data: Data?
    
    init(json: Any?) {
        if let js = json {
            self.jsonObject = js
            let json = JSON(js)
            self.help = json["help"].string
            self.result = json["result"].rawValue
            self.success = json["success"].bool
        }
    }
    
    func isSuccess() -> Bool {
        guard let serverResult = success else {
            return false
        }
        return serverResult
    }
}

protocol NetworkEngine {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    func performRequest(withRequest: URLRequest, completionHandler: @escaping Handler)
}

extension URLSession: NetworkEngine {
    typealias Handler = NetworkEngine.Handler
    
    func performRequest(withRequest request: URLRequest, completionHandler: @escaping Handler) {
        let task = dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
}

class NetworkEngineMock: NetworkEngine {
    typealias Handler = NetworkEngine.Handler
    
    var request: URLRequest?
    
    func performRequest(withRequest request: URLRequest, completionHandler: @escaping NetworkEngineMock.Handler) {
        
        self.request = request
        
    }
}
