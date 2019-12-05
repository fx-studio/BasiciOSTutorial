//
//  HomeViewController.swift
//  DemoCollectionView
//
//  Created by Le Phuong Tien on 12/4/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var users: [User] = User.getDummyDatas()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //register cell
        let nib = UINib(nibName: "HomeCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        //register header
        let headerNib = UINib(nibName: "HomeHeaderView", bundle: .main)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        //create layout object
//        //1
//        let screenWidth = UIScreen.main.bounds.width - 10
//        //2
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//        layout.itemSize = CGSize(width: screenWidth/3, height: (screenWidth/3)*5/4)
//        layout.minimumInteritemSpacing = 5
//        layout.minimumLineSpacing = 5
//        //3
//        collectionView!.collectionViewLayout = layout
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCell
        
        let item = users[indexPath.row]
        cell.nameLabel.text = item.name
        cell.avatarImageView.image = UIImage(named: item.avatar)
        
        return cell
    }
    
    //layout
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width - 10
        return CGSize(width: screenWidth/3, height: (screenWidth/3)*5/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    //header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
               let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! HomeHeaderView

               reusableview.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: 50)
               
               reusableview.titleLabel.text = "Users"
               reusableview.totalLabel.text = "\(users.count)"
               
                return reusableview
        default:
            fatalError("Unexpected element kind")
        }
    }
}
