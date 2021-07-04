//
//  WelcomeViewModel2.swift
//  DemoAPI
//
//  Created by Tien Le P. VN.Danang on 7/2/21.
//

import Foundation
import Combine
import UIKit

@MainActor
class WelcomeViewModel2: ObservableObject {
  
    let imageURL = "https://fxstudio.dev/wp-content/uploads/2019/08/fx-studio-logo-no-bg.png"
    
    var subscriptions = Set<AnyCancellable>()
    @Published var image: UIImage?
    
    // MARK: LOAD API
    func loadImage() {
//        URLSession.shared
//            .dataTaskPublisher(for: URL(string: imageURL)!)
//            //.receive(on: DispatchQueue.main)
//            .map { data, _ in
//                UIImage(data: data)
//            }
//            .replaceError(with: nil)
//            .assign(to: \.image, on: self)
//            .store(in: &subscriptions)
        
        URLSession.shared
            .dataTaskPublisher(for: URL(string: imageURL)!)
            //.receive(on: DispatchQueue.main)
            .map { data, _ in
                UIImage(data: data)
            }
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { image in
                async {
                    self.image = image
                }
            })
            .store(in: &subscriptions)
        
//        fetchImage()
//            .sink { image in
//                self.image = image
//            }
//            .store(in: &subscriptions)
        
        
    }
    
    func fetchImage() -> AnyPublisher<UIImage?, Never> {
        let subject = PassthroughSubject<UIImage?, Never>()
        
        async {
            let (data, _)  = try await URLSession.shared.data(from: URL(string: imageURL)!)
            let image = UIImage(data: data)
            subject.send(image)
            subject.send(completion: .finished)
        }
        
        return subject.eraseToAnyPublisher()
    }
}

class FunnyViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let viewModel2 = WelcomeViewModel2()
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel2.$image
            .assign(to: \.image, on: imageView)
            .store(in: &subscriptions)
    }

    @IBAction func start(_ sender: Any) {
        viewModel2.loadImage()
    }
}
