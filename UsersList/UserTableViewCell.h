//
//  UserTableViewCell.h
//  UsersList
//
//  Created by Jennifer on 26/06/2017.
//  Copyright © 2017 Jennifer Guiard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end
