//
//  ViewController.h
//  SelectionDelegateExample
//
//  Created by orta therox on 06/11/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionView.h"
#import "ImageGridCell.h"

@interface MoveParams : NSObject
@property (nonatomic, strong) ImageGridCell *fakeCell;
@property (nonatomic, strong) ImageGridCell *originalCell;
@property (nonatomic, strong) NSIndexPath *indexSelected;
@property (nonatomic, strong) NSIndexPath *indexToCover;
@property (nonatomic, strong) NSIndexPath *indexToMove;
@end


@interface ViewController : UIViewController <PSTCollectionViewDataSource, PSTCollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@end
