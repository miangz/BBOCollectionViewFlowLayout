//
//  ViewController.swift
//  testcvc
//
//  Created by miang on 10/15/16.
//  Copyright © 2016 miang. All rights reserved.
//

import UIKit

class BBOCollectionViewController: UICollectionViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let collectionView = collectionView {
      let layout = BBOCollectionViewFlowLayout()
      
      collectionView.backgroundColor = UIColor.whiteColor()
      collectionView.contentInset = UIEdgeInsetsMake(15, 20, 15, 20)
      layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
      let width = (collectionView.bounds.size.width - collectionView.contentInset.left - collectionView.contentInset.right - (layout.sectionInset.left + layout.sectionInset.right)*2)/2
      layout.headerReferenceSize = CGSizeMake(width, 50)
      layout.itemSize = CGSizeMake(width/4, 31)
      
      collectionView.registerNib(UINib.init(nibName: "CollectionViewHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader")
      collectionView.registerNib(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
      collectionView.collectionViewLayout = layout
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 100
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let collectionViewLayout = collectionView.collectionViewLayout as? BBOCollectionViewFlowLayout {
      return collectionViewLayout.numberOfRowsPerData
    }
    return 0
  }
  
  override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionHeader {
      let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CollectionViewHeader", forIndexPath: indexPath) as! CollectionViewHeader
      header.title.text = "Section: \(indexPath.section)"
      
      return header
    }
    return UICollectionReusableView()
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
    
    cell.title.text = "\(indexPath.section), \(indexPath.row)"
    
    return cell
  }

}

class BBOCollectionViewCell: UICollectionViewCell {
  
}

class CollectionViewHeader: UICollectionReusableView {
  @IBOutlet weak var title: UILabel!
}

class CollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var title: UILabel!
  
}