//
//  AutolayoutDimensionTable.swift
//  SwiftResponsiveLabel
//
//  Created by Dat Ng on 7/8/17.
//  Copyright © 2017 Nguyen Mau Dat. All rights reserved.
//

import Foundation
import UIKit

class AutolayoutDimensionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mTableView: UITableView!
    
    let testDatas = ["a\nb\nc\nd\ne\nf",
                     "UILabel subclass which responds to touch on specified patterns. It has the following featuresUILabel subclass which responds to touch on specified patterns. It has the following featuresUILabel subclass which responds to touch on specified patterns. It has the following featuresUILabel subclass which responds to touch on specified patterns. It has the following featuresUILabel subclass which responds to touch on specified patterns. It has the following features",
                     "UILabel subclass which responds to touch on specified patterns. It has the following features",
                     "1\n2\n3\n4\n5"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mTableView.register(UINib(nibName: "AutolayoutDimensionCell", bundle: nil), forCellReuseIdentifier: "AutolayoutDimensionCell")
        self.mTableView.estimatedRowHeight = 60
        self.mTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutolayoutDimensionCell") as! AutolayoutDimensionCell
        let rd = indexPath.row % testDatas.count
        cell.labelContent.text = testDatas[rd]
        return cell
    }
}
