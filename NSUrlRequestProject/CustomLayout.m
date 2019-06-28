//
//  CustomLayout.m
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 28/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "CustomLayout.h"

@interface CustomLayout ()
{
    NSArray *layoutArr;
    CGSize currentContentSize;
}

@end

@implementation CustomLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    layoutArr = [self generateLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return layoutArr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (UICollectionViewLayoutAttributes *attrs in layoutArr) {
        if ([attrs.indexPath isEqual:indexPath]) {
            return attrs;
        }
    }
    return nil;
}

- (CGSize)collectionViewContentSize
{
    return currentContentSize;
}

- (NSArray *)generateLayout
{
    NSMutableArray *arr = [NSMutableArray new];
    NSInteger sectionCount = 1;
    if ([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sectionCount = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    CGSize cellSize = self.cellSize;
    float collectionWidth = self.collectionView.bounds.size.width;
    float xOffset = 10;
    float yOffset = 0;
    Boolean rowOdd = true;
    
    for (NSInteger section = 0; section < sectionCount; section++)
    {
        NSInteger itemsCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemsCount; item++)
        {
            NSIndexPath *idxPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:idxPath];
            
            NSLog(@"%ld",idxPath.item);
            if (rowOdd)
            {
                switch (idxPath.item % 3)
                {
                    case 0:
                        xOffset = 10;
                        attrs.frame = CGRectMake(xOffset, yOffset, cellSize.width, cellSize.height);
                        
                        break;
                    case 1:
                        xOffset = cellSize.width + self.sectionSpacing.width * 2;
                        
                        attrs.frame = CGRectMake(xOffset, yOffset, cellSize.width, cellSize.height / 2 - self.sectionSpacing.height / 2);
                        
                        yOffset += cellSize.height / 2 + self.sectionSpacing.height / 2;
                        break;
                    case 2:
                        xOffset = cellSize.width + self.sectionSpacing.width * 2;
                        
                        attrs.frame = CGRectMake(xOffset, yOffset, cellSize.width, cellSize.height / 2  - self.sectionSpacing.height / 2);
                        yOffset += cellSize.height / 2 + self.sectionSpacing.height;
                        
                        rowOdd = !rowOdd;
                        break;
                    default:
                        xOffset = 10;
                        attrs.frame = CGRectMake(xOffset, yOffset, cellSize.width, cellSize.height);
                        
                        break;
                }
            } else
            {
                switch (idxPath.item % 3)
                {
                    case 0:
                        xOffset = self.sectionSpacing.width;
                        
                        attrs.frame = CGRectMake(xOffset, yOffset, cellSize.width, cellSize.height / 2 - self.sectionSpacing.height / 2);
                        
                        yOffset += cellSize.height / 2 + self.sectionSpacing.height / 2;
                        break;
                    case 1:
                        xOffset = self.sectionSpacing.width;
                        
                        attrs.frame = CGRectMake(xOffset, yOffset, cellSize.width, cellSize.height / 2 - self.sectionSpacing.height / 2);
                        
                        yOffset -= cellSize.height / 2 + self.sectionSpacing.height / 2;
                        break;
                    case 2:
                        xOffset = cellSize.width + self.sectionSpacing.width * 2;
                        
                        attrs.frame = CGRectMake(xOffset, yOffset, cellSize.width, cellSize.height);
                        yOffset += cellSize.height + self.sectionSpacing.height;
                        
                        rowOdd = !rowOdd;
                        break;
                    default:
                        xOffset = self.sectionSpacing.width;
                        
                        attrs.frame = CGRectMake(xOffset, yOffset, cellSize.width, cellSize.height / 2 - self.sectionSpacing.height / 2);
                        
                        yOffset += cellSize.height / 2 + self.sectionSpacing.height / 2;
                        break;
                }
            }
            
            [arr addObject:attrs];
        }
    }
    
    currentContentSize = CGSizeMake(xOffset, yOffset);
    return arr;
}

@end
