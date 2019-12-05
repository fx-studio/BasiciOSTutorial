//
//  HomeViewController.swift
//  DemoTableView
//
//  Created by Le Phuong Tien on 11/18/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var users: [User] = []
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        let nib = UINib(nibName: "HomeCell", bundle: .main)
        tableview.register(nib, forCellReuseIdentifier: "cell")
        
        tableview.delegate = self
        tableview.dataSource = self
        
        users = getUser()
    }
    
    func getUser() -> [User] {
        //1
        var users = [User]()
        //2
        for i in 0...30 {
            //3
            let user = User(name: "Name \(i+1)", age: Int.random(in: 10...30), gender: Bool.random())
            //4
            users.append(user)
        }
        
        return users
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeCell
        
        let user = users[indexPath.row]
        cell.nameLabel.text = user.name
        cell.subTitleLabel.text = user.getSubTitle()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let user = users[indexPath.row]
        let vc = DetailViewController()
        vc.name =  user.name
    
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
