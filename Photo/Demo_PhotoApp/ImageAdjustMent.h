//
//  ImageAdjustMent.h
//  Demo_PhotoApp
//
//  Created by Apple on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAdjustMent : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{

    IBOutlet UITableView *tblAdjusment;
    UITextField *txtEmailID;

}
- (IBAction)goToImageFacebookPage:(id)sender;

@property(nonatomic, retain) NSMutableArray *arrayMyalbum;
@end
