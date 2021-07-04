//
//  WelcomeViewModel.swift
//  DemoAPI
//
//  Created by Tien Le P. VN.Danang on 7/2/21.
//

import Foundation
import Combine
import UIKit

//@MainActor
class WelcomeViewModel: ObservableObject {
    
  
    let imageURL = "https://fxstudio.dev/wp-content/uploads/2019/08/fx-studio-logo-no-bg.png"
    
    @Published var image: UIImage?
    
    // Với cách này thì quá là ổn vì đã đưa vào bất đồng bộ và có chờ đợi
    func loadImage() async {
        do {
            image = try await fetchImage(url: URL(string: imageURL)!)
        } catch {
            print("ViewModel : lỗi nè")
        }
    }
    
    
    func loadImage2() {
        fetchImage(url: URL(string: imageURL)!) { image in
            
            // #1 crash nghe con
//            self.image = image
            
            // #2 Có đispatch truyền thống
//            DispatchQueue.main.async {
//                self.image = image
//            }
            
            // Không dùng dispatch mà thử dùng async xem sao
            // cũng crash --> vì ở Thread khác
            // thêm @MainActor là ổn thôi
            async {
                self.image = image
            }
            
        }
    }
    
    func loadImage3(completion: @MainActor @escaping (UIImage?) -> Void ) {
        fetchImage(url: URL(string: imageURL)!) { image in
            detach {
                await completion(image)
            }
        }
    }
}
