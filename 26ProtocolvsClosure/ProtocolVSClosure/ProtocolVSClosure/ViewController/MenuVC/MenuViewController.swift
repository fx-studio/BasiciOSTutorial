//
//  MenuViewController.swift
//  ProtocolVSClosure
//
//  Created by Le Phuong Tien on 12/28/20.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = ["Passing Data & Call back", "Asynchronous"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    func setupUI() {
        title = "Protocol vs. Closure"
    }
    
    func setupData() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1) : \(items[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let vc = HomeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 1:
            let vc = MusicsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            print("Comming soon!")
        }
    }
    
}
