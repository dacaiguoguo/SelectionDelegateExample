//
//  ViewController.m
//  SelectionDelegateExample
//
//  Created by orta therox on 06/11/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ViewController.h"
#import "ImageGridCell.h"
#import "HeaderView.h"
#import "FooterView.h"
#import "NSMutableArray+convenience.h"


static NSString *headerViewIdentifier = @"Test Header View";
static NSString *footerViewIdentifier = @"Test Footer View";

CGSize CollectionViewCellSize = { .height = 140, .width = 180 };
NSString *CollectionViewCellIdentifier = @"SelectionDelegateExample";

@interface ViewController (){
    int sectionNumbers0;
    NSIndexPath *indextemp;
    int sectionNumbers1;
    PSUICollectionView *_gridView;
    ImageGridCell *fakeCell;
    NSIndexPath *indexBegin;
    NSIndexPath *indexOrg;
    UILongPressGestureRecognizer *longPressTemp;
    
}
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *imagesArrayOrg;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagesArray = [NSMutableArray array];
    NSMutableArray *mut1 = [NSMutableArray array];
    NSMutableArray *mut2 = [NSMutableArray array];
    for (int i=0; i<7; i++) {
        [mut1 addObject:[NSString stringWithFormat:@"%d.JPG", i]];
        [mut2 addObject:[NSString stringWithFormat:@"2%d.JPG", i]];
    }
    [self.imagesArray addObject:mut1];
    [self.imagesArray addObject:mut2];
    
    [self createGridView];
    
    
    
    sectionNumbers0 = 7;
    sectionNumbers1 = 7;
    
    UIBarButtonItem *toggleMultiSelectButton = [[UIBarButtonItem alloc] initWithTitle:@"Multi-Select" style:UIBarButtonItemStylePlain target:self action:@selector(toggleAllowsMultipleSelection:)];
    [self.navigationItem setRightBarButtonItem:toggleMultiSelectButton];
}

- (void)createGridView {
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    _gridView = [[PSUICollectionView alloc] initWithFrame:[self.view bounds] collectionViewLayout:layout];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.delegate = self;
    _gridView.dataSource = self;
    _gridView.backgroundColor = [UIColor colorWithRed:0.135 green:0.341 blue:0.000 alpha:1.000];
    [_gridView registerClass:[ImageGridCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    [_gridView registerClass:[HeaderView class] forSupplementaryViewOfKind:PSTCollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
	[_gridView registerClass:[FooterView class] forSupplementaryViewOfKind:PSTCollectionElementKindSectionFooter withReuseIdentifier:footerViewIdentifier];
    [self.view addSubview:_gridView];
}

- (void)toggleAllowsMultipleSelection:(UIBarButtonItem *)item {
    _gridView.allowsMultipleSelection = !_gridView.allowsMultipleSelection;
    item.title = _gridView.allowsMultipleSelection ? @"Single-Select" : @"Multi-Select";
}

#pragma mark -
#pragma mark Collection View Data Source

- (NSString *)formatIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    cell.label.text = [self formatIndexPath:indexPath];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPress];
    // load the image for this cell
    NSString *imageName = [self.imagesArray[indexPath.section] objectAtIndex:indexPath.row];
    cell.image.image = [UIImage imageNamed:imageName];
    return cell;
}


- (void)transitionFromPress:(UILongPressGestureRecognizer *)lo
{

    switch (lo.state) {
        case UIGestureRecognizerStatePossible:
        {
            
        }
            break;
        case UIGestureRecognizerStateBegan:
        {
                longPressTemp = lo;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            NSIndexPath *indexFrom = nil;
            ImageGridCell *moveView = ((ImageGridCell *)lo.view);
            if (lo.view.superview != self.view) {
                indexFrom = [_gridView indexPathForCell:moveView];
                if (!fakeCell) {
                    fakeCell = [[ImageGridCell alloc] initWithFrame:moveView.frame];
                    fakeCell.image.image = moveView.image.image;
                    fakeCell.layer.borderWidth = 3;
                    fakeCell.layer.borderColor = [[UIColor redColor] CGColor];
                    [_gridView addSubview:fakeCell];
                }
            }
            if (indexBegin != nil && [indextemp compare:indexBegin]==NSOrderedSame) {
                
                fakeCell.center = [lo locationInView:lo.view.superview];
                moveView.center = [lo locationInView:lo.view.superview];
                moveView.alpha = 0;
                [_gridView.visibleCells enumerateObjectsUsingBlock:^(ImageGridCell* obj, NSUInteger idx, BOOL *stop) {
                    if (obj == moveView) {
                        return ;
                    }
                    CGRect rect =  [self.view convertRect:obj.frame toView:self.view];
                    if (CGRectContainsPoint(rect, lo.view.center)) {
                        NSIndexPath *indexTo = [_gridView indexPathForCell:obj];
                        if (indexTo.section == indexOrg.section) {
                            
                            
                            
                        }else{
                            self.imagesArrayOrg = [self.imagesArray copy];
                            NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.imagesArray objectAtIndex:indexOrg.section]];
                            id abc = [mut objectAtIndex:indexOrg.row];
                            [mut removeObjectAtIndex:indexOrg.row];
                            
                            NSMutableArray *mu2t = [NSMutableArray arrayWithArray:[self.imagesArray objectAtIndex:indexTo.section]];
                            [mu2t addObject:abc];
                            //                            self.imagesArray = [NSMutableArray arrayWithArray:@[mu2t,mut]];
                            self.imagesArray = [NSMutableArray arrayWithObjects:@"",@"", nil];
                            [self.imagesArray replaceObjectAtIndex:indexOrg.section withObject:mut];
                            [self.imagesArray replaceObjectAtIndex:indexTo.section withObject:mu2t];
                            
                        }
                        if (indextemp != nil && [indextemp compare:indexTo]==NSOrderedSame) {
                            *stop = YES;
                            return;
                        }
                        NSLog(@"%@---%@",[self formatIndexPath:indexFrom],[self formatIndexPath:indexTo]);
                        [_gridView moveItemAtIndexPath:indexFrom toIndexPath:indexTo];
                        indextemp = indexTo;
                        /**
                         static int a= 1;
                         if (a ==1) {
                         a++;
                         self.imagesArrayOrg = [self.imagesArray copy];
                         NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.imagesArray objectAtIndex:indexBegin.section]];
                         [mut addObject:@"27.JPG"];
                         [self.imagesArray replaceObjectAtIndex:1 withObject:mut];
                         NSMutableArray *mu2t = [NSMutableArray arrayWithArray:[self.imagesArray objectAtIndex:0]];
                         [mu2t removeLastObject];
                         [self.imagesArray replaceObjectAtIndex:0 withObject:mu2t];
                         }
                         */
                        
                        
                        
                        
                    }
                    
                }];
            }
            else
            {
                indexBegin = indextemp;

//                if (longPressTemp == lo) {
//                    
//                }else{
//                    indexBegin = indextemp;
//                }
                
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [fakeCell removeFromSuperview];
            fakeCell = nil;
            
            if (indexOrg.section == indextemp.section) {
                NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.imagesArray objectAtIndex:indexOrg.section]];
                [mut moveObjectFromIndex:indexOrg.row toIndex:indextemp.row];
                [self.imagesArray replaceObjectAtIndex:indexOrg.section withObject:mut];
                
            }else{
                NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.imagesArrayOrg objectAtIndex:indexOrg.section]];
                NSMutableArray *mut2 = [NSMutableArray arrayWithArray:[self.imagesArrayOrg objectAtIndex:indextemp.section]];
                NSLog(@"%@",mut);
                NSLog(@"%ld",(long)indexOrg.row);
                NSLog(@"%ld",(long)indextemp.row);
                
                [mut2 insertObject:[mut objectAtIndex:indexOrg.row] atIndex:indextemp.row];
                [mut removeObjectAtIndex:indexOrg.row];
                
                self.imagesArray = [NSMutableArray arrayWithObjects:@"",@"", nil];
                [self.imagesArray replaceObjectAtIndex:indexOrg.section withObject:mut];
                [self.imagesArray replaceObjectAtIndex:indextemp.section withObject:mut2];
            }
            indexOrg = nil;
            indextemp = nil;
            indexBegin = nil;
            fakeCell = nil;
            ImageGridCell *moveView = ((ImageGridCell *)lo.view);
            moveView.alpha = 1;

            [_gridView reloadData];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
        }
            break;
        case UIGestureRecognizerStateFailed:
        {
            
        }
            break;
        default:
            break;
    }
    
}

- (void)longPress:(UILongPressGestureRecognizer *)lo
{
    @try {
        [self transitionFromPress:lo];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
        NSLog(@"%@",exception.callStackSymbols);
    }
    @finally {
        
    }
    
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CollectionViewCellSize;
}

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSInteger ret = [self.imagesArray[section] count];
    NSLog(@"ret+:%ld",(long)ret);
    return ret;
}



- (PSUICollectionReusableView *)collectionView:(PSUICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	NSString *identifier = nil;
	
	if ([kind isEqualToString:PSTCollectionElementKindSectionHeader]) {
		identifier = headerViewIdentifier;
	} else if ([kind isEqualToString:PSTCollectionElementKindSectionFooter]) {
		identifier = footerViewIdentifier;
	}
    PSUICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    
    // TODO Setup view
    
    return supplementaryView;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(60.0f, 30.0f);
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(60.0f, 30.0f);
}


- (NSInteger)numberOfSectionsInCollectionView:(PSTCollectionView *)collectionView;
{
    return self.imagesArray.count;
}
#pragma mark -
#pragma mark Collection View Delegate

- (void)collectionView:(PSTCollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Delegate cell %@ : HIGHLIGHTED", [self formatIndexPath:indexPath]);
}

- (void)collectionView:(PSTCollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Delegate cell %@ : UNHIGHLIGHTED", [self formatIndexPath:indexPath]);
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Delegate cell %@ : SELECTED", [self formatIndexPath:indexPath]);
    return;
    if (indexPath.section == 0) {
        sectionNumbers0 --;
        sectionNumbers1 ++;
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:arc4random()%sectionNumbers1 inSection:1]];
    }else{
        sectionNumbers0 ++;
        sectionNumbers1 --;
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:arc4random()%sectionNumbers0 inSection:0]];
    }
}

- (void)collectionView:(PSTCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Delegate cell %@ : DESELECTED", [self formatIndexPath:indexPath]);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    indexBegin = indexPath;
    indexOrg  = indexPath;
//    NSLog(@"Check delegate: should cell %@ highlight?", [self formatIndexPath:indexPath]);
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Check delegate: should cell %@ be selected?", [self formatIndexPath:indexPath]);
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Check delegate: should cell %@ be deselected?", [self formatIndexPath:indexPath]);
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

@end
