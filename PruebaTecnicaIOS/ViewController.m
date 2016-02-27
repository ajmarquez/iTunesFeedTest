//
//  ViewController.m
//  iTunesFeedTest
//
//  Created by Abelardo Marquez on 22/1/15.
//  Copyright (c) 2015 NinjaRobot. All rights reserved.
//

#define kUrl @"https://itunes.apple.com/search?term=Michael+jackson"

//Views
#import "SongCell.h"
#import "ViewController.h"

//Frameworks
#import "AFNetworking.h"
#import <MagicalRecord/MagicalRecord.h>

//Models
#import "Song.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.mainTable.emptyDataSetDelegate = self;
    self.mainTable.emptyDataSetSource = self;
    self.mainTable.tableFooterView = [UIView new];
    
    self.songArray = [Song MR_findAll];
    
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.songArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SongCell *cell = (SongCell*) [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Song *dummySong = self.songArray[indexPath.item];
    cell.trackLabel.text = dummySong.trackName;
    cell.collectionLabel.text = dummySong.collectionName;
    cell.countryLabel.text = dummySong.countryName;
    
    
    
    
    return cell;
}


#pragma mark - DZNEmptyDataset

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"oh oh!";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0 weight:UIFontWeightLight],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text                     = @"Esta es una prueba que demuestra el uso de AFNetworking, parseo de JSON, CoreData y manipulación de vista.\n Para comenzar, presiona Download para cargarlas";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode            = NSLineBreakByWordWrapping;
    paragraph.alignment                = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0 weight:UIFontWeightLight],
                                 NSForegroundColorAttributeName: [UIColor colorWithWhite:0.750 alpha:1.000],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
    
    return [[NSAttributedString alloc] initWithString:@"DOWNLOAD" attributes:attributes];
    
    
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return CGPointMake(0, 0);
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    
    NSLog(@"Tapped");
    [self getData];
}


# pragma mark - Descarga de JSON


// Obtiene JSON y parsea data
- (void)getData{
    
    
    
    NSURL *url = [NSURL URLWithString:kUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"Enters operation");
        
        NSDictionary *jsonFile = (NSDictionary *)responseObject;
        
        // Comienza parseo
        
        for (NSDictionary *element in [jsonFile valueForKey:@"results"]){
            
            //Condicion para no agregar duplicados
            
            if ([Song MR_findFirstByAttribute:@"trackName" withValue:[element valueForKey:@"trackName"]] && [Song MR_findFirstByAttribute:@"countryName" withValue:[element valueForKey:@"country"]]) {
                
                NSLog(@"Dunno why this is here");
                
            }else{
                
                Song *dummySong = [Song MR_createEntity];
                dummySong.trackName = [element valueForKey:@"trackName"];
                dummySong.collectionName = [element valueForKey:@"collectionCensoredName"];
                dummySong.countryName = [element valueForKey:@"country"];
                
                
                
                NSLog(@"This is a title %@", [element valueForKey:@"trackName"]);
            }
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                if (success) {
                    NSLog(@"You successfully saved your context.");
                } else if (error) {
                    NSLog(@"Error saving context: %@", error.description);
                }
            }];
            
            
            self.songArray = [Song MR_findAll];
            [self.mainTable reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"ERROR");
    }];
    
    
    [operation start];
    
    
}


// Refresca data en botón derecho
- (IBAction)refreshData:(id)sender{
    
    [self getData];
}



#pragma mark - Gesture Recognizer

- (IBAction)grabTheCube:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
}






@end
