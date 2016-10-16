//
//  BBOCollectionViewFlowLayout.swift
//  testcvc
//
//  Created by miang on 10/15/16.
//  Copyright © 2016 miang. All rights reserved.
//

import UIKit

class BBOCollectionViewFlowLayout: UICollectionViewFlowLayout {
  var interitemSpacing: CGFloat = 0
  var numberOfDetailRow = 3
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
    let height = (sectionInset.top + sectionInset.bottom + wholeDataSize.height)*CGFloat(collectionView.numberOfSections())
    return CGSize(width: collectionView.bounds.width, height: max(height, collectionView.bounds.height))
  }
  
  var maxY: CGFloat = 0
  var itemsAttributes: [UICollectionViewLayoutAttributes] = []
  var headersAttributes: [UICollectionViewLayoutAttributes] = []
  var footersAttributes: [UICollectionViewLayoutAttributes] = []
  var numberOfColumn:Int {
    return Int(collectionViewContentSize().width / wholeDataSizeWithSectionInsect.width)
  }
  
  override func prepareLayout() {
    guard let collectionView = collectionView else { return }
    var originY: CGFloat = 0
    var currentY: CGFloat = 0
    var currentColumn = 0
    self.maxY = 0
    
    self.itemsAttributes.removeAll()
    self.headersAttributes.removeAll()
    self.footersAttributes.removeAll()
    
    for section in 0...collectionView.numberOfSections()-1 {
      let headerSize = self.headerReferenceSize
      let interitemSpacing = self.interitemSpacing
      let sectionInset = self.sectionInset
      let itemCount = collectionView.numberOfItemsInSection(section)
      
      var currentX = sectionInset.left + CGFloat(currentColumn) * headerSize.width
      
      currentY += sectionInset.top
      if headerSize.height > 0 {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: NSIndexPath(forItem: 0, inSection: section))
        attributes.frame = CGRectMake(currentX, sectionInset.top + currentY, headerSize.width, headerSize.height)
        self.headersAttributes.append(attributes)
        currentY += headerSize.height
      }
      
      for itemIndex in 0...itemCount-1 {
        let indexPath = NSIndexPath(forItem: itemIndex, inSection: section)
        let size = self.itemSize
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.frame = CGRectMake(currentX, currentY, size.width, size.height)
        self.maxY = max(attributes.frame.origin.y + attributes.frame.size.height, self.maxY)
        self.itemsAttributes.append(attributes)
        
        if (currentX+size.width >= ((CGFloat(currentColumn) + 1) * headerSize.width)) {
          currentX = sectionInset.left + CGFloat(currentColumn) * headerSize.width
          currentY += size.height + interitemSpacing
        } else {
          currentX += size.width
        }
      }
      currentY += sectionInset.bottom
      
      if currentX + self.wholeDataSizeWithSectionInsect.width > (collectionView.bounds.size.width - collectionView.contentInset.left - collectionView.contentInset.right) {
        currentColumn = 0
        originY = currentY
      } else {
        currentY = originY
        currentColumn = currentColumn + 1
      }
    }
  }
  
  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    return itemsAttributes[indexPath.row*indexPath.section]
    //    guard let collectionView = collectionView else { return nil }
    //
    //    let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
    //    let numberOfColumn = Int(collectionView.contentSize.width / wholeDataSizeWithSectionInsect.width)
    //    let column = Int(collectionView.contentSize.width % wholeDataSizeWithSectionInsect.width)
    //    let row = indexPath.section / numberOfColumn
    //    let originX = CGFloat(column) * (wholeDataSizeWithSectionInsect.width) + sectionInset.left + CGFloat(indexPath.row % 4)
    //    let originY = CGFloat(row) * wholeDataSizeWithSectionInsect.height + sectionInset.top + headerReferenceSize.height + CGFloat(indexPath.row / 4)
    //    attributes.frame = CGRectMake(originX, originY, itemSize.width, itemSize.height)
    //
    //    return attributes
  }
  
  override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    return headersAttributes[indexPath.section]
    //    guard let collectionView = collectionView else { return nil }
    //
    //    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
    //    let size = headerReferenceSize
    //    let column = Int(collectionView.contentSize.width % size.width)
    //    let row = indexPath.section / numberOfColumn
    //    let originX = CGFloat(column) * (size.width + sectionInset.left + sectionInset.right) + sectionInset.left
    //    let originY = CGFloat(row) * wholeDataSizeWithSectionInsect.height + sectionInset.top + headerReferenceSize.height
    //    attributes.frame = CGRectMake(originX, originY, size.width, size.height)
    //
    //    return attributes
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var attributesArray: [UICollectionViewLayoutAttributes] = []
    for attributes in itemsAttributes {
      if CGRectIntersectsRect(rect, attributes.frame) {
        attributesArray.append(attributes)
      }
    }
    for attributes in headersAttributes {
      if CGRectIntersectsRect(rect, attributes.frame) {
        attributesArray.append(attributes)
      }
    }
    
    return attributesArray
    //    guard let collectionView = collectionView else { return nil }
    //    guard collectionView.numberOfSections() > 0 else { return nil }
    //    var attributesArray: [UICollectionViewLayoutAttributes] = []
    //
    //    let minIndexPath = visibleCell(CGRectGetMinY(rect))
    //    let maxIndexPath = visibleCell(CGRectGetMaxY(rect))
    //
    //    let minSec = max(0, minIndexPath.section)
    //    let maxSec = max(0, maxIndexPath.section)
    //    for section in minSec...maxSec {
    //      let numberOfItemsInSection = collectionView.numberOfItemsInSection(section)
    //      let begin = max(0, section == minIndexPath.section ? minIndexPath.row:0)
    //      let end = max(0, section == maxIndexPath.section ? maxIndexPath.row:numberOfItemsInSection)
    //      for row in begin...end {
    //        let indexPath = NSIndexPath(forItem: row, inSection: section)
    //        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
    //
    //        let column = Int(collectionViewContentSize().width % wholeDataSizeWithSectionInsect.width)
    //        let row = indexPath.section / numberOfColumn
    //        let originX = CGFloat(column) * (wholeDataSizeWithSectionInsect.width) + sectionInset.left + CGFloat(indexPath.row % 4)
    //        let originY = CGFloat(row) * wholeDataSizeWithSectionInsect.height + sectionInset.top + headerReferenceSize.height + CGFloat(indexPath.row / 4)
    //        attributes.frame = CGRectMake(originX, originY, itemSize.width, itemSize.height)
    //
    //        attributesArray.append(attributes)
    //      }
    //    }
    //    // header
    //    let minSection = visibleHeader(CGRectGetMinY(rect))
    //    let maxSection = visibleHeader(CGRectGetMaxY(rect))
    //
    //    for section in minSection...maxSection {
    //      let indexPath = NSIndexPath(forItem: 0, inSection: section)
    //      let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: indexPath)
    //      let size = headerReferenceSize
    //      let column = Int(collectionView.contentSize.width % size.width)
    //      let row = indexPath.section / numberOfColumn
    //      let originX = CGFloat(column) * (size.width + sectionInset.left + sectionInset.right) + sectionInset.left
    //      let originY = CGFloat(row) * wholeDataSizeWithSectionInsect.height + sectionInset.top + headerReferenceSize.height
    //      attributes.frame = CGRectMake(originX, originY, size.width, size.height)
    //
    //    }
    //    return nil
  }
  
  func visibleCell(originY: CGFloat) -> NSIndexPath  {
    let section = Int(originY / (wholeDataSizeWithSectionInsect.height))
    let topY = originY % (wholeDataSizeWithSectionInsect.height) - headerReferenceSize.height
    if topY > 0 {
      return NSIndexPath(forItem: 0, inSection: section)
    } else {
      return NSIndexPath(forItem: Int(topY%itemSize.height), inSection: section)
    }
  }
  
  func visibleHeader(originY: CGFloat) -> Int  {
    let section = Int(originY / (wholeDataSizeWithSectionInsect.height))
    let topY = originY % (wholeDataSizeWithSectionInsect.height) - headerReferenceSize.height
    if topY > 0 {
      return min(section+1, collectionView?.numberOfSections() ?? 0)
    } else {
      return section
    }
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
}
