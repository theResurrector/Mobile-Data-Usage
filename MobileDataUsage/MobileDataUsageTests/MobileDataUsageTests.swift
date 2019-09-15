//
//  MobileDataUsageTests.swift
//  MobileDataUsageTests
//
//  Created by Anson on 12/9/19.
//  Copyright © 2019 Anson. All rights reserved.
//

import XCTest
@testable import MobileDataUsage

class MobileDataUsageTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLoadingData() {        
        let session = NetworkEngineMock()
        let loader = APIManager(session: session)
        let url = Constants.baseUrl + "/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        loader.getJSONRequest(method: "GET", url: url) { (apiresponse, error) in
            let help = "https://data.gov.sg/api/3/action/help_show?name=datastore_search"
            
            let fields = [Fields(type: "int4", id: "1")]
            let records = [Records(volume: "0.00234", quarter: "2004_Q3", id: 1)]
            let links = Links(start: "/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f",
                              next: "/api/action/datastore_search?offset=100&resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f")
            let result = MobileDataUsageData(resource_id: "", fields: fields, records: records, links: links, total: 59)
            
            let success = true
            
            XCTAssertEqual(apiresponse.help, help)
            XCTAssertEqual(apiresponse.success, success)
            do {
                let res = try JSONSerialization.data (withJSONObject: apiresponse.result, options: [])
                let data = try JSONDecoder().decode(MobileDataUsageData.self, from: res)
                XCTAssertEqual(data, result)
            } catch {
                
            }
        }
        
        XCTAssertEqual(session.request as! URLRequest, request as URLRequest)
    }
}
