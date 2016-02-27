//
//  SongCell.h
//  iTunesFeedTest
//
//  Created by Abelardo Marquez on 3/2/16.
//  Copyright © 2016 NinjaRobot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@end
