//
//  ViewController.swift
//  MultipleStoryboard
//
//  Created by Tien Le P. VN.Danang on 1/13/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TabbarFlow", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "VideosVC") as! VideosVC
        
        self.present(vc, animated: true) {
            print("show VC")
        }
    }
    
}

