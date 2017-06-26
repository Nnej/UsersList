    //
    //  ViewController.m
    //  UsersList
    //
    //  Created by Jennifer on 26/06/2017.
    //  Copyright © 2017 Jennifer Guiard. All rights reserved.
    //

#import "ViewController.h"
#import "UserTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
    //#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *usersTableView;

@property (nonatomic) NSInteger lastLoadingPage;
@property (strong, nonatomic) NSMutableArray * usersDataArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        //Initialize empty datasource
    self.usersDataArray = [NSMutableArray new];
        // Register nib for custom cell
    [self.usersTableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:@"userCell"];
        // First call to load users list
    [self downloadUsersPage:0];
        // Initialize the loading page number
    self.lastLoadingPage = 0;
}

#pragma mark - UITableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90.0;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_usersDataArray count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellId = @"userCell";
    
    UserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
            // Load cell view from nib
        NSString *cellNib = @"UserTableViewCell";
        cell = [[[NSBundle mainBundle] loadNibNamed:cellNib owner:self options:nil] firstObject];
    }
        //Set users data on cell
    if([_usersDataArray count] > 0 ){
        NSDictionary * userData = [_usersDataArray objectAtIndex:indexPath.row];
        
        NSString * firstname = [userData objectForKey:@"first_name"] ? [userData objectForKey:@"first_name"] : @"";
        NSString * lastname = [userData objectForKey:@"last_name"] ? [userData objectForKey:@"last_name"] : @"";
            //Set complete name
        cell.userName.text = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
        
            //NSString * thumbnailURL = [userData objectForKey:@"thumb"];
            //cell.userThumbnail.image =  [thumbnailURL isEqualToString:@"missing.jpg"] ? [UIImage imageNamed:@"placeholder.jpg"] : [self loadImageFrom:thumbnailURL];
        cell.userThumbnail.image = [UIImage imageNamed:@"placeholder.jpg"];
    }
    
    return cell;
}

#pragma mark - Check method for cell
-(BOOL)lastsRowsAreVisible {
    NSArray *visibleRows = [_usersTableView indexPathsForVisibleRows];
    
    for (NSIndexPath *idx in visibleRows) {
        if (idx.row == [_usersDataArray count] - 5) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        //NSLog(@"Scroll stop");
    if([self lastsRowsAreVisible]){
            //NSLog(@"Lasts rows are visible so call the next page");
        _lastLoadingPage++;
        [self downloadUsersPage:_lastLoadingPage];
    }
}


#pragma mark - Web service(s)

-(void) downloadUsersPage:(NSInteger)pageNumber {
    
        //TODO: Check internet connection
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
        //Format URL
    NSString * URLString = [NSString stringWithFormat:@"http://ea0000-flo.preevent.magency.fr/api/v1/contacts?page=%ld",pageNumber];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    NSURLSessionDataTask *downloadTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
                //NSLog(@"RESPONSE %@", response);
            
            if(responseObject){
                [_usersDataArray addObjectsFromArray:responseObject];
                [_usersTableView reloadData];
            }
        }
    }];
    
    [downloadTask resume];
    
}



@end
