//
//  SGGestureCell.h
//  SGGestureRecognizer
//
//  Created by soulghost on 10/1/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGGestureSet;

#define MagicCellHeight 230

@interface SGGestureCell : UITableViewCell

@property (nonatomic, strong) SGGestureSet *set;

+ (instancetype)cellWithTableView:(UITableView *)tableView set:(SGGestureSet *)set;

@end
