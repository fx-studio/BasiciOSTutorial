//
//  HomeViewController.swift
//  ProjectTemplate
//
//  Created by Le Phuong Tien on 12/19/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewmodel = HomeViewModel()
    
    //MARK: - Config
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        title = App.Text.titleHome
        
        //tableview
        let nib = UINib(nibName: "HomeCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //navigation item
        let addNewBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNew))
        self.navigationItem.rightBarButtonItem = addNewBarButtonItem
        
        let deleteAllBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAll))
        self.navigationItem.leftBarButtonItem = deleteAllBarButtonItem
    }
    
    override func setupData() {
        //Dummy Data
//        addBook(title: "Mắt Biếc", subTitle: "Truyện dài tình cảm", price: 100000)
//        addBook(title: "Đắc nhân tâm", subTitle: "Sách giúp đời giúp người", price: 100000)
        
        //viewmodel
        viewmodel.delegate = self
        viewmodel.setupObserve()
        
        //fetch data
        fetchData()
    }
    
    func updateUI() {
        tableView.reloadData()
    }
    
    //MARK: - navigation item
    @objc func addNew() {
        let vc = DetailViewController()
        vc.isNew = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteAll() {
        viewmodel.deleteAll { (done) in
            if done {
                self.fetchData()
            } else {
                print("Lỗi xoá tất cả đối tượng")
            }
        }
    }
    
    //MARK: - Realm data
    func addBook(title: String, subTitle: String, price: Int) {
        // tạo realm
        let realm = try! Realm()
        
        // tạo 1 book
        let book = Book()
        book.title = title
        book.subTitle = subTitle
        book.price = price
        
        //realm write
        try! realm.write {
            realm.add(book)
        }
    }
    
    func fetchData() {
        viewmodel.fetchData { (done) in
            if done {
                self.updateUI()
            } else {
                print("Lỗi fetch data từ realm")
            }
        }
    }

}

//MARK: - TableView Delegate & Datasource
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.numberBooks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeCell
        
        let book = viewmodel.getBook(at: indexPath)
        
        cell.titleLabel.text = book.title
        cell.subTitleLabel.text = book.subTitle + " - \(book.price) vnđ"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = DetailViewController()
        vc.isNew = false
        vc.book = viewmodel.getBook(at: indexPath)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController : HomeViewModelDelegate {
    func viewModel(_ viewModel: HomeViewModel, needperfomAction action: HomeViewModel.Action) {
        fetchData()
    }
}
