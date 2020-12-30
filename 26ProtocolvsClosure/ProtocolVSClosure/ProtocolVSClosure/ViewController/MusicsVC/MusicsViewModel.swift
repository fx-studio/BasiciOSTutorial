//
//  MusicsViewModel.swift
//  ProtocolVSClosure
//
//  Created by Le Phuong Tien on 12/28/20.
//

import Foundation

// MARK: - Error
enum APIError: Error {
    case error(String)
    case errorURL
    
    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
        case .errorURL:
            return "URL String is error."
        }
    }
}

// MARK: - Protocol
protocol MusicsViewModelDelegate: class {
    func musicViewModel(viewmodel: MusicsViewModel, didFinishedAPIWith error: Error?)
    func musicViewModel(viewmodel: MusicsViewModel, needPerformWith action: MusicsViewModel.Action)
}

class MusicsViewModel: NSObject {
    
    // MARK: - Define
    // typealias MusicAPICompletion = (APIError?) -> Void
    typealias MusicAPICompletion<T> = (Result<T, APIError>) -> Void
    enum Action {
        case loadAPI(APIError?)
    }
    
    // MARK: - Properties
    var urlString = "https://rss.itunes.apple.com/api/v1/us/itunes-music/new-music/all/100/explicit.json"
    var data = Data()
    var musics: [Music] = []
    
    weak var delegate: MusicsViewModelDelegate?
    
    // MARK: - init
    override init() {
    }
    
    // MARK: - Data
    func getAPI() {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
            let task = session.dataTask(with: request)
            task.resume()
        } else {
            delegate?.musicViewModel(viewmodel: self, needPerformWith: .loadAPI(.errorURL))
        }
    }
    
    func getAPI(completion: @escaping MusicAPICompletion<[Music]>) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) {(data, _, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        //completion(.error(error.localizedDescription))
                        completion(.failure(.error(error.localizedDescription)))
                    } else {
                        guard let data = data else {
                            //completion(.error("Data error"))
                            completion(.failure(.error("Data error")))
                            return
                        }
                        
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(MusicResult.self, from: data)
                            self.musics = result.feed.results
                            
                            //completion(nil)
                            completion(.success(self.musics))
                            
                        } catch {
                            //completion(.error("Parse error"))
                            completion(.failure(.error("Parse error")))
                        }
                    }
                }
            }
            
            task.resume()
            
        } else {
            //completion(.errorURL)
            completion(.failure(.errorURL))
        }
    }
    
    // MARK: - TableView
    func numberOfRowsInSection(session: Int) -> Int {
        musics.count
    }
    
    func musicItem(at indexPath: IndexPath) -> Music {
        musics[indexPath.row]
    }
}

extension MusicsViewModel: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("⚠️ didReceive response")
        data = Data()
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("⚠️ Get data: \(data.count)")
        self.data.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("⚠️ Error: \(error.localizedDescription)")
            //delegate?.musicViewModel(viewmodel: self, didFinishedAPIWith: error)
            delegate?.musicViewModel(viewmodel: self, needPerformWith: .loadAPI(.error(error.localizedDescription)))
            
        } else {
            print("⚠️ API DONE --> PARSE")
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(MusicResult.self, from: data)
                self.musics = result.feed.results
                
                //delegate?.musicViewModel(viewmodel: self, didFinishedAPIWith: nil)
                delegate?.musicViewModel(viewmodel: self, needPerformWith: .loadAPI(nil))
                
            } catch {
                print("⚠️ Parse error: \(error.localizedDescription)")
                //delegate?.musicViewModel(viewmodel: self, didFinishedAPIWith: error)
                delegate?.musicViewModel(viewmodel: self, needPerformWith: .loadAPI(.error(error.localizedDescription)))
            }
        }
    }
}
