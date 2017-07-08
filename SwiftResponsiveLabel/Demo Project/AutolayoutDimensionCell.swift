//
//  AutolayoutDimensionCell.swift
//  SwiftResponsiveLabel
//
//  Created by Dat Ng on 7/8/17.
//  Copyright © 2017 Nguyen Mau Dat. All rights reserved.
//

import Foundation
import UIKit

class AutolayoutDimensionCell: UITableViewCell {
    @IBOutlet weak var labelContent: SwiftResponsiveLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.labelContent?.numberOfLines = 5
        self.labelContent.attributedTruncationToken = NSMutableAttributedString(string: "... More", attributes: [NSForegroundColorAttributeName : UIColor.blue, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
    }
}
