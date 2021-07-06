//
//  HomeViewModel.swift
//  DemoAPI
//
//  Created by Tien Le P. VN.Danang on 7/5/21.
//

import Foundation
import UIKit
import Combine

//@MainActor
class HomeViewModel {
    
    // MARK: Properties
    let imageURL = "https://photo-cms-viettimes.zadn.vn/w1280/Uploaded/2021/aohuooh/2019_03_16/chum_anh_chung_to_meo_bi_ngao_da_la_co_that_158278544_1632019.png"
    
    @Published var image: UIImage?
    
    
    // MARK: Actions
    func loadImage(completion: @escaping (UIImage?) -> Void ) {
        fetchImage(url: URL(string: imageURL)!) { image in
            //DispatchQueue.main.async {
                //completion(image)
            //}
            async {
                completion(image)
            }
        }
    }
    
    func loadImage2() {
        fetchImage(url: URL(string: imageURL)!) { image in
            //DispatchQueue.main.async {
                //self.image = image
            //}
            async {
                self.image = image
            }
        }
    }
    
    func loadImage3() async {
        do {
            image = try await fetchImage(url: URL(string: imageURL)!)
        } catch {
            print("ViewModel : lỗi nè")
        }
    }
    
    func loadImage4(completion: @MainActor @escaping (UIImage?) -> Void ) {
        fetchImage(url: URL(string: imageURL)!) { image in
            detach {
                await completion(image)
            }
        }
    }
    
    
    // MARK: API
    private func fetchImage(url: URL, completion: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }
        .resume()
    }
    
    func fetchImage(url: URL) async throws -> UIImage? {
        let (data, _)  = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
}
