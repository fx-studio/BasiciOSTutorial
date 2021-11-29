//
//  ContentView.swift
//  DetachedTaskDemo2
//
//  Created by Tien Le P. VN.Danang on 11/29/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var name = "Anonymous"
    @StateObject private var model = ViewModel()
    
    var body: some View {
        VStack {
            Text("Hello, \(name)!")
            Button("Authenticate") {
                Task {
                    model.name = "Taylor"
                }
            }
        }
    }
}

class ViewModel: ObservableObject {
    @Published var name = "Hello"
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
