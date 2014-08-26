//
//  ViewController.m
//  SelectionDelegateExample
//
//  Created by orta therox on 06/11/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ViewController.h"
#import "HeaderView.h"
#import "FooterView.h"
#import "NSMutableArray+convenience.h"


@implementation MoveParams

@end

static NSString *headerViewIdentifier = @"Test Header View";
static NSString *footerViewIdentifier = @"Test Footer View";

CGSize CollectionViewCellSize = { .height = 140, .width = 180 };
NSString *CollectionViewCellIdentifier = @"SelectionDelegateExample";

@interface ViewController (){
    PSUICollectionView *_gridView;
}
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *imagesArrayOrg;
@property (nonatomic, strong) MoveParams *movParams;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movParams = [[MoveParams alloc] init];
    self.imagesArray = [NSMutableArray array];
    NSMutableArray *mut1 = [NSMutableArray array];
    NSMutableArray *mut2 = [NSMutableArray array];
    NSMutableArray *mut3 = [NSMutableArray array];

    for (int i=0; i<7; i++) {
        [mut1 addObject:[NSString stringWithFormat:@"%d.JPG", i]];
        [mut2 addObject:[NSString stringWithFormat:@"1%d.JPG", i]];
        [mut3 addObject:[NSString stringWithFormat:@"2%d.JPG", i]];

    }
    [self.imagesArray addObject:mut1];
    [self.imagesArray addObject:mut2];
    [self.imagesArray addObject:mut3];
    [self createGridView];
    
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
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (self.movParams.originalCell == nil) {
                self.movParams.originalCell = ((ImageGridCell *)lo.view);
                if (!self.movParams.fakeCell) {
                    self.movParams.fakeCell = [[ImageGridCell alloc] initWithFrame:self.movParams.originalCell.frame];
                    self.movParams.fakeCell.image.image = self.movParams.originalCell.image.image;
                    self.movParams.fakeCell.layer.borderWidth = 3;
                    self.movParams.fakeCell.layer.borderColor = [[UIColor redColor] CGColor];
                    [_gridView addSubview:self.movParams.fakeCell];
                }
            }
            self.movParams.fakeCell.center = [lo locationInView:lo.view.superview];
            self.movParams.originalCell.alpha = 0;
            [_gridView.visibleCells enumerateObjectsUsingBlock:^(ImageGridCell* obj, NSUInteger idx, BOOL *stop) {
                if (obj == self.movParams.originalCell) {
                    return ;
                }
                
                CGRect rect =  obj.frame;
                if (CGRectContainsPoint(rect, self.movParams.fakeCell.center)) {
                    self.movParams.indexToCover = [_gridView indexPathForCell:obj];
                    if (self.movParams.indexToMove != nil && [self.movParams.indexToCover compare:self.movParams.indexToMove]==NSOrderedSame) {
                        NSLog(@"*stop:%@",@"YES");
                        *stop = YES;
                        return;
                    }
                    
                    if (self.movParams.indexToCover.section == self.movParams.indexSelected.section ) {
                        NSLog(@"dacaiguoguo:\n%s\n%d",__func__,__LINE__);
                        
                    }else{
                        NSLog(@"dacaiguoguo:\n%s\n%d",__func__,__LINE__);
                        
                        self.imagesArrayOrg = [self.imagesArray copy];
                        [self resetImagesArrayWithOrgIndex:self.movParams.indexSelected toCoverIndex:self.movParams.indexToCover];
                    }
                    
                    [_gridView moveItemAtIndexPath:self.movParams.indexToMove toIndexPath:self.movParams.indexToCover];
                    NSLog(@"%@---%@",[self formatIndexPath:self.movParams.indexToMove],[self formatIndexPath:self.movParams.indexToCover]);
                    self.movParams.indexToMove = self.movParams.indexToCover;
                }
                
            }];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
//            [self resetImagesArrayWithOrgIndex:self.movParams.indexSelected toCoverIndex:self.movParams.indexToCover];
            self.movParams.originalCell.alpha = 1.;
            [self.movParams.fakeCell removeFromSuperview];
            self.movParams.originalCell = nil;
            self.movParams.fakeCell = nil;
            self.movParams.indexSelected = nil;
            self.movParams.indexToMove = nil;
            self.movParams.indexToCover = nil;
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

- (void)resetImagesArrayWithOrgIndex:(NSIndexPath *)indOrg toCoverIndex:(NSIndexPath *)indexToCo
{
    if (indOrg.section == indexToCo.section) {
        NSMutableArray *mut = [self.imagesArray objectAtIndex:indOrg.section];
        [mut moveObjectFromIndex:indOrg.row toIndex:indexToCo.row];
        
    }else{
        NSLog(@"%ld",(long)indOrg.row);
        NSLog(@"%ld",(long)indexToCo.row);
        NSMutableArray *mutSelect = [self.imagesArray objectAtIndex:indOrg.section];
        NSLog(@"%@",mutSelect);

        id abc = [mutSelect objectAtIndex:indOrg.row];
        [mutSelect removeObjectAtIndex:indOrg.row];
        NSMutableArray *mu2t = [self.imagesArray objectAtIndex:indexToCo.section];
        [mu2t insertObject:abc atIndex:indexToCo.row];
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
    NSLog(@"Delegate cell %@ : SELECTED", [self formatIndexPath:indexPath]);
}

- (void)collectionView:(PSTCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"Delegate cell %@ : DESELECTED", [self formatIndexPath:indexPath]);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.movParams.indexSelected = indexPath;
    self.movParams.indexToMove = self.movParams.indexSelected;
    NSLog(@"%@",[self formatIndexPath:self.movParams.indexToMove]);
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
