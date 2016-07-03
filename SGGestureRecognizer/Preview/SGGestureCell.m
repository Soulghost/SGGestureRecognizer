//
//  SGGestureCell.m
//  SGGestureRecognizer
//
//  Created by soulghost on 10/1/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGGestureCell.h"
#import "SGGestureSet.h"
#import "SGGestureView.h"

@interface SGGestureCell ()

@property (nonatomic, weak) SGGestureView *gesView;
@property (nonatomic, weak) UILabel *nameLabel;

@end

@implementation SGGestureCell

+ (instancetype)cellWithTableView:(UITableView *)tableView set:(SGGestureSet *)set {
    static NSString *ID = @"gestureCell";
    SGGestureCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SGGestureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.set = set;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        SGGestureView *gesView = [SGGestureView gestureView];
        self.gesView = gesView;
        [self.contentView addSubview:gesView];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

- (void)setSet:(SGGestureSet *)set {
    _set = set;
    self.gesView.set = set;
    self.nameLabel.text = set.name;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gesView.center = CGPointMake(self.gesView.frame.size.width * 0.5f + 10, GestureCellHeight * 0.5f);
    CGSize nameLabelSize = [self.nameLabel.text sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}];
    CGFloat nameLabelX = CGRectGetMaxX(self.gesView.frame) + 20;
    CGFloat nameLabelY = CGRectGetMidY(self.gesView.frame) - nameLabelSize.height * 0.5f;
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelSize.width, nameLabelSize.height);
}


@end
