//
//  MainViewModel.swift
//  MobileDataUsage
//
//  Created by Anson on 14/9/19.
//  Copyright © 2019 Anson. All rights reserved.
//

import Foundation
class MainViewModel {
    var mobileUsageData: MobileDataUsageData?
    
    var updateUI: (() -> Void)?
    
    func getData() {
        let url = Constants.baseUrl + "/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
        APIManager.sharedInstance.getJSONRequest(method: Constants.HTTPMethods.get.rawValue, url: url) { (resp, error) in
            let result = resp.result
            if let result = result {
                do {
                    let res = try JSONSerialization.data (withJSONObject: result, options: [])
                    let data = try JSONDecoder().decode(MobileDataUsageData.self, from: res)
                    print(data)
                    self.mobileUsageData = data
                    self.updateUI?()
                } catch {
                    
                }
            }
        }
    }
    
    func getNumberOfItems() -> Int {
        return mobileUsageData?.records?.count ?? 0
    }
    
    func getAllEntries() -> [Records] {
        return mobileUsageData?.records ?? [Records]()
    }
    
    func getNumberOfItemsByYear() -> Int {
        return sortDataByYear().count
    }
    
    func getAllEntriesByYear() -> [RecordByYear] {
        return sortDataByYear()
    }
    
    func sortDataByYear() -> [RecordByYear] {
        var years = [String]()
        var filteredYear = [Records]()
        var yearlyRecord = RecordByYear()
        var recordByYear = [RecordByYear]()
        let dataByYear = mobileUsageData?.records?.sorted(by: { (record1, record2) -> Bool in
            String(record1.quarter?.prefix(4) ?? "") < String(record2.quarter?.prefix(4) ?? "")
        }) ?? [Records]()
        
        for data in dataByYear {
            years.append(String(data.quarter?.prefix(4) ?? ""))
        }
        
        for year in years.uniques {
            var previousQuarterConsumption: Double = 0
            filteredYear = dataByYear.filter({String($0.quarter?.prefix(4) ?? "") == year})
            var total: Double = 0
            var messages = [String]()
            for data in filteredYear {
                let consumption = Double(data.volume ?? "")
                let isConsumptionLower = compareConsumption(consumption ?? 0, with: previousQuarterConsumption)
                previousQuarterConsumption = consumption ?? 0
                let consumptionLowerText = isConsumptionLower ? "(Lower)" : "(Higher)"
                let message = "\(data.quarter ?? ""): \(data.volume ?? "")\(consumptionLowerText)"
                messages.append(message)
                let year = String(data.quarter?.prefix(4) ?? "")
                total += Double(data.volume ?? "") ?? 0
                yearlyRecord = RecordByYear(year: year, totalConsumption: String(total), hasConsumptionDropped: isConsumptionLower, message: messages.joined(separator: "\n"))
                
            }
            recordByYear.append(yearlyRecord)
        }
        
        return recordByYear
    }
    
    func compareConsumption(_ new: Double, with previous: Double) -> Bool {
        return new < previous
    }
}

struct RecordByYear {
    var year: String?
    var totalConsumption: String?
    var hasConsumptionDropped : Bool?
    var message: String?
}

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
