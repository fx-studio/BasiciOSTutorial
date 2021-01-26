//
//  ViewController.swift
//  ListContentView
//
//  Created by Le Phuong Tien on 1/26/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // View title
        title = "Books - Stack"
        view.backgroundColor = UIColor.white
        // Add scroll view
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
        // Add stack view
        stackView = UIStackView(frame: scrollView.bounds)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        scrollView.addSubview(stackView)
        // Stack view constraings
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
        // Load data
        loadData()
    }
    
    private func loadData() {
        // Clear up any previous child views
        for sv in stackView.subviews {
            sv.removeFromSuperview()
        }
        // Add new child views for content - sections
        for (index, section) in Book.sections.enumerated() {
            // Section configuration
            var config = UIListContentConfiguration.plainHeader()
            config.text = section
            // Section view
            var cv = UIListContentView(configuration: config)
            stackView.addArrangedSubview(cv)
            // Loop through Books for section
            for book in Book.booksFor(section: index) {
                // Book configuration
                config = UIListContentConfiguration.cell()
                config.image = book.authType == .single ? UIImage(systemName: "person.fill") : UIImage(systemName: "person.2.fill")
                config.text = book.title
                config.secondaryText = book.author
                // Book view
                cv = UIListContentView(configuration: config)
                stackView.addArrangedSubview(cv)
            }
        }
    }
    
}

