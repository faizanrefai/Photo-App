//
//  ViewController.h
//  Demo_PhotoApp
//
//  Created by Apple on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FbGraph.h"
#import "AppDelegate.h"

@class PhotoCategory;
@interface ViewController : UIViewController 
<UIAlertViewDelegate>
{
    AppDelegate *appDeleg;

    FbGraphResponse *fbResponce;
    PhotoCategory *objPhoto;
}

-(void)callBackFB:(id)sender;

@end
