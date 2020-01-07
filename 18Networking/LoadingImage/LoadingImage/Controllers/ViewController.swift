//
//  ViewController.swift
//  LoadingImage
//
//  Created by Le Phuong Tien on 1/7/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    var image_url = "https://fxstudio.dev/wp-content/uploads/2019/11/header_9.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loading1()
        //loading2()
        loading3()
        loading4()
        
        loading2(urlString: image_url) { (image) in
            if let image = image {
                self.imageView2.image = image
            }
        }
    }
    
    //MARK: Load Image from URL
    
    func loading1() {
        let url = URL(string: image_url)
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
            let image = UIImage(data: imageData)
            imageView1.image = image
        }

    }
    
    func loading2() {
        let url = URL(string: image_url)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("Error fetching the image! 😢")
                } else {
                    self.imageView2.image = UIImage(data: data!)
                }
            }
        }
            
        dataTask.resume()
    }
    
    func loading2(urlString: String, completion: @escaping (UIImage?) -> ()) {
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    completion(nil)
                } else {
                    completion(UIImage(data: data!))
                }
            }
        }
            
        dataTask.resume()
    }
    
    func loading3() {
        guard let imageURL = URL(string: image_url) else { return }

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imageView3.image = image
            }
        }
    }
    
    func loading4() {
        imageView4.load(urlString: image_url)
    }
}

