//
//  ASIHttpParser.h
//  WACLighting
//
//  Created by Openxcelltech on 1/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"


@interface ASIHttpParser : NSObject<ASIHTTPRequestDelegate> {
	ASIHTTPRequest *myrequest;
	NSObject *MainHandler;
	SEL targetSelectorS;
	SEL targetSelectorE;
	

}

@property (nonatomic,retain)NSObject *MainHandler;
@property (nonatomic)SEL targetSelectorS;
@property (nonatomic)SEL targetSelectorE;

-(id)initWithRequestWithURL:(NSString*)urlString selSuccess:(SEL)seletorS  selError:(SEL)seletorE  andHandler:(NSObject*)handler;
-(void)startParsingReq:(NSString*)urlString;
-(void)cancelReq;
@end
