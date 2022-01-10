//
//  AViewController.swift
//  DemoStoryboard
//
//  Created by Tien Le P. VN.Danang on 1/10/22.
//

import UIKit

class AViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.performSegue(withIdentifier: "SegueGotoBView", sender: self)
//        }
    }
    
    @IBAction func returnAView(segue: UIStoryboardSegue) {
        print("back to A View")
    }
    
    @IBAction func gotoHome(_ sender: Any) {
        self.performSegue(withIdentifier: "segueGotoHome", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? HomeViewController {
            destination.name = self.nameTextField.text
        }
    }

}
