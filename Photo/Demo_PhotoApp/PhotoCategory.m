//
//  PhotoCategory.m
//  Demo_PhotoApp
//
//  Created by Apple on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoCategory.h"
#import "AlbumPicker.h"
#import "SBJSON.h"

@implementation PhotoCategory

@synthesize imageDownloadsInProgress;




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDeleg =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    
    //arrayFriends = [[NSArray alloc] initWithObjects:@"Mike",@"Jason",@"Mathew",@"Lura",@"John",nil];
    //arrayMyalbums = [[NSArray alloc] initWithObjects:@"Diwali Celeb",@"31st Party",@"Holi",nil]; 
    //arrayMyLikes = [[NSArray alloc] initWithObjects:@"BTW",@"Angry Bird",@"Sudden",@"John",nil];
    
    self.navigationItem.title = @"My Albums";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTapped:)];
   
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutTapped:)];
    
	
	[self getMyAlbumList];
	
    // Do any additional setup after loading the view from its nib.
    // 10150375344294784/picture?type=album&access_token=
}

-(void)viewWillAppear:(BOOL)animated
{

	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	
	
}

-(void)backButtonTapped:(id)sender
{
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Exit from creating new album." message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Exit",nil];
     Alert.tag = 1;
    [Alert show];
}

-(IBAction)logoutTapped:(id)sender
{
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Logout from Facebook" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Logout",nil];
     
     Alert.tag = 2;
    [Alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag== 1)
    {
        if(buttonIndex == 1)
        [self.navigationController popViewControllerAnimated:YES];
        [alertView release];
    }
    else if (alertView.tag == 2)
    { 
        if(buttonIndex == 1)
				
				appDeleg.fbGraph.accessToken = nil;
				NSHTTPCookie *cookie;
				NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
				for (cookie in [storage cookies])
				{
					NSString *domainName = [cookie domain];
					NSRange domainRange = [domainName rangeOfString:@"facebook"];
					if(domainRange.length > 0)
					{
						[storage deleteCookie:cookie];
					}
				}
		
        [self.navigationController popViewControllerAnimated:YES];
        [alertView release];
    }
    else
    {
        if(buttonIndex == 1)
        {
            //NSLog(@"Download Tapped");
            NSString *strTemp = [NSString stringWithFormat:@"Downloading..."];
            
            alert = [[[UIAlertView alloc] initWithTitle:strTemp message:@"One moment" delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
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
        }
    }
    
}


#pragma mark
#pragma mark TableView Delegate Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(selectedOption == 1)
    {
        return [arrayMyalbums count];
    }
    else if(selectedOption == 2)
    {
        return [arrayMyLikes count];
    }
    else 
    {
        return [arrayFriends count];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
	return 80.0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedOption == 1){
   
        NSString *cellIdentifire = @"Cell0";
        
		
		PhotoCategoryCell *cell = (PhotoCategoryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifire];
		
		
		if (cell == nil) {			
			NSArray *nib = nil;		
			
			nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoCategoryCell" owner:nil options:nil];
			cell = [nib objectAtIndex:0];	
			
			
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		[cell setImage:[UIImage imageNamed:@"albumBg_img.png"]];
		
		NSMutableDictionary *dict = [arrayMyalbums objectAtIndex:indexPath.row];
		cell.nameLbl.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]];
		cell.countLbl.text = [NSString stringWithFormat:@"%@ Photos",[dict valueForKey:@"count"]];
		
		//NSLog(@"%@",[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=album&access_token=%@",[dict valueForKey:@"id"],appDeleg.fbGraph.accessToken]);
		
		if (![dict objectForKey:@"IconImage"])
		{
			
			if (tblCategory.dragging == NO && tblCategory.decelerating == NO)
			{
				
				[self getImage:dict forIndexPath:indexPath];
			}
			
			
			cell.imgView.image = [UIImage imageNamed:@"placeholder.png"];                
		}
		else
		{
			
			cell.imgView.image = [dict objectForKey:@"IconImage"];
		}
		
        //cell.textLabel.text = [arrayMyalbums objectAtIndex:indexPath.row];
		
        return cell;
    }
    else if(selectedOption == 2){
		NSString *cellIdentifire = @"Cell1";
		PhotoCategoryCell *cell = (PhotoCategoryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifire];
		
		
		if (cell == nil) {			
			NSArray *nib = nil;		
			
			nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoCategoryCell" owner:nil options:nil];
			cell = [nib objectAtIndex:0];	
			
			
		}
		[cell setImage:[UIImage imageNamed:@"cellBg.png"]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		NSMutableDictionary *dict = [arrayMyLikes objectAtIndex:indexPath.row];
		cell.nameLbl.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]];
		
		
		//NSLog(@"%@",[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=album&access_token=%@",[dict valueForKey:@"id"],appDeleg.fbGraph.accessToken]);
		
		if (![dict objectForKey:@"IconImage"])
		{
			
			if (tblCategory.dragging == NO && tblCategory.decelerating == NO)
			{
				
				//[self getImage:dict forIndexPath:indexPath];
			}
			
			
			cell.imgView.image = [UIImage imageNamed:@"placeholder.png"];                
		}
		else
		{
			
			cell.imgView.image = [dict objectForKey:@"IconImage"];
		}
		
        //cell.textLabel.text = [arrayMyalbums objectAtIndex:indexPath.row];
		
        
        //cell.textLabel.text = [arrayMyLikes objectAtIndex:indexPath.row];
        return cell;

    }
    else {
        
        static NSString *CellIdentifier = @"PhotoCategoryCell";
		
		PhotoCategoryCell *cell = (PhotoCategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		
		if (cell == nil) {			
			NSArray *nib = nil;		
			
			nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoCategoryCell" owner:nil options:nil];
			cell = [nib objectAtIndex:0];	
			
			
		}
		[cell setImage:[UIImage imageNamed:@"cellBg.png"]];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.nameLbl.text = [NSString stringWithFormat:@"%@",[[arrayFriends objectAtIndex:indexPath.row] valueForKey:@"name"]];

		
        NSMutableDictionary *dict = [arrayFriends objectAtIndex:indexPath.row];
        if (![dict objectForKey:@"IconImage"])
		{
			
			if (tblCategory.dragging == NO && tblCategory.decelerating == NO)
			{
				
				[self getImage:dict forIndexPath:indexPath];
			}
			
			
			cell.imgView.image = [UIImage imageNamed:@"placeholder.png"];                
		}
		else
		{
			
			cell.imgView.image = [dict objectForKey:@"IconImage"];
		}
//      cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%da",indexPath.row+1]];
//      cell.textLabel.text = 
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!objAlbum) {
        objAlbum = nil;
        [objAlbum release];
    }
    
	
	if(selectedOption == 1)
    {
		NSMutableDictionary *dict = (NSMutableDictionary*)[arrayMyalbums objectAtIndex:indexPath.row];
		//NSLog(@"list :: %@",dict);
		AlbumPicker *obj = [[AlbumPicker alloc]init];
		obj.photosArray = [self getMyAlbumPhotos:[NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]]];
		[self.navigationController pushViewController:obj animated:YES];
		[obj release];
    }
    else if(selectedOption == 2)
    {
		  
		NSMutableDictionary *dict = (NSMutableDictionary*)[arrayMyLikes objectAtIndex:indexPath.row];
		//NSLog(@"list :: %@",dict);
		GroupListView *obj = [[GroupListView alloc]init];
		obj.valueArray = [self getMyLikePhotos:[NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]]];
		[self.navigationController pushViewController:obj animated:YES];
		[obj release];
    }
    else if(selectedOption == 3)
    {
		NSMutableDictionary *dict = [arrayFriends objectAtIndex:indexPath.row];
		NSString *str = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
		NSMutableArray* arr = [self getFriendAlbumList:str];
		
		GroupListView *obj = [[GroupListView alloc]init];
		obj.valueArray = arr;
		[self.navigationController pushViewController:obj animated:YES];
    }
}

-(void)btnDownloadTapped:(id)sender
{
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to download all photos of album" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert1.tag =3;
    [alert1 show];
    [alert1 release];
}

-(NSMutableArray*)getFriendAlbumList:(NSString*)str
{
    fbResponce = [appDeleg.fbGraph doGraphGet:[NSString stringWithFormat:@"%@/albums",str] withGetVars:nil];
    SBJSON *parser = [[SBJSON alloc] init];
    NSDictionary *facebook_response = [parser objectWithString:fbResponce.htmlResponse error:nil];   
    [parser release];
	NSMutableArray* arr = [facebook_response objectForKey:@"data"];
    //NSLog(@"Friends Album list :: %@",arr);
    return arr;  
}

-(NSMutableArray*)getMyAlbumPhotos:(NSString*)str
{
    fbResponce = [appDeleg.fbGraph doGraphGet:[NSString stringWithFormat:@"%@/photos",str] withGetVars:nil];
    SBJSON *parser = [[SBJSON alloc] init];
    NSDictionary *facebook_response = [parser objectWithString:fbResponce.htmlResponse error:nil];
	//NSLog(@"Friends Album list :: %@",facebook_response);
    [parser release];
	NSMutableArray* arr = [facebook_response objectForKey:@"data"];
    //NSLog(@"Friends Album list :: %@",arr);
    return arr;  
}

-(NSMutableArray*)getMyLikePhotos:(NSString*)str
{
    fbResponce = [appDeleg.fbGraph doGraphGet:[NSString stringWithFormat:@"%@/albums",str] withGetVars:nil];
    SBJSON *parser = [[SBJSON alloc] init];
    NSDictionary *facebook_response = [parser objectWithString:fbResponce.htmlResponse error:nil];
	//NSLog(@"Friends Album list :: %@",facebook_response);
    [parser release];
	NSMutableArray* arr = [facebook_response objectForKey:@"data"];
    //NSLog(@"Friends Album list :: %@",arr);
    return arr;  
}

-(void)getMyAlbumList
{
    selectedOption = 1;
	[myTitleLbl setText:@"My Albums"];
	
    fbResponce = [appDeleg.fbGraph doGraphGet:@"me/albums" withGetVars:nil];
    SBJSON *parser = [[SBJSON alloc] init];
    NSDictionary *facebook_response = [parser objectWithString:fbResponce.htmlResponse error:nil];   
    [parser release];
    
	arrayMyalbums = [[NSArray alloc] initWithArray:[facebook_response objectForKey:@"data"]];
    
    //NSLog(@"Array %d Friends list :: %@",[arrayMyalbums count],arrayMyalbums);
    
    [tblCategory reloadData];    
    
}


-(void)getFriendList
{
    
    fbResponce = [appDeleg.fbGraph doGraphGet:@"me/friends" withGetVars:nil];
    SBJSON *parser = [[SBJSON alloc] init];
    NSDictionary *facebook_response = [parser objectWithString:fbResponce.htmlResponse error:nil];   
    [parser release];
    
	arrayFriends = [[NSArray alloc] initWithArray:[facebook_response objectForKey:@"data"]];
    
    //NSLog(@"Array %d Friends list :: %@",[arrayFriends count],arrayFriends);
    
    [tblCategory reloadData];    
    
}


-(void)getmyLikeList
{
    
    fbResponce = [appDeleg.fbGraph doGraphGet:@"me/likes" withGetVars:nil];
    SBJSON *parser = [[SBJSON alloc] init];
    NSDictionary *facebook_response = [parser objectWithString:fbResponce.htmlResponse error:nil];   
    [parser release];
    
	arrayMyLikes = [[NSArray alloc] initWithArray:[facebook_response objectForKey:@"data"]];
    
    //NSLog(@"Array %d Friends list :: %@",[arrayFriends count],arrayFriends);
    
    [tblCategory reloadData];    
    
}


-(void)changeView
{   
    NSMutableArray *arry = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"3.png"],[UIImage imageNamed:@"4.png"], nil];
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    if (objImageAdj) {
        objImageAdj = nil;
        [objImageAdj release];
    }
    
    objImageAdj = [[ImageAdjustMent alloc] initWithNibName:@"ImageAdjustMent" bundle:nil];
    objImageAdj.arrayMyalbum = arry;
    [self.navigationController pushViewController:objImageAdj animated:YES];
}   

-(IBAction)categorySelected:(id)sender
{
    UIBarButtonItem *btnTemp = (UIBarButtonItem *)sender;
    selectedOption = btnTemp.tag;
    //NSLog(@"%d",selectedOption);
	
	NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
	
	
    if(selectedOption == 1)
    {
		[myTitleLbl setText:@"My Albums"];
        self.navigationItem.title = @"My Albums";
        [self getMyAlbumList];    
    }
    else if(selectedOption == 2)
    {
		[myTitleLbl setText:@"My Likes"];
        self.navigationItem.title = @"Likes";
		[self getmyLikeList];

    }
    else if(selectedOption == 3)
    {
		[myTitleLbl setText:@"My Friends"];
        self.navigationItem.title = @"My Friends"; 
        [self getFriendList];
    }
    
}



- (void)viewDidUnload
{
    [tblCategory release];
    tblCategory = nil;
    [super viewDidUnload];
    
    [arrayFriends release];
    [arrayMyalbums release];
    [arrayMyLikes release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



#pragma mark Image Caching Methods



- (void) getImage:(NSMutableDictionary*)appRecord forIndexPath:(NSIndexPath *)indexPath
{
	
	NSString *ImageURLString;
	
	if(selectedOption == 1)
    {
		ImageURLString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=album&access_token=%@",[appRecord valueForKey:@"id"],appDeleg.fbGraph.accessToken];
	}
	else if(selectedOption == 2)
	{
		//ImageURLString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small",[appRecord objectForKey:@"id"]];
	}
	else if(selectedOption == 3)
	{
		ImageURLString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small",[appRecord objectForKey:@"id"]];
	}
	
	
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
		
		[tblCategory reloadData];
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
		iconDownloader.flag = selectedOption;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([arrayFriends count] > 0)
    {
        NSArray *visiblePaths = [tblCategory indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            NSMutableDictionary *appRecord = [arrayFriends objectAtIndex:indexPath.row];
            
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
		PhotoCategoryCell *cell = (PhotoCategoryCell*)[tblCategory cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
		
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
}

-(void)viewWillDisappear:(BOOL)animated
{

	[self.navigationController setNavigationBarHidden:NO animated:NO];
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    // Release any cached data, images, etc. that aren't in use.
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [tblCategory release];
    [super dealloc];
}
@end
