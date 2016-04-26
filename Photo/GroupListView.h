//
//  GroupListView.h
//  Demo_PhotoApp
//
//  Created by apple on 6/23/12.
//  Copyright 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FbGraph.h"
#import "AppDelegate.h"
#import "SBJSON.h"
#import "AlbumPicker.h"
#import "IconDownloader.h"
#import "PhotoCategoryCell.h"
#import "ASIHttpParser.h"



@interface GroupListView : UIViewController <IconDownloaderDelegate>{

	NSMutableDictionary *imageDownloadsInProgress;
	
	
	NSMutableArray *valueArray;
	
	IBOutlet UITableView *myTable;
	
	AppDelegate *appDeleg;
	FbGraphResponse *fbResponce;
	
	IBOutlet UILabel *myTitleLbl;
	
	
	NSMutableArray *arrayValue;
	NSMutableDictionary *nextDictprev;
	
	ASIHttpParser *Web_req;
	
}

@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property ( nonatomic , retain)NSMutableArray *valueArray;

-(NSMutableDictionary*)getFriendAlbum:(NSString*)str;
- (void) getImage:(NSMutableDictionary*)appRecord forIndexPath:(NSIndexPath *)indexPath;
- (void)startIconDownload:(NSMutableDictionary *)appRecord forIndexPath:(NSIndexPath *)indexPath;

-(IBAction)Back_Btn_Clicked:(id)sender;
-(void)getMoreImage:(NSString*)str;

@end
