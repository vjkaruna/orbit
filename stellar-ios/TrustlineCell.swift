//
//  TrustlineCell.swift
//  stellar-ios
//
//  Created by Vijay Karunamurthy on 8/12/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import Foundation
import UIKit

class TrustlineCell: UITableViewCell {
    @IBOutlet var accountLabel: UILabel?
    @IBOutlet var currencyLabel: UILabel?
    @IBOutlet var balanceLabel: UILabel?
    @IBOutlet var limitLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
}