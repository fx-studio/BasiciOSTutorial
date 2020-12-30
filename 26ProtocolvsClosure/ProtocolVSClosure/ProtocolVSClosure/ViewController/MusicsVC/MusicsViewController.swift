//
//  MusicsViewController.swift
//  ProtocolVSClosure
//
//  Created by Le Phuong Tien on 12/28/20.
//

import UIKit

class MusicsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var viewmodel = MusicsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }

    func setupUI() {
        title = "Musics"
    }
    
    func setupData() {
        // viewmodel
        viewmodel.delegate = self
        
        //viewmodel.getAPI()
        
//        viewmodel.getAPI { error in
//            if let _ = error {
//                print("Display ERROR")
//            } else {
//                self.tableView.reloadData()
//            }
//        }
        
        viewmodel.getAPI { (result) in
            switch result {
            case .success(_):
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
        // tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }

}

extension MusicsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.numberOfRowsInSection(session: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = viewmodel.musicItem(at: indexPath)
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension MusicsViewController: MusicsViewModelDelegate {
    func musicViewModel(viewmodel: MusicsViewModel, didFinishedAPIWith error: Error?) {
        if let _ = error {
            print("Display ERROR")
        } else {
            tableView.reloadData()
        }
    }
    
    func musicViewModel(viewmodel: MusicsViewModel, needPerformWith action: MusicsViewModel.Action) {
        switch action {
        case .loadAPI(let error):
            if let _ = error {
                print("Display ERROR")
            } else {
                tableView.reloadData()
            }
        }
    }
}

