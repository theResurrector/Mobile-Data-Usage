//
//  DataUsageCell.swift
//  MobileDataUsage
//
//  Created by Anson on 14/9/19.
//  Copyright © 2019 Anson. All rights reserved.
//

import Foundation
import UIKit

class DataUsageCell: UICollectionViewCell {
    @IBOutlet var lblYear: UILabel!
    @IBOutlet var lblTotalConsumption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        
        lblYear.textColor = UIColor.black
        lblYear.numberOfLines = 0
        lblYear.textAlignment = .center
        
        lblTotalConsumption.textColor = UIColor.red
        lblTotalConsumption.numberOfLines = 0
        lblTotalConsumption.textAlignment = .center
    }
}
