//
//  HomeViewController.swift
//  DemoCollectionView
//
//  Created by Le Phuong Tien on 12/4/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  //MARK: - Define
  enum Section {
    case main
  }
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Flower>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Flower>
  
  //MARK: - Properties
  var flowers = Flower.allFlowers()
  
  private lazy var dataSource = makeDataSource()
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  //MARK: - Life cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Flowers"
    
    configureLayout()
    applySnapshot()
    
  }
  
  //MARK: - Config View
  func makeDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: collectionView,
      cellProvider: { (collectionView, indexPath, flower) -> UICollectionViewCell? in
          
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? HomeCell
        cell?.nameLabel.text = flower.name
        cell?.thumbImageView.image = UIImage(named: flower.imageName)
        return cell
    })
    
    //header
    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      guard kind == UICollectionView.elementKindSectionHeader else {
        return nil
      }

      let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HomeHeaderView
      view?.titleLabel.text = "main flowers"
      view?.totalLabel.text = "\(self.flowers.count)"
      return view
    }
    
    return dataSource
  }
  
  func configureLayout() {
    
    //delegate
    collectionView.delegate = self
    
    //register cell
    let nib = UINib(nibName: "HomeCell", bundle: .main)
    collectionView.register(nib, forCellWithReuseIdentifier: "cell")
    
    //register header
    let headerNib = UINib(nibName: "HomeHeaderView", bundle: .main)
    collectionView.register(headerNib,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: "header")
    
    //layout
    let screenWidth = UIScreen.main.bounds.width - 20
    // for items
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 10, right: 5)
    layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
    layout.minimumInteritemSpacing = 5
    layout.minimumLineSpacing = 5
    layout.scrollDirection = .vertical
    
    // for header
    layout.sectionHeadersPinToVisibleBounds = false
    layout.headerReferenceSize = CGSize(width: screenWidth, height: 50)
    
    collectionView!.collectionViewLayout = layout
    
  }
  
  func applySnapshot(animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    
    snapshot.appendSections([.main])
    snapshot.appendItems(flowers)
    
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
  
}

extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let item = dataSource.itemIdentifier(for: indexPath) else {
      return
    }
    
    print("Selected flower : \(item.name)")
  }
}
