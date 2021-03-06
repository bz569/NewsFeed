//
//  NewsFeedViewController.m
//  NewsFeed
//
//  Created by ZhangBoxuan on 14/10/8.
//  Copyright (c) 2014年 ZhangBoxuan. All rights reserved.
//

#import "NewsFeedViewController.h"
#import <Parse/Parse.h>
#import "NewsCell.h"

@interface NewsFeedViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tv_news;

@property (strong, nonatomic) NSMutableArray *newsArray;
@property (strong, nonatomic) NSMutableDictionary *imageCache;

@property (nonatomic) CGRect screenRect;


@end

@implementation NewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.newsArray = [[NSMutableArray alloc] initWithCapacity:10];
    self.imageCache = [[NSMutableDictionary alloc] initWithCapacity:10];
    [self setViews];
    [self fetchDataFromParse];
}

- (void)setViews
{
    self.tv_news.dataSource = self;
    self.tv_news.delegate = self;
    
    self.screenRect = [[UIScreen mainScreen] bounds];

}

- (void)fetchDataFromParse
{
    PFQuery *queryNews = [PFQuery queryWithClassName:@"Status"];
    [queryNews findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(PFObject *obj in objects){
//            NSString *content = obj[@"content"];
//            NSString *newsID = obj.objectId;
//            
//            NSDictionary *news = [[NSDictionary alloc] initWithObjectsAndKeys:content, @"content", newsID, @"id", nil];
            [self.newsArray addObject:obj];
        }
        
        [self.tv_news reloadData];
    }];
}

#pragma mark
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NewsCellIdentifier";
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"NewsCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        nibsRegistered = YES;
    }
    
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFObject *obj = [self.newsArray objectAtIndex:indexPath.row];
    cell.content = obj[@"content"];
    
    PFFile *imageFile = obj[@"imageFile"];
    if(imageFile){
    
        UIImage *image = [self.imageCache objectForKey:obj.objectId];
        if(!image){
            [cell.ai_fetchingImage startAnimating];
    //        PFFile *imageFile = obj[@"imageFile"];
            //    [self setImageWithImageFile:imageFile ForCell:cell];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                [self setImageWithImageData:data OFobjectID:obj.objectId ForCell:cell];
            }];
        }
        cell.image = image;
    }
    
    return cell;
    
}

- (void)setImageWithImageData:(NSData*)imageData
                   OFobjectID:(NSString*)objectID
                      ForCell:(NewsCell*)cell
{
    UIImage *image = [UIImage imageWithData:imageData];
    
    CGFloat screenWidth = self.screenRect.size.width;
    
    CGFloat newImageWidth = screenWidth - 16.0;
    CGFloat newImageHeight = image.size.height * (newImageWidth / image.size.width);
    
    image = [self imageWithImage:image scaledToSize:CGSizeMake(newImageWidth, newImageHeight)];
    [self.imageCache setObject:image forKey:objectID];
    
    [cell.ai_fetchingImage stopAnimating];
    [self.tv_news reloadData];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end




























