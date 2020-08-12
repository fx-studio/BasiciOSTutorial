//
//  ViewController.swift
//  RowActions
//
//  Created by Le Phuong Tien on 4/21/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    tableView.delegate = self
    tableView.dataSource = self
    
  }
  
  
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    99
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    50
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    cell.textLabel?.text = "Item \(indexPath.row + 1)"
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("DDDDDDDDDDDDDDĐDDD")
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    // delete
    let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
      print("Delete: \(indexPath.row + 1)")
      completionHandler(true)
    }
    delete.image = UIImage(systemName: "trash")
    delete.backgroundColor = .red
    
    // share
    let share = UIContextualAction(style: .normal, title: "Share") { (action, view, completionHandler) in
      print("Share: \(indexPath.row + 1)")
      completionHandler(true)
    }
    share.image = UIImage(systemName: "square.and.arrow.up")
    share.backgroundColor = .blue
    
    // download
    let download = UIContextualAction(style: .normal, title: "Download") { (action, view, completionHandler) in
      print("Download: \(indexPath.row + 1)")
      completionHandler(true)
    }
    download.image = UIImage(systemName: "arrow.down")
    download.backgroundColor = .green
    
    
    // swipe
    let swipe = UISwipeActionsConfiguration(actions: [delete, share, download])
    
    return swipe
    
  }
  
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    // favorite
    let favorite = UIContextualAction(style: .normal, title: "favorite") { (action, view, completionHandler) in
      print("favorite: \(indexPath.row + 1)")
      completionHandler(true)
    }
    favorite.image = UIImage(systemName: "suit.heart.fill")
    favorite.backgroundColor = .systemPink
    
    // share
    let profile = UIContextualAction(style: .normal, title: "profile") { (action, view, completionHandler) in
      print("profile: \(indexPath.row + 1)")
      completionHandler(true)
    }
    profile.image = UIImage(systemName: "person.fill")
    profile.backgroundColor = .yellow
    
    // download
    let report = UIContextualAction(style: .normal, title: "report") { (action, view, completionHandler) in
      print("report: \(indexPath.row + 1)")
      completionHandler(true)
    }
    report.image = UIImage(systemName: "person.crop.circle.badge.xmark")
    report.backgroundColor = .lightGray
    
    
    // swipe
    let swipe = UISwipeActionsConfiguration(actions: [profile, favorite, report])
    
    return swipe
  }
  
  
}

