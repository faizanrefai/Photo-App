//
//  AlbumPicker.h
//  Demo_PhotoApp
//
//  Created by Apple on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClubView.h"
#import "JSON.h"

@class ImageAdjustMent;
@interface AlbumPicker : UIViewController <ThumbSelected>
{
    ImageAdjustMent *objImageAdj;
    IBOutlet UIScrollView *scrollView;


    NSMutableArray *photosArray;
    NSMutableArray *selectedPhotos;
    UIAlertView *alert;
    id aaa;
    
    NSMutableArray *clubArray;
	
	IBOutlet UIButton *nextBtn;
	IBOutlet UIButton *previousBtn;
	
	NSMutableDictionary *nextDictprev;
}

@property ( nonatomic , retain )id aaa;
@property ( nonatomic , retain )NSMutableArray* photosArray;
@property ( nonatomic , retain )NSMutableDictionary *nextDictprev;
-(void)createView;

- (IBAction)selectedTapped:(id)sender;
- (IBAction)selectAllTapped:(id)sender;
- (IBAction)selectNoneTapped:(id)sender;
-(IBAction)Next_Btn_Clicked:(id)sender;


-(NSMutableDictionary*)getMoreImage:(NSString*)str;

@end
