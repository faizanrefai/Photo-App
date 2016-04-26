//
//  AlbumPicker.m
//  Demo_PhotoApp
//
//  Created by Apple on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlbumPicker.h"
#import "ImageAdjustMent.h"
#import "ClubView.h"
#import "UIView+NIB.h"

#define XSpace 2.0
#define YSpace 2.0
#define ThumbInRow 4

#define PAGEWIDTH 70.0
#define PAGEHEIGHT 70.0

#define THUMBNAIL_WIDTH 93
#define THUMBNAIL_HEIGHT 93
#define THUMBNAIL_PADDING 10

@implementation AlbumPicker

@synthesize  aaa,photosArray,nextDictprev;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
    //photosArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"8",nil];   
    //selectedPhotos = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.

	//NSLog(@"%@",photosArray);
    clubArray = [[NSMutableArray alloc]init];
    [self createView];
	
	
	
	
	
	

}

-(void)viewWillAppear:(BOOL)animated
{

	[self.navigationController setNavigationBarHidden:NO animated:NO];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)createView {
	
	
	
	
	
	//if ([self.nextDictprev objectForKey:@"next"] && [photosArray count] >= 25) {
//		nextBtn.hidden = FALSE;
//	}
//	else {
//		nextBtn.hidden = TRUE;
//	}
	
	int THUMBNAILS_IN_ROW = (320 - THUMBNAIL_PADDING) / (THUMBNAIL_WIDTH + THUMBNAIL_PADDING);
	NSInteger iTotalImage = [photosArray count]; 
	NSInteger rows = iTotalImage / THUMBNAILS_IN_ROW;
    if (iTotalImage % THUMBNAILS_IN_ROW > 0) rows++;
	
    CGFloat rowHeight = THUMBNAIL_HEIGHT + THUMBNAIL_PADDING;
	CGFloat colWidth = THUMBNAIL_PADDING + THUMBNAIL_WIDTH;
	
	
	if (scrollView) {
		[scrollView removeFromSuperview];
		scrollView = nil;
		[scrollView release];
	}
	
	scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 330)];
	[self.view addSubview:scrollView];
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, rows * rowHeight + THUMBNAIL_PADDING);
    
    [clubArray removeAllObjects];
	for(NSInteger partner = 0; partner < iTotalImage; partner++){
		ClubView *clubView = [ClubView loadView];
		clubView.delegate = self;
        [clubArray addObject:clubView];
		clubView.tag = partner;
		NSInteger row = partner / THUMBNAILS_IN_ROW;
        NSInteger col =partner % THUMBNAILS_IN_ROW;
		clubView.frame = CGRectMake(THUMBNAIL_PADDING + colWidth * col, THUMBNAIL_PADDING + row * rowHeight, THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT);
		[scrollView addSubview:clubView];
		
		[clubView setImageView:[[photosArray objectAtIndex:partner]valueForKey:@"picture"]];
		//NSLog(@"%@",[[photosArray objectAtIndex:partner]valueForKey:@"picture"]);
		
		//imageViewL.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[photosArray objectAtIndex:partner]valueForKey:@"picture"]]];
		//NSMutableDictionary *partnerDict = [clubArray objectAtIndex:partner];		
		//[clubView startIconDownload:partnerDict];
		//[clubView setLabelName:[clubArray objectAtIndex:partner]];
	}
}

-(void)thumbClickAction:(id)sender{
	
	ClubView *club = (ClubView*)sender;
	//NSLog(@"%d",club.tag);
   
    if(club.btn.selected)
    {    club.btn.selected = NO;
        [selectedPhotos removeObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[photosArray objectAtIndex:club.tag]]]];
    }
    else
    {
        club.btn.selected = YES;
        [selectedPhotos addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[photosArray objectAtIndex:club.tag]]]];
    } 
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)selectedTapped:(id)sender {
    
    if([selectedPhotos count]>0)
    {
    
    NSString *strTemp = [NSString stringWithFormat:@"You have selected %d photos please wait while downloading",[selectedPhotos count]];
    
    alert = [[[UIAlertView alloc] initWithTitle:strTemp message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[alert show];
	
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	// Adjust the indicator so it is up a few pixels from the bottom of the alert
	indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);
	[indicator startAnimating];
	[alert addSubview:indicator];
	[indicator release];
    
    [self performSelector:@selector(changeView) withObject:nil afterDelay:2.0];
    }
    else
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please select atlest 1 photo." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert1 show];
        [alert1 release];
    }
}

-(void)changeView
{
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    if (objImageAdj) {
        objImageAdj = nil;
        [objImageAdj release];
    }
    
    objImageAdj = [[ImageAdjustMent alloc] initWithNibName:@"ImageAdjustMent" bundle:nil];
    objImageAdj.arrayMyalbum = selectedPhotos;
    [self.navigationController pushViewController:objImageAdj animated:YES];

}


- (IBAction)selectAllTapped:(id)sender {

   // NSLog(@"Select All Tapped");
    
    [selectedPhotos removeAllObjects];

    for(int i = 0 ; i< [clubArray count]; i++)
        {
             ClubView *club = (ClubView*)[clubArray objectAtIndex:i];
            club.btn.selected = YES;
            [selectedPhotos addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[photosArray objectAtIndex:i]]]];
        }
    
}

- (IBAction)selectNoneTapped:(id)sender {

   // NSLog(@"Select None Tapped");
    
    for(int i = 0 ; i< [clubArray count]; i++)
    {
        ClubView *club = (ClubView*)[clubArray objectAtIndex:i];
        club.btn.selected = NO;
    }
    [selectedPhotos removeAllObjects];
}

-(IBAction)Next_Btn_Clicked:(id)sender
{
	NSString *str = [NSString stringWithFormat:@"%@",[self.nextDictprev objectForKey:@"next"]];
	NSMutableDictionary* dict =  [self getMoreImage:str];
	//NSLog(@"%@",dict);
	
	NSMutableArray *arr = [dict valueForKey:@"data"];
	[photosArray addObjectsFromArray:arr];
	
	self.nextDictprev = [dict valueForKey:@"paging"];
	
	[self createView];
}



-(NSMutableDictionary*)getMoreImage:(NSString*)str
{
	NSString  *urlstring = [NSString stringWithFormat:@"%@",str];
    NSURL *url = [NSURL URLWithString:urlstring];
    //NSLog(@"URL : %@",url);
    NSString  *jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableDictionary *dict = [parser objectWithString:jsonRes error:nil];
    [parser release];
    return dict;  
}


- (void)dealloc {
    [super dealloc];
    [selectedPhotos release];
    selectedPhotos = nil;
    
    [photosArray release];
    photosArray = nil;
}
@end
