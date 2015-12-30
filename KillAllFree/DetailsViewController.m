//
//  DetailsViewController.m
//  KillAllFree
//
//  Created by qianfeng on 15/9/24.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIView+Common.h"
#import <AFNetworking/AFNetworking.h>
#import "KillAllDefault.h"
#import "DetailsModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "NearModel.h"
#import "DBManager.h"
#import <MessageUI/MessageUI.h>

@interface DetailsViewController () <UIActionSheetDelegate,UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate> {
    UIImageView *_appImageView;
    UIImageView *_detailView;
    UIImageView *_aboutView;
    UIScrollView *_detailScrollView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_typeLabel;
    UITextView *_detailTextView;
    UIScrollView *_aboutScrollView;
    DetailsModel *_detailsModel;
    NSDictionary *_dict;
    NSMutableArray *_nearsArray;
    BOOL _isFavourite;
    UIButton *_imageView;
    NSMutableArray *_imageArray;
}

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = @"应用详情";
    titleLabel.textColor = [UIColor colorWithRed:30/255.f green:160/255.f blue:230/255.f alpha:1];
    titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self initData];
    [self creatView];
    [self creatDetailView];
    [self creatAboutView];
    _nearsArray = [NSMutableArray array];
}
- (void)initData {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:kDetailUrl,_idtifiner] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _detailsModel = [[DetailsModel alloc]initWithData:responseObject error:nil];
        [self laodNearApps];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}
-(void)buttonAction:(UIButton *)button {
    
    NSInteger btnTag = button.tag - 1000;
    if (btnTag == 1) {
        if (_isFavourite) {
            return;
        }
        [[DBManager sharedManager]insertModel:_detailsModel recordType:_detailsModel.categoryName];
        [self applicationIsFavourite];
    }else if (btnTag == 2) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_detailsModel.itunesUrl]];
    }else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"邮件",@"短信", nil];
        [actionSheet showInView:self.view];
    }
}
- (void)refreshUI {
    [_appImageView sd_setImageWithURL:[NSURL URLWithString:_detailsModel.iconUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    _titleLabel.text = _detailsModel.name;
    
    NSString *string = @"";
    if ([_detailsModel.priceTrend isEqualToString:@"limited"]) {
        string = @"限免中";
    }else if ([_detailsModel.priceTrend isEqualToString:@"sales"]) {
        string = @"降价中";
    }else if ([_detailsModel.priceTrend isEqualToString:@"free"]) {
        string = @"免费中";
    }
    _priceLabel.text = [NSString stringWithFormat:@"原价:￥%.2f %@ 文件大小:%@MB",[_detailsModel.lastPrice floatValue],string,_detailsModel.fileSize];
    
    _typeLabel.text = [NSString stringWithFormat:@"类型:%@  评分:%@分",_detailsModel.categoryName,_detailsModel.starOverall];
    
    NSInteger phototsCount = _detailsModel.photos.count;
    CGFloat buttonWidth = (width(_detailView.frame) - 5*4)/5;
    _imageArray = [NSMutableArray array];
    for (int i = 0; i < phototsCount; i++) {
        PhotosModel *photo = _detailsModel.photos[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*buttonWidth + i*5, 10, buttonWidth, 80);
        button.tag = 3000 + i;
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:photo.smallUrl] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_detailScrollView addSubview:button];
        [_imageArray addObject:photo.originalUrl];
    }
    
    [self applicationIsFavourite];
    
    _detailScrollView.delaysContentTouches = NO;
    _detailScrollView.contentSize = CGSizeMake(phototsCount*buttonWidth + (phototsCount-1)*5, 100);
    
    _detailTextView.text = _detailsModel.detailDescription;
    _detailTextView.font = [UIFont boldSystemFontOfSize:15];
    
    NSInteger nearAppCount = _nearsArray.count;
    CGFloat nearbuttonWidth = (width(_aboutScrollView.frame) - 5*4)/5;
    for (int i = 0; i < nearAppCount; i++) {
        NearModel *nearModel = _nearsArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 10;
        button.clipsToBounds = YES;
        button.frame = CGRectMake(i*nearbuttonWidth + i*5, 10, nearbuttonWidth, 75);
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:nearModel.iconUrl] forState:UIControlStateNormal];
        button.tag = 2000 + i;
        [button addTarget: self action:@selector(appIconTouch:) forControlEvents:UIControlEventTouchUpInside];
        [_aboutScrollView addSubview:button];
    }
    _aboutScrollView.delaysContentTouches = NO;
    _aboutScrollView.contentSize = CGSizeMake(nearAppCount*nearbuttonWidth + (nearAppCount-1)*5, height(_aboutView.frame) - 15);

}
-(void)buttonClick:(UIButton *)button {
    NSInteger btnTag = button.tag - 3000;
    _imageView = [[UIButton alloc]initWithFrame:self.view.frame];
    [_imageView sd_setBackgroundImageWithURL:[NSURL URLWithString:_imageArray[btnTag]] forState:UIControlStateNormal];
    [_imageView sd_setBackgroundImageWithURL:[NSURL URLWithString:_imageArray[btnTag]] forState:UIControlStateHighlighted];
    [_imageView addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_imageView];
    
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)imageButtonClick:(UIButton *)buttom {
    _imageView.alpha = 0;
    self.navigationController.navigationBarHidden = NO;
}
- (void)creatView {
    _detailView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 84, width(self.view.frame) - 10, height(self.view.frame)/2)];
    _detailView.layer.cornerRadius = 5.0;
    _detailView.userInteractionEnabled = YES;
    _detailView.image = [UIImage imageNamed:@"appdetail_background@2x"];
    [self.view addSubview:_detailView];
    
    _aboutView = [[UIImageView alloc]initWithFrame:CGRectMake(5, maxY(_detailView) + 10, width(self.view.frame) - 10 , 100)];
    _aboutView.layer.cornerRadius = 5.0;
    _aboutView.userInteractionEnabled = YES;
    _aboutView.image = [UIImage imageNamed:@"appdetail_recommend@2x"];
    [self.view addSubview:_aboutView];
}
- (void)creatDetailView {
    _appImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    [_detailView addSubview:_appImageView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(maxX(_appImageView) + 5, minY(_appImageView) - 5, width(self.view.frame) - maxX(_appImageView) - 20, 20)];
    [_detailView addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(maxX(_appImageView) + 5, maxY(_titleLabel) + 5, width(self.view.frame) - maxX(_appImageView) - 20, 25)];
    [_detailView addSubview:_priceLabel];
    
    _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(maxX(_appImageView) + 5, maxY(_priceLabel) + 5, width(self.view.frame) - maxX(_appImageView) - 20, 25)];
    [_detailView addSubview:_typeLabel];
    
    CGFloat buttonWidth = (width(_detailView.frame)-6.0)/3.0;
    NSArray *buttonTitleArray = @[@"分享", @"收藏" , @"下载"];
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            [button setBackgroundImage:[UIImage imageNamed:@"Detail_btn_left"] forState:UIControlStateNormal];
        }else if (i == 1) {
            [button setBackgroundImage:[UIImage imageNamed:@"Detail_btn_middle"] forState:UIControlStateNormal];
        }else {
            [button setBackgroundImage:[UIImage imageNamed:@"Detail_btn_right"] forState:UIControlStateNormal];
        }
        button.frame = CGRectMake(i*buttonWidth + 3.0, maxY(_appImageView)+ 5, buttonWidth, 45);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        button.tag = 1000 + i;
        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_detailView addSubview:button];
    }
    
    
    _detailScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, maxY(_appImageView) + 45 + 5 + 5, width(_detailView.frame)-20, 100)];
    _detailScrollView.contentSize = CGSizeMake(2*width(_detailScrollView.frame), 80);
    _detailScrollView.contentOffset = CGPointMake(0, 0);
    [_detailView addSubview:_detailScrollView];
    
    _detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, maxY(_detailScrollView) + 5, width(_detailView.frame) - 20, 80)];
    _detailTextView.editable = NO;
    [_detailView addSubview:_detailTextView];
}
- (void)creatAboutView {
    _aboutScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(5, 10, width(_aboutView.frame) - 10, height(_aboutView.frame) - 15)];
    _aboutScrollView.contentSize = CGSizeMake(width(_aboutView.frame), height(_aboutView.frame)-15);
    _aboutScrollView.contentOffset = CGPointMake(0, 0);
    _aboutScrollView.delaysContentTouches = NO;
    [_aboutView addSubview:_aboutScrollView];
}
-(void)applicationIsFavourite {
    _isFavourite = [[DBManager sharedManager]isExistAppForAppId:_detailsModel.applicationId recordType:_detailsModel.categoryName];
    if (_isFavourite) {
        UIButton *button = (UIButton *)[_detailView viewWithTag:1001];
        [button setTitle:@"已收藏" forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
        button.selected = YES;
    }
}
-(void)appIconTouch:(UIButton *)button {
    
    NSInteger btnTag = button.tag - 2000;
    DetailsViewController *detail = [[DetailsViewController alloc]init];
    detail.idtifiner = [(NearModel *)_nearsArray[btnTag] applicationId];
    detail.title = @"";
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)laodNearApps {
    NSString *url = [NSString stringWithFormat:kNearAppUrl,116.344539,40.034346];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *nearModelDict in modelDict[@"applications"]) {
            NearModel *model = [NearModel new];
            [model setValuesForKeysWithDictionary:nearModelDict];
            [_nearsArray addObject:model];
        }
        [self refreshUI];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (CGFloat)heightForRow:(NSString *)aString width:(CGFloat)widht labelFont:(UIFont *)labelFont {
    CGSize size = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        size = [aString boundingRectWithSize:CGSizeMake(widht, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:labelFont}  context:nil].size;
    } else {
        size = [aString sizeWithFont:labelFont constrainedToSize:CGSizeMake(widht, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return size.height;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc]init];
            message.recipients = @[@"10086",@"13525233897"];
            message.body = [NSString stringWithFormat:@"%@",_detailsModel.itunesUrl];
            message.messageComposeDelegate = self;
            [self presentViewController:message animated:YES completion:^{
                
            }];
        }else {
            NSLog(@"不支持短信发送");
        }
    }else {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc]init];
            [mailView setToRecipients:@[@"",@""]];
            [mailView setCcRecipients:@[@""]];
            [mailView setSubject:@""];
            [mailView setMessageBody:[NSString stringWithFormat:@"account_candou"] isHTML:YES];
            [mailView addAttachmentData:UIImagePNGRepresentation([UIImage imageNamed:@""]) mimeType:@"image/png" fileName:@"icon.png"];
            mailView.mailComposeDelegate = self;
            [self presentViewController:mailView animated:YES completion:^{
                
            }];
        }
    }
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"信息发送取消");
            break;
            
        case MessageComposeResultFailed:
            NSLog(@"信息发送失败");
            break;
            
        case MessageComposeResultSent:
            NSLog(@"信息发送成功");
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"邮件发送取消");
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"邮件发送失败");
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"邮件发送成功");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"保存草稿");
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
