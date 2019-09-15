//
//  DataUsageModel.swift
//  MobileDataUsage
//
//  Created by Anson on 14/9/19.
//  Copyright © 2019 Anson. All rights reserved.
//

import Foundation

struct MobileDataUsageData: Decodable, Equatable {
    static func == (lhs: MobileDataUsageData, rhs: MobileDataUsageData) -> Bool {
        return true
    }
    
    var resource_id: String?
    var fields: [Fields]?
    var records: [Records]?
    var links: Links?
    var total: Int?
}

struct Fields: Decodable {
    var type: String?
    var id: String?
}

struct Records: Decodable {
    var volume: String?
    var quarter: String?
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case volume = "volume_of_mobile_data", quarter, id = "_id"
    }
}

struct Links: Decodable {
    var start: String?
    var next: String?
}
