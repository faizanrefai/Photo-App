//
//  GroupListView.m
//  Demo_PhotoApp
//
//  Created by apple on 6/23/12.
//  Copyright 2012 fgbfg. All rights reserved.
//

#import "GroupListView.h"


@implementation GroupListView

@synthesize valueArray;
@synthesize imageDownloadsInProgress;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	appDeleg =(AppDelegate *)[[UIApplication sharedApplication]delegate];
}

-(void)viewWillAppear:(BOOL)animated
{
	
	[self.navigationController setNavigationBarHidden:YES animated:NO];

	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
	self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	
	[myTitleLbl setText:[NSString stringWithFormat:@"%@",[[[self.valueArray objectAtIndex:0]valueForKey:@"from"]valueForKey:@"name"]]];
	
}

-(IBAction)Back_Btn_Clicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark
#pragma mark TableView Delegate Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	return [self.valueArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
		
	NSString *cellIdentifire = @"Cell0";
        	
	PhotoCategoryCell *cell = (PhotoCategoryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifire];
	
	
	if (cell == nil) {			
		NSArray *nib = nil;		
		
		nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoCategoryCell" owner:nil options:nil];
		cell = [nib objectAtIndex:0];	
		
		
	}
	[cell setImage:[UIImage imageNamed:@"albumBg_img.png"]];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
		NSMutableDictionary *dict = [self.valueArray objectAtIndex:indexPath.row];
		cell.nameLbl.text = [dict valueForKey:@"name"];
		cell.countLbl.text = [NSString stringWithFormat:@"%@ Photos",[dict valueForKey:@"count"]];
	
		//NSLog(@"%@",[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=album&access_token=%@",[dict valueForKey:@"id"],appDeleg.fbGraph.accessToken]);
		
		if (![dict objectForKey:@"IconImage"])
		{
			
			if (myTable.dragging == NO && myTable.decelerating == NO)
			{
				
				[self getImage:dict forIndexPath:indexPath];
			}
			
			
			cell.imgView.image = [UIImage imageNamed:@"placeholder.png"];                
		}
		else
		{
			
			cell.imgView.image = [dict objectForKey:@"IconImage"];
		}
	
	
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	NSMutableDictionary *dict = (NSMutableDictionary*)[self.valueArray objectAtIndex:indexPath.row];
	//NSLog(@"list :: %@",dict);
	
	
	NSMutableDictionary *mydict = [self getFriendAlbum:[NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]]];
	
	
	if (arrayValue) {
		arrayValue = nil;
		[arrayValue release];
	}
	if (nextDictprev) {
		nextDictprev = nil;
		[nextDictprev release];
	}
	
	arrayValue = [[NSMutableArray alloc]init];
	nextDictprev = [[NSMutableDictionary alloc]init];
	
	
	NSMutableArray *arrr = [mydict objectForKey:@"data"];
	
	for (int i = 0; i < [arrr count]; i++) {
		[arrayValue addObject:[arrr objectAtIndex:i]];
	}
	
	
	//obj.photosArray = [mydict objectForKey:@"data"];
	
	
    nextDictprev = [mydict objectForKey:@"paging"];
	
	NSString *str = [NSString stringWithFormat:@"%@",[nextDictprev objectForKey:@"next"]];
	[self getMoreImage:str];
	//NSLog(@"%@",dict);
	
	
	
}


-(NSMutableDictionary*)getFriendAlbum:(NSString*)str
{
    fbResponce = [appDeleg.fbGraph doGraphGet:[NSString stringWithFormat:@"%@/photos",str] withGetVars:nil];
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableDictionary *facebook_response = [parser objectWithString:fbResponce.htmlResponse error:nil];
	//NSLog(@"Friends Album list :: %@",facebook_response);
    [parser release];
    //NSLog(@"Friends Album list :: %@",facebook_response);
    return facebook_response;  
}

-(void)getMoreImage:(NSString*)str
{
	NSString  *urlstring = [NSString stringWithFormat:@"%@",str];
	//NSLog(@"%@",urlstring);
	Web_req =[[ASIHttpParser alloc] initWithRequestWithURL:urlstring selSuccess:@selector(second_search_data:) selError:@selector(OnError) andHandler:self];

}

-(void)second_search_data:(NSDictionary*)dictionary{
	
	Web_req = nil;
	[Web_req release];
	
	//beinspired_detail_view
	//NSLog(@"%@",dictionary);	
	
	NSMutableArray *arr = [dictionary objectForKey:@"data"];
	
	for (int i = 0; i < [arr count]; i++) {
		[arrayValue addObject:[arr objectAtIndex:i]];
	}
    
	
	nextDictprev = [[dictionary objectForKey:@"paging"] retain];
	NSLog(@"%@",nextDictprev);
	if ([nextDictprev objectForKey:@"next"]) {
		NSString *str = [NSString stringWithFormat:@"%@",[nextDictprev objectForKey:@"next"]];
		[self getMoreImage:str];
		
	}
	else {
		AlbumPicker *obj = [[AlbumPicker alloc]init];
		obj.photosArray = arrayValue;
		NSLog(@"%d",[arrayValue count]);
		[self.navigationController pushViewController:obj animated:YES];
		[obj release];
	}
	
	
}



#pragma mark Image Caching Methods



- (void) getImage:(NSMutableDictionary*)appRecord forIndexPath:(NSIndexPath *)indexPath
{
	NSString *ImageURLString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=album&access_token=%@",[appRecord valueForKey:@"id"],appDeleg.fbGraph.accessToken];
	
	//NSLog(@"%@",ImageURLString);
	
	NSMutableString *tmpStr = [NSMutableString stringWithString:ImageURLString];
	[tmpStr replaceOccurrencesOfString:@"/" withString:@"-" options:1 range:NSMakeRange(0, [tmpStr length])];
	
	NSString *filename = [NSString stringWithFormat:@"%@",tmpStr];
	//NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory = [paths objectAtIndex:0];
	NSString *uniquePath = [cacheDirectory stringByAppendingPathComponent:filename];
	
	UIImage *image;
	
	
	
	
	// Check for a cached version
	if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
	{
		NSData *data = [[NSData alloc] initWithContentsOfFile:uniquePath];
		image = [[UIImage alloc] initWithData:data] ; // this is the cached image
		if(image)
			[appRecord setObject:image forKey:@"IconImage"];
		[image release];
		[data release];
		
		[myTable reloadData];
	}
	else
	{
		// get a new one
		[self startIconDownload:appRecord forIndexPath:indexPath];
		
	}
}



#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(NSMutableDictionary *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
		iconDownloader.flag = 1;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.valueArray count] > 0)
    {
        NSArray *visiblePaths = [myTable indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            NSMutableDictionary *appRecord = [self.valueArray objectAtIndex:indexPath.row];
            
            if (![appRecord objectForKey:@"IconImage"]) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
		PhotoCategoryCell *cell = (PhotoCategoryCell*)[myTable cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
		
		if ([iconDownloader.appRecord objectForKey:@"IconImage"])
		{
			//[cell.activity stopAnimating];
			[cell.imgView setImage:[iconDownloader.appRecord objectForKey:@"IconImage"]];
			
		}
		else
		{
			cell.imgView.image = [UIImage imageNamed:@"placeholder.png"];
		}
		
    }
	//[myTable reloadData];
}
#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
