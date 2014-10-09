//
//  NewsCell.m
//  NewsFeed
//
//  Created by ZhangBoxuan on 14/10/8.
//  Copyright (c) 2014年 ZhangBoxuan. All rights reserved.
//

#import "NewsCell.h"

@interface NewsCell ()

@property (weak, nonatomic) IBOutlet UILabel *l_content;
@property (weak, nonatomic) IBOutlet UIImageView *iv_image;


@end

@implementation NewsCell

- (void)setContent:(NSString *)content
{
    if(![self.content isEqualToString:content]){
        _content = content;
        
        self.l_content.text = _content;

    }
}

- (void)setImage:(UIImage *)image
{
    if(![self.image isEqual:image]){
        _image = image;
        self.iv_image.image = _image;
        
    }
}

- (void)awakeFromNib {
    // Initialization code
    self.iv_image.contentMode = UIViewContentModeScaleAspectFit;
    self.ai_fetchingImage.hidesWhenStopped = YES;
    
    self.l_content.lineBreakMode = NSLineBreakByWordWrapping;
    self.l_content.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
