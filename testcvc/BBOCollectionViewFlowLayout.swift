//
//  BBOCollectionViewFlowLayout.swift
//  testcvc
//
//  Created by miang on 10/15/16.
//  Copyright © 2016 miang. All rights reserved.
//

import UIKit

class BBOCollectionViewFlowLayout: UICollectionViewFlowLayout {
  var numberOfDetailRow = 5
  var numberOfRowsPerData: Int {
    return (numberOfDetailRow + 1) * 4
  }
  var wholeDataSize: CGSize {
    return CGSize(width: headerReferenceSize.width, height: headerReferenceSize.height + CGFloat(numberOfDetailRow + 1)*itemSize.height)
  }
  
  var wholeDataSizeWithSectionInsect: CGSize {
    return CGSize(width: headerReferenceSize.width + sectionInset.left + sectionInset.right, height: headerReferenceSize.height + CGFloat(numberOfDetailRow + 1)*itemSize.height + sectionInset.top + sectionInset.bottom)
  }
  
  override func collectionViewContentSize() -> CGSize {
    guard let collectionView = collectionView else { return CGSizeZero }
    let width = collectionView.bounds.width
    let height = (sectionInset.top + sectionInset.bottom + wholeDataSize.height)*CGFloat(collectionView.numberOfSections()/Int(width/wholeDataSizeWithSectionInsect.width))
    return CGSize(width: width - collectionView.contentInset.left - collectionView.contentInset.right, height: max(height, collectionView.bounds.height))
  }
  
  var itemsAttributes: [UICollectionViewLayoutAttributes] = []
  var headersAttributes: [UICollectionViewLayoutAttributes] = []
  var footersAttributes: [UICollectionViewLayoutAttributes] = []
  var numberOfColumn: Int {
    guard let collectionView = collectionView else { return 1 }
    return Int((collectionView.bounds.size.width - collectionView.contentInset.left - collectionView.contentInset.right) / wholeDataSizeWithSectionInsect.width)
  }
  
  override func prepareLayout() {
  }
  
  override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: indexPath)
    let size = headerReferenceSize
    let column = indexPath.section % numberOfColumn
    let row = indexPath.section / numberOfColumn
    let originX = sectionInset.left + CGFloat(column) * (self.wholeDataSizeWithSectionInsect.width)
    let originY = CGFloat(row) * (wholeDataSizeWithSectionInsect.height) + sectionInset.top
    attributes.frame = CGRectMake(originX, originY, size.width, size.height)
    
    return attributes
  }
  
  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    let size = self.itemSize
    let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
    let column = indexPath.section % numberOfColumn
    let row = indexPath.section / numberOfColumn
    let originX = sectionInset.left + (CGFloat(column) * self.wholeDataSizeWithSectionInsect.width) + (CGFloat(indexPath.row % 4) * size.width)
    let originY = (CGFloat(row) * wholeDataSizeWithSectionInsect.height) + sectionInset.top + sectionInset.top + headerReferenceSize.height + (CGFloat(indexPath.row / 4) * size.height)
    attributes.frame = CGRectMake(originX, originY, itemSize.width, itemSize.height)
    
    return attributes
  }
  
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let collectionView = collectionView else { return nil }
    guard collectionView.numberOfSections() > 0 else { return nil }
    var attributesArray: [UICollectionViewLayoutAttributes] = []
    
    let minSec = max(0, visibleCell(CGRectGetMinY(rect)))
    let maxSec = max(0, visibleCell(CGRectGetMaxY(rect)))
    for section in minSec...maxSec {
      let numberOfItemsInSection = collectionView.numberOfItemsInSection(section)
      for row in 0..<numberOfItemsInSection {
        let indexPath = NSIndexPath(forItem: row, inSection: section)
        let size = self.itemSize
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        let column = indexPath.section % numberOfColumn
        let row = indexPath.section / numberOfColumn
        let originX = sectionInset.left + (CGFloat(column) * self.wholeDataSizeWithSectionInsect.width) + (CGFloat(indexPath.row % 4) * size.width)
        let originY = (CGFloat(row) * wholeDataSizeWithSectionInsect.height) + sectionInset.top + sectionInset.top + headerReferenceSize.height + (CGFloat(indexPath.row / 4) * size.height)
        attributes.frame = CGRectMake(originX, originY, itemSize.width, itemSize.height)
    
        attributesArray.append(attributes)
      }
    }
    
    // header
    let minSection = min(0, visibleHeader(CGRectGetMinY(rect)))
    let maxSection = visibleHeader(CGRectGetMaxY(rect))
    
    for section in minSection...maxSection {
      let indexPath = NSIndexPath(forItem: 0, inSection: section)
      let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: indexPath)
      let size = headerReferenceSize
      let column = indexPath.section % numberOfColumn
      let row = indexPath.section / numberOfColumn
      let originX = sectionInset.left + CGFloat(column) * (self.wholeDataSizeWithSectionInsect.width)
      let originY = CGFloat(row) * (wholeDataSizeWithSectionInsect.height) + sectionInset.top
      attributes.frame = CGRectMake(originX, originY, size.width, size.height)
      
      attributesArray.append(attributes)
    }
    
    return attributesArray
  }
  
  func visibleCell(originY: CGFloat) -> Int  {
    return min((collectionView?.numberOfSections() ?? 0)-1, Int(originY / (wholeDataSizeWithSectionInsect.height))*numberOfColumn)
  }
  
  func visibleHeader(originY: CGFloat) -> Int  {
    let section = min((collectionView?.numberOfSections() ?? 0)-1, Int(originY / (wholeDataSizeWithSectionInsect.height))*numberOfColumn)
    let topY = (originY % wholeDataSizeWithSectionInsect.height) - headerReferenceSize.height
    if topY > 0 {
      return min(section+1, max(0, (collectionView?.numberOfSections() ?? 0)-1))
    } else {
      return section
    }
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
}
