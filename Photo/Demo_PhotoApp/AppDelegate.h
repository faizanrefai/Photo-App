//
//  AppDelegate.h
//  Demo_PhotoApp
//
//  Created by Apple on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FbGraph.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
 
    FbGraph *fbGraph;
    
}

@property (retain, nonatomic) FbGraph *fbGraph;

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) UINavigationController *navController;

@end
