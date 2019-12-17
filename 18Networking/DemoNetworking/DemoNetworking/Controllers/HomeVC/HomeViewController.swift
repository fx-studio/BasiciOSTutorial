//
//  HomeViewController.swift
//  DemoTabbarController
//
//  Created by Le Phuong Tien on 12/6/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
        
    @IBOutlet weak var tableview: UITableView!
    var viewmodel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        //title
        self.title = "Home"
        
        //tableview
        tableview.delegate = self
        tableview.dataSource = self
        
        let nib = UINib(nibName: "HomeCell", bundle: .main)
        tableview.register(nib, forCellReuseIdentifier: "cell")
        
        //navi
        let resetTabbarItem = UIBarButtonItem(image: UIImage(named: "ic-navi-refresh"), style: .plain, target: self, action: #selector(loadAPI))
        self.navigationItem.rightBarButtonItem = resetTabbarItem
    }
    
    override func setupData() {
    }
    
    func updateUI() {
        tableview.reloadData()
    }

    //MARK: - API
    @objc func loadAPI() {
        print("LOAD API")
        viewmodel.loadAPI2 { (done, msg) in
            if done {
                self.updateUI()
            } else {
                print("API ERROR: \(msg)")
            }
        }
    }
}

//MARK: - Tableview Delegate & Datasource
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.musics.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeCell
        
        let item = viewmodel.musics[indexPath.row]
        cell.titleLabel.text = item.name
        cell.artistNameLabel.text = item.artistName
        
        if item.thumbnailImage != nil {
            cell.thumbnail.image = item.thumbnailImage
        } else {
            cell.thumbnail.image = nil
            
            //downloader
            Networking.shared().downloadImage(url: item.artworkUrl100) { (image) in
                if let image = image {
                    cell.thumbnail.image = image
                    item.thumbnailImage = image
                } else {
                    cell.thumbnail.image = nil
                }
            }
        }
        
        return cell
    }
}
