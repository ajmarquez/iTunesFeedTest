//
//  Song+CoreDataProperties.h
//  iTunesFeedTest
//
//  Created by Abelardo Marquez on 3/2/16.
//  Copyright © 2016 NinjaRobot. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface Song (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *trackName;
@property (nullable, nonatomic, retain) NSString *collectionName;
@property (nullable, nonatomic, retain) NSString *countryName;

@end

NS_ASSUME_NONNULL_END
