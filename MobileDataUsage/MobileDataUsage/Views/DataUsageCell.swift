//
//  DataUsageCell.swift
//  MobileDataUsage
//
//  Created by Anson on 14/9/19.
//  Copyright © 2019 Anson. All rights reserved.
//

import Foundation
import UIKit

protocol DataUsageCellProtocol {
    func lowerConsumptionImageTapped()
}

class DataUsageCell: UICollectionViewCell {
    @IBOutlet var lblYear: UILabel!
    @IBOutlet var lblTotalConsumption: UILabel!
    @IBOutlet weak var lowerConsumptionImage: UIImageView!
    @IBOutlet weak var bottomConstraintToImage: NSLayoutConstraint!
    
    var delegate: DataUsageCellProtocol?
    
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
        
        lowerConsumptionImage.image = UIImage(named: "downArrow")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))

        lowerConsumptionImage.addGestureRecognizer(tap)
    }
    
    func showDecreasedConsumption(_ show: Bool) {
        if show {
            lowerConsumptionImage.isHidden = false
        } else {
            lowerConsumptionImage.isHidden = true
            lowerConsumptionImage.removeAllConstraints()
        }
        
        
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.lowerConsumptionImageTapped()
    }
}

extension UIView {
    
    public func removeAllConstraints() {
        var _superview = self.superview
        
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}
