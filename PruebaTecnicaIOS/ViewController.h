//
//  ViewController.h
//  iTunesFeedTest
//
//  Created by Abelardo Marquez on 22/1/15.
//  Copyright (c) 2015 NinjaRobot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (strong, nonatomic) NSArray *songArray;


// <etodo para manejar el cuadrado de color
- (IBAction)grabTheCube:(UIPanGestureRecognizer *)recognizer;

// Metodo para obtener canciones de MJ
- (IBAction)refreshData:(id)sender;


@end

