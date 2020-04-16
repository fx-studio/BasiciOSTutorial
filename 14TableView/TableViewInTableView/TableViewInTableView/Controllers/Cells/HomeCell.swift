//
//  HomeCell.swift
//  TableViewInTableView
//
//  Created by Le Phuong Tien on 4/16/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//

import UIKit

protocol HomeCellDelegate: class {
  func homeCell(cell: HomeCell, didAdded index: Int)
}

class HomeCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  
  var index = 0
  var parentIndex = -1
  
  weak var delegate: HomeCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func add(_ sender: Any) {
    if let delegate = delegate {
      delegate.homeCell(cell: self, didAdded: index)
    }
  }
  
}

