//
//  LoginVC.swift
//  MultipleStoryboard
//
//  Created by Tien Le P. VN.Danang on 1/13/22.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func returnLoginVC(segue: UIStoryboardSegue) {
        print("return LoginVC")
    }
    
    @IBAction func gotoTabbar(sender: Any) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("could not get scene delegate ")
        }
        
        sceneDelegate.changeRoot(type: .tabbar)
    }


}
