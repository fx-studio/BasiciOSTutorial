//
//  ViewController.swift
//  TableViewInTableView
//
//  Created by Le Phuong Tien on 4/16/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var datas : [ String : [String]] = [ : ]
  
  var items: [HomeItem] = []
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // navigation
    let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addItem))
    self.navigationItem.rightBarButtonItem = addButton
    
    //tableview
    let nib = UINib(nibName: "HomeCell", bundle: .main)
    tableView.register(nib, forCellReuseIdentifier: "cell")
    let subNib = UINib(nibName: "HomeSubCell", bundle: .main)
    tableView.register(subNib, forCellReuseIdentifier: "subcell")
    
    tableView.delegate = self
    tableView.dataSource = self
    
    convert()
  }
  
  @objc func addItem() {
    let count = datas.count
    datas["\(count + 1)"] = []
    
    convert()
  }
  
  func convert() {
    items.removeAll()
    
    let keys = Array(datas.keys).sorted { Int($0)! < Int($1)! }
    
    for index in 0..<keys.count {
      
      //parent
      let item = HomeItem()
      item.parentIndex = -1
      item.index = index
      item.title = keys[index]
      
      items.append(item)
      
      //chill
      let subItems = datas[keys[index]] ?? []
      for subIndex in 0..<subItems.count {
        let item = HomeItem()
        item.parentIndex = index
        item.index = subIndex
        item.title = subItems[subIndex]
        
        items.append(item)
      }
    }
    
    // reload
    tableView.reloadData()
  }
  
  
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    items.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    44
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = items[indexPath.row]
    
    if item.parentIndex == -1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeCell
      cell.delegate = self
      
      cell.index = item.index
      cell.titleLabel.text = item.title
      
      return cell
      
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "subcell", for: indexPath) as! HomeSubCell
      cell.delegate = self
      
      cell.index = item.index
      cell.parentIndex = item.parentIndex
      cell.titleLabel.text = item.title
      
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension ViewController: HomeCellDelegate, HomeSubCellDelegate {
  func subHomeCell(cell: HomeSubCell, didRemove index: Int, parentIndex: Int) {
    for item in items {
      if item.parentIndex == -1 && item.index == parentIndex {
        var subItems = datas[item.title]
        
        subItems?.remove(at: index)
        
        datas[item.title] = subItems
        convert()
        break
        
      }
      
    }
    
  }
  
  func homeCell(cell: HomeCell, didAdded index: Int) {
    for item in items {
      if item.parentIndex == -1 && item.index == index {
        var subItems = datas[item.title]
        let count = subItems?.count ?? 0
        
        subItems?.append("\(item.title) - \(count + 1)")
        
        datas[item.title] = subItems
        convert()
        break
        
      }
    }
    
  }
  
}

