//
//  HomeViewController.swift
//  ProtocolVSClosure
//
//  Created by Le Phuong Tien on 12/27/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var number1TextField: UITextField!
    @IBOutlet weak var number2TextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    var viewmodel = HomeViewModel(number1: 0, number2: 0)

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }

    // MARK: - Config
    func setupUI() {
        title = "Protocol vs. Closure"
    }
    
    func setupData() {
        viewmodel.delegate = self
        viewmodel.dataSource = self
        
        // Example get data
        viewmodel.getData { () -> Int in
            if let number = Int(number1TextField.text!) {
                return number
            } else {
                return 0
            }
        } number2Completed: { () -> Int in
            if let number = Int(number2TextField.text!) {
                return number
            } else {
                return 0
            }
        }

    }
    
    func updateView() {
        number1TextField.text = "\(viewmodel.number1)"
        number2TextField.text = "\(viewmodel.number2)"
        resultLabel.text = "\(viewmodel.result)"
    }
    
    // MARK: - Actions
    @IBAction func addButtonTouchUpInside(_ sender: Any) {
        //viewmodel.add()
        
        if let num1 = Int(number1TextField.text!),
           let num2 = Int(number2TextField.text!) {
            
            viewmodel.add(number1: num1, number2: num2) { (result, errorMessage) in
                if let error = errorMessage {
                    resultLabel.text = "\(error)"
                    
                } else {
                    resultLabel.text = "\(result)"
                }
            }
        }
        
    }
    
    @IBAction func subButtonTouchUpInside(_ sender: Any) {
        //viewmodel.sub()
        
        if let num1 = Int(number1TextField.text!),
           let num2 = Int(number2TextField.text!) {
            
            viewmodel.sub(number1: num1, number2: num2) { (result, errorMessage) in
                if let error = errorMessage {
                    resultLabel.text = "\(error)"
                    
                } else {
                    resultLabel.text = "\(result)"
                }
            }
        }
    }
    
    @IBAction func mulButtonTouchUpInside(_ sender: Any) {
        //viewmodel.mul()
        
        if let num1 = Int(number1TextField.text!),
           let num2 = Int(number2TextField.text!) {
            
            viewmodel.mul(number1: num1, number2: num2) { (result, errorMessage) in
                if let error = errorMessage {
                    resultLabel.text = "\(error)"
                    
                } else {
                    resultLabel.text = "\(result)"
                }
            }
        }
    }
    
    @IBAction func divButtonTouchUpInside(_ sender: Any) {
        //viewmodel.div()
        
        if let num1 = Int(number1TextField.text!),
           let num2 = Int(number2TextField.text!) {
            
            viewmodel.div(number1: num1, number2: num2) { (result, errorMessage) in
                if let error = errorMessage {
                    resultLabel.text = "\(error)"
                    
                } else {
                    resultLabel.text = "\(result)"
                }
            }
        }
    }
    
}

extension HomeViewController: HomeViewModelDataSource, HomeViewModelDelegate {
    func getNumber1(viewmodel: HomeViewModel) -> Int {
        if let number = Int(number1TextField.text!) {
            return number
        } else {
            return 0
        }
    }
    
    func getNumber2(viewmodel: HomeViewModel) -> Int {
        if let number = Int(number2TextField.text!) {
            return number
        } else {
            return 0
        }
    }
    
    func viewmodel(viewmodel: HomeViewModel, didFinishedWith number1: Int, number2: Int, result: Float) {
        resultLabel.text = "\(result)"
    }
    
    func viewmodel(viewmodel: HomeViewModel, didFaileddWith number1: Int, number2: Int, errorMessage: String) {
        resultLabel.text = errorMessage
    }
    
    
}
