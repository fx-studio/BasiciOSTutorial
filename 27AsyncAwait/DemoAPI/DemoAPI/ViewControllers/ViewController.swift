//
//  ViewController.swift
//  DemoAPI
//
//  Created by Tien Le P. VN.Danang on 6/25/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    let urlString = "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list"
    var drinks: [Category] = [Category(strCategory: "Hello, I'm Fx Studio")]
    
    var drinks2: [[Drink]] = []
    var titles: [String] = ["Ordinary Drink", "Cocktail", "Cocoa"]
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        
        //loadAPI1()
        
        //loadAPI3()
        
        // Call API with Completion
        /*
        async {
            do {
                drinks = try await loadAPI2()
                indicatorView.isHidden = true
                tableView.reloadData()
            }
            catch {
                print("lỗi")
                indicatorView.isHidden = true
            }
        }
         */
        
        // Group APIs
        async {
            do {
                print(" --- API WITH ASYNC GROUP ---")
                let urls = [URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Ordinary_Drink")!,
                            URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail")!,
                            URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocoa")!]
                
                let results: [DrinkResult] = try await fetchAPIs(urls: urls)
                
                for result in results {
                    let items = result.drinks
                    drinks2.append(items)
                }
                
                indicatorView.isHidden = true
                tableView.reloadData()
            }
            catch {
                print((error as! APIError).localizedDescription)
            }
        }

    }
    
    // MARK: - Private functions
    private func configureLayout() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    

    // MARK: - Fetch data
    
    // MARK: Completion handle
    func loadAPI1() {
        let url = URL(string: urlString)!
        
        fetchAPI(url: url) { (result: Result<CategoryResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.drinks.append(contentsOf: result.drinks)
                    
                    for item in result.drinks {
                        print(item.strCategory)
                    }
                    
                    // Update UIs
                    self.tableView.reloadData()
                    self.indicatorView.isHidden = true
                    
                case .failure(let error):
                    print(error)
                }
           }
        }
    }
    
    // MARK: Async with Completion Handler
    func loadAPI2() async throws -> [Category] {
        try await withCheckedThrowingContinuation({ c in
            let url = URL(string: urlString)!
            fetchAPI(url: url) { (result: Result<CategoryResult, Error>) in
                switch result {
                case .success(let result):
                    for item in result.drinks {
                        print(item.strCategory)
                    }
                    
                    c.resume(returning: result.drinks)
                    
                case .failure(let error):
                    c.resume(throwing: error)
                }
            }
        })
    }
    
    // MARK: Async Await
    func loadAPI3() {
        async {
            do {
                let url = URL(string: urlString)!
                let result: CategoryResult = try await fetchAPI(url: url)
                // Sự lợi hại ở đây, không crash chương trình vì mọi thứ đã chờ đợi rồi.
                
                self.drinks.append(contentsOf: result.drinks)
                
                for item in result.drinks {
                    print(item.strCategory)
                }
                
                // Update UIs
                self.tableView.reloadData()
                self.indicatorView.isHidden = true
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        drinks2.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        titles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //drinks.count
        drinks2[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = drinks[indexPath.row].strCategory
        
        cell.textLabel?.text = drinks2[indexPath.section][indexPath.row].strDrink

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Ahihi!")
    }
}
