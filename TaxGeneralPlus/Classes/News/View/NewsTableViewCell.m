/************************************************************
 Class    : NewsTableViewCell.m
 Describe : 首页新闻展示自定义TableViewCell样式
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-26
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "NewsTableViewCell.h"
#import "NewsModel.h"

#define TITLE_FONT [UIFont systemFontOfSize:18.0f]
#define DESCRIBE_FONT [UIFont systemFontOfSize:12.0f]

@interface NewsTableViewCell ()

@property (nonatomic, assign) float baseSpace;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *fewImageView;

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UILabel *describeLabel;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation NewsTableViewCell

#pragma mark - 初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.fewImageView];
        [self.contentView addSubview:self.leftImageView];
        [self.contentView addSubview:self.centerImageView];
        [self.contentView addSubview:self.rightImageView];
        [self.contentView addSubview:self.describeLabel];
        [self.contentView addSubview:self.bottomLine];
    }
    
    return self;
}

#pragma mark 布局加载
- (void)layoutSubviews{
    [super layoutSubviews];
    
    _baseSpace = 10;
    float imageWidth = (self.frameWidth - _baseSpace * 3)/3;
    
    // 文本样式
    if(_model.style == NewsModelStyleText){
        float titleLabelX = _baseSpace;
        float titleLabelY = _baseSpace;
        CGSize titleSize = [[BaseHandleUtil sharedBaseHandleUtil] sizeWithString:_model.title font:TITLE_FONT maxSize:CGSizeMake(self.frameWidth - (_baseSpace * 2), MAXFLOAT)];
        float titleLabelW = titleSize.width;
        float titleLabelH = titleSize.height;
        [_titleLabel setFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        
        float describeLabelX = _baseSpace;
        float describeLabelY = _baseSpace + titleLabelH + _baseSpace;
        float describeLabelW = titleLabelW;
        float describeLabelH = 10.0;
        [_describeLabel setFrame:CGRectMake(describeLabelX, describeLabelY, describeLabelW, describeLabelH)];
        
        // 计算cell高度
        _model.cellHeight = _baseSpace + titleLabelH + _baseSpace + describeLabelH + _baseSpace;
        
    }
    
    // 单图样式
    if(_model.style == NewsModelStyleFewImage){
        float fewImageViewW = imageWidth;
        float fewImageViewH = 75;
        float fewImageViewX = self.frameWidth - _baseSpace - fewImageViewW;
        float fewImageViewY = _baseSpace;
        [_fewImageView setFrame:CGRectMake(fewImageViewX, fewImageViewY, fewImageViewW, fewImageViewH)];
        
        float titleLabelX = _baseSpace;
        float titleLabelY = _baseSpace;
        CGSize titleSize = [[BaseHandleUtil sharedBaseHandleUtil] sizeWithString:_model.title font:TITLE_FONT maxSize:CGSizeMake(self.frameWidth - (_baseSpace * 3) - fewImageViewW, MAXFLOAT)];
        float titleLabelW = titleSize.width;
        float titleLabelH = titleSize.height;
        [_titleLabel setFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        
        float describeLabelX = _baseSpace;
        float describeLabelY = 0;
        if(titleLabelH + _baseSpace + 8.0 <= 75){
            describeLabelY = _baseSpace + 75 - 8.0;
        }else{
            describeLabelY = _baseSpace + titleLabelH + _baseSpace;
        }
        
        float describeLabelW = titleLabelW;
        float describeLabelH = 10.0;
        [_describeLabel setFrame:CGRectMake(describeLabelX, describeLabelY, describeLabelW, describeLabelH)];
        
        // 计算cell高度
        if((titleLabelH + _baseSpace + describeLabelH) > 75){
            _model.cellHeight = _baseSpace + titleLabelH + _baseSpace + describeLabelH + _baseSpace;
        }else{
            _model.cellHeight = _baseSpace + 75 + _baseSpace;
        }
        
    }
    
    // 多图样式
    if(_model.style == NewsModelStyleMoreImage){
        
        float titleLabelX = _baseSpace;
        float titleLabelY = _baseSpace;
        CGSize titleSize = [[BaseHandleUtil sharedBaseHandleUtil] sizeWithString:_model.title font:TITLE_FONT maxSize:CGSizeMake(self.frameWidth - (_baseSpace * 2), MAXFLOAT)];
        float titleLabelW = titleSize.width;
        float titleLabelH = titleSize.height;
        [_titleLabel setFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        
        float leftImageViewX = _baseSpace;
        float leftImageViewY = _baseSpace + titleLabelH + _baseSpace;
        float leftImageViewW = imageWidth;
        float leftImageViewH = 75;
        [_leftImageView setFrame:CGRectMake(leftImageViewX, leftImageViewY, leftImageViewW, leftImageViewH)];
        
        float centerImageViewX = _baseSpace + imageWidth + 5;
        float centerImageViewY = _baseSpace + titleLabelH + _baseSpace;
        float centerImageViewW = imageWidth;
        float centerImageViewH = 75;
        [_centerImageView setFrame:CGRectMake(centerImageViewX, centerImageViewY, centerImageViewW, centerImageViewH)];
        
        float rightImageViewX = _baseSpace + imageWidth + 5 + imageWidth + 5;
        float rightImageViewY = _baseSpace + titleLabelH + _baseSpace;
        float rightImageViewW = imageWidth;
        float rightImageViewH = 75;
        [_rightImageView setFrame:CGRectMake(rightImageViewX, rightImageViewY, rightImageViewW, rightImageViewH)];
        
        float describeLabelX = _baseSpace;
        float describeLabelY = _baseSpace + titleLabelH + _baseSpace + 75 + _baseSpace;
        float describeLabelW = titleLabelW;
        float describeLabelH = 10.0;
        [_describeLabel setFrame:CGRectMake(describeLabelX, describeLabelY, describeLabelW, describeLabelH)];
        
        // 计算cell高度
        _model.cellHeight = _baseSpace + titleLabelH + _baseSpace + 75 + _baseSpace + describeLabelH + _baseSpace;
    }
    
    // 设置每个cell底部线条
    float bottomLineX = _baseSpace;
    float bottomLineY = _model.cellHeight - 0.5f;
    float bottomLineW = self.frameWidth - (_baseSpace * 2);
    float bottomLineH = 0.5f;
    [_bottomLine setFrame:CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH)];
    
}

#pragma mark 通过Setter方法为模型赋值
- (void)setModel:(NewsModel *)model{
    _model = model;
    
    [_titleLabel setText:_model.title];
    if(_model.style == NewsModelStyleFewImage){
        NSString *fewImageName = [_model.images objectAtIndex:0];
        // 获取本地图片
        [_fewImageView setImage:[UIImage imageNamed:fewImageName]];
        // 从远程url获取https图片
        // [_fewImageView sd_setImageWithURL:[NSURL URLWithString:fewImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:nil];
        // 从远程url获取图片并裁剪
        /*
        [_fewImageView sd_setImageWithURL:[NSURL URLWithString:fewImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            // 在回调block中进行图片裁剪处理（去除一圈白边）
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(20, 20, image.size.width-40, image.size.height-40));
            _fewImageView.image =[UIImage imageWithCGImage:imageRef];
        }];
         */
        
        _fewImageView.hidden = NO;
        _leftImageView.hidden = YES;
        _centerImageView.hidden = YES;
        _rightImageView.hidden = YES;
    }else if(_model.style == NewsModelStyleMoreImage){
        NSString *leftImageName = [_model.images objectAtIndex:0];
        NSString *centerImageName = [_model.images objectAtIndex:1];
        NSString *rightImageName = [_model.images objectAtIndex:2];
        // 获取本地图片
        [_leftImageView setImage:[UIImage imageNamed:leftImageName]];
        [_centerImageView setImage:[UIImage imageNamed:centerImageName]];
        [_rightImageView setImage:[UIImage imageNamed:rightImageName]];
        
        // 从远程url获取https图片
        /*
         [_leftImageView sd_setImageWithURL:[NSURL URLWithString:leftImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:nil];
         [_centerImageView sd_setImageWithURL:[NSURL URLWithString:centerImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:nil];
         [_rightImageView sd_setImageWithURL:[NSURL URLWithString:rightImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:nil];
         */
        // 从远程url获取图片并裁剪
        /*
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:leftImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            // 在回调block中进行图片裁剪处理（去除一圈白边）
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(20, 20, image.size.width-40, image.size.height-40));
            _leftImageView.image =[UIImage imageWithCGImage:imageRef];
        }];
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:centerImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            // 在回调block中进行图片裁剪处理（去除一圈白边）
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(20, 20, image.size.width-40, image.size.height-40));
            _centerImageView.image =[UIImage imageWithCGImage:imageRef];
        }];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:rightImageName] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            // 在回调block中进行图片裁剪处理（去除一圈白边）
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(20, 20, image.size.width-40, image.size.height-40));
            _rightImageView.image =[UIImage imageWithCGImage:imageRef];
        }];
        */
        
        _fewImageView.hidden = YES;
        _leftImageView.hidden = NO;
        _centerImageView.hidden = NO;
        _rightImageView.hidden = NO;
    }else{
        _fewImageView.hidden = YES;
        _leftImageView.hidden = YES;
        _centerImageView.hidden = YES;
        _rightImageView.hidden = YES;
    }
    // 设置底部显示为来源+时间
    [_describeLabel setText:[NSString stringWithFormat:@"%@  %@",_model.source, _model.datetime]];
    [_describeLabel setText:_model.datetime];
    
    [self layoutSubviews];
}

#pragma mark 初始化各组件的Getter方法
- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:TITLE_FONT];
        _titleLabel.numberOfLines = 0;  // 标签显示不限制行数
    }
    return _titleLabel;
}

- (UIImageView *)fewImageView{
    if(_fewImageView == nil){
        _fewImageView = [[UIImageView alloc] init];
    }
    return _fewImageView;
}

- (UIImageView *)leftImageView{
    if(_leftImageView == nil){
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

- (UIImageView *)centerImageView{
    if(_centerImageView == nil){
        _centerImageView = [[UIImageView alloc] init];
    }
    return _centerImageView;
}

- (UIImageView *)rightImageView{
    if(_rightImageView == nil){
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}

- (UILabel *)describeLabel{
    if(_describeLabel == nil){
        _describeLabel = [[UILabel alloc] init];
        [_describeLabel setTextColor:[UIColor lightGrayColor]];
        [_describeLabel setFont:DESCRIBE_FONT];
    }
    return _describeLabel;
}

- (UIView *)bottomLine{
    _bottomLine = [[UIView alloc] init];
    [_bottomLine setBackgroundColor:[UIColor lightGrayColor]];
    [_bottomLine setAlpha:0.4];
    [self.contentView addSubview:_bottomLine];
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end