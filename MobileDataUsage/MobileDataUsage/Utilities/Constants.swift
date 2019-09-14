//
//  Constants.swift
//  MobileDataUsage
//
//  Created by Anson on 12/9/19.
//  Copyright © 2019 Anson. All rights reserved.
//

import Foundation

struct Constants {
    static let baseUrl = "https://data.gov.sg"
    
    enum HTTPMethods: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case update = "UPDATE"
    }
}
