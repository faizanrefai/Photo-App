#import "AppDelegate.h"@protocol IconDownloaderDelegate;@interface IconDownloader : NSObject{    NSMutableDictionary *appRecord;    NSIndexPath *indexPathInTableView;    id <IconDownloaderDelegate> delegate;        NSMutableData *activeDownload;    NSURLConnection *imageConnection;		int flag;	AppDelegate *appDeleg;}@property ( nonatomic , assign )int flag;@property (nonatomic, retain) NSMutableDictionary *appRecord;@property (nonatomic, retain) NSIndexPath *indexPathInTableView;@property (nonatomic, assign) id <IconDownloaderDelegate> delegate;@property (nonatomic, retain) NSMutableData *activeDownload;@property (nonatomic, retain) NSURLConnection *imageConnection;- (void)startDownload;- (void)cancelDownload;@end@protocol IconDownloaderDelegate - (void)appImageDidLoad:(NSIndexPath *)indexPath;@end