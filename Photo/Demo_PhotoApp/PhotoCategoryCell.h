//
//  PhotoCategoryCell.h
//  Demo_PhotoApp
//
//  Created by apple on 6/23/12.
//  Copyright 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoCategoryCell : UITableViewCell {

	IBOutlet UILabel *nameLbl;
	IBOutlet UILabel *countLbl;
	IBOutlet UIImageView *imgView;
}

@property ( nonatomic , retain )IBOutlet UILabel *nameLbl;
@property ( nonatomic , retain )IBOutlet UILabel *countLbl;
@property ( nonatomic , retain )IBOutlet UIImageView *imgView;



@end
