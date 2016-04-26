//
//  PhotoCategory.h
//  Demo_PhotoApp
//
//  Created by Apple on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ImageAdjustMent.h"
#import "FbGraph.h"
#import "AppDelegate.h"
#import "IconDownloader.h"
#import "PhotoCategoryCell.h"
#import "GroupListView.h"
#import "EGOCache.h"

@class AlbumPicker;


@interface PhotoCategory : UIViewController <IconDownloaderDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    AppDelegate *appDeleg;
    int selectedOption;
    NSArray *arrayFriends;
    NSArray *arrayMyalbums;
    NSArray *arrayMyLikes;
    
   NSMutableDictionary *imageDownloadsInProgress;
    
    FbGraphResponse *fbResponce;
    AlbumPicker *objAlbum;
    ImageAdjustMent *objImageAdj;
    UIAlertView *alert;
    UIWebView *web;
    
    IBOutlet UITableView *tblCategory;
	
	
	IBOutlet UIButton *myAlbum_btn;
	IBOutlet UIButton *myLike_btn;
	IBOutlet UIButton *myFriends_btn;
	
	IBOutlet UILabel *myTitleLbl;
	
	
	
}
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
-(void)getFriendList;

-(IBAction)categorySelected:(id)sender;
-(IBAction)logoutTapped:(id)sender;

-(void)getMyAlbumList;

-(NSMutableArray*)getFriendAlbumList:(NSString*)str;
-(NSMutableArray*)getMyAlbumPhotos:(NSString*)str;
-(NSMutableArray*)getMyLikePhotos:(NSString*)str;

- (void) getImage:(NSMutableDictionary*)appRecord forIndexPath:(NSIndexPath *)indexPath;
- (void)startIconDownload:(NSMutableDictionary *)appRecord forIndexPath:(NSIndexPath *)indexPath;


@end
