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
    typealias CompletionHandler = (_ apiResponseHandler: APIResponseHandler, _ error: Error?) -> Void
    
    func getJSONRequest(method: String, url: String, completed: @escaping CompletionHandler) {
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = method
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
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
        })
        task.resume()
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
