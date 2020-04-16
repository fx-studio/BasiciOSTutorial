//
//  HomeSubCell.swift
//  TableViewInTableView
//
//  Created by Le Phuong Tien on 4/16/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//

import UIKit

protocol HomeSubCellDelegate: class {
  func subHomeCell(cell: HomeSubCell, didRemove index: Int, parentIndex: Int)
}

class HomeSubCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  
  var index = 0
  var parentIndex = -1
  weak var delegate: HomeSubCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func remove(_ sender: Any) {
    if let delegate = delegate {
      delegate.subHomeCell(cell: self, didRemove: index, parentIndex: parentIndex)
    }
  }
  
}
