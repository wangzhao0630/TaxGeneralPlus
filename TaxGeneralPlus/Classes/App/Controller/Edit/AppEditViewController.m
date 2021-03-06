/************************************************************
 Class    : AppEditViewController.m
 Describe : 应用管理编辑模块视图控制器
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-31
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppEditViewController.h"
#import "AppEditViewCell.h"
#import "AppEditHeaderView.h"
#import "AppModel.h"
#import "AppUtil.h"

@interface AppEditViewController () <AppEditViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation AppEditViewController

static NSString * const reuseCellIdentifier = @"reuseCellIdentifier";
static NSString * const reuseHeaderIdentifier = @"reuseHeaderIdentifier";


- (instancetype)init {
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;// 确定是水平滚动，还是垂直滚动
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    return [super initWithCollectionViewLayout:_flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的应用管理";
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;// 总是可垂直滑动
    self.collectionView.showsVerticalScrollIndicator = NO; // 隐藏垂直滚动条
    
    // Register cell classes
    [self.collectionView registerClass:[AppEditViewCell class] forCellWithReuseIdentifier:reuseCellIdentifier];
    [self.collectionView registerClass:[AppEditHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
    
    //添加导航栏右侧按钮
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(editAppData:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;// 初始化保存按钮不可点击
    
    [self initializeData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;// 设置顶部状态栏字体为黑色
    self.navigationController.navigationBar.tintColor = DEFAULT_BLUE_COLOR;// 设置导航栏itemBar字体颜色
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor blackColor] };// 设置导航栏title标题字体颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

#pragma mark - 初始化加载数据
- (void)initializeData {
    NSMutableDictionary *appDict = [[AppUtil sharedAppUtil] loadAppData];
    if(appDict){
        [self handleData:appDict];
    }else{
        [[AppUtil sharedAppUtil] initAppDataSuccess:^(NSMutableDictionary *dataDict) {
            [self handleData:dataDict];
        } failure:^(NSString *error) {
            [MBProgressHUD showHUDView:self.view text:error progressHUDMode:YZProgressHUDModeShow];
        } invalid:^(NSString *msg) {
            SHOW_RELOGIN_VIEW
        }];
    }
}

#pragma mark - 处理数据
- (void)handleData:(NSMutableDictionary *)data{
    NSArray *mineAppData = [data objectForKey:@"mineData"];
    NSArray *otherAppData = [data objectForKey:@"allData"];
    
    NSMutableArray *mineArray = [NSMutableArray array];
    for(NSDictionary *dict in mineAppData){
        AppModelItem *item = [AppModelItem createWithDictionary:dict];
        [mineArray addObject:item];
    }
    NSMutableArray *otherArray = [NSMutableArray array];
    for(NSDictionary *dict in otherAppData){
        AppModelItem *item = [AppModelItem createWithDictionary:dict];
        [otherArray addObject:item];
    }
    
    AppModelGroup *mineGroup = [[AppModelGroup alloc] init];
    mineGroup.items = mineArray;
    mineGroup.groupTitle = @"我的应用";
    
    AppModelGroup *otherGroup = [[AppModelGroup alloc] init];
    otherGroup.items = otherArray;
    otherGroup.groupTitle = @"全部应用";
    _data = [NSMutableArray array];
    [_data addObject:mineGroup];
    [_data addObject:otherGroup];
}

#pragma mark - <UICollectionViewDataSource> 数据源方法
#pragma mark 返回有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.data.count;
}

#pragma mark 返回每组多少条
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    AppModelGroup *group = [self.data objectAtIndex:section];
    return group.itemsCount;
}

#pragma mark 返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell
    AppModelGroup *group = [_data objectAtIndex:indexPath.section];
    AppModelItem *item = [group itemAtIndex:indexPath.row];
    
    AppEditViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellIdentifier forIndexPath:indexPath];
    
    //第一组为我的应用
    if(indexPath.section == 0){
        cell.editBtnStyle = AppCellEditBtnStyleDelete;
    }else{  // 剩下的为其他应用
        cell.editBtnStyle = AppCellEditBtnStyleAdd;
        AppModelGroup *groupMine = [self.data objectAtIndex:0];
        AppModelGroup *groupAll = [self.data objectAtIndex:1];
        // 循环判断“全部应用”中哪些为“我的应用”，设置编辑按钮样式
        [groupAll.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AppModelItem *allItem = (AppModelItem *)obj;
            for(AppModelItem *mineObj in groupMine.items){
                if([mineObj.no isEqualToString:allItem.no] && indexPath.row == idx){
                    cell.editBtnStyle = AppCellEditBtnStyleSelected;
                }
            }
        }];
    }
    
    cell.delegate = self;
    
    [cell setItem:item];
    
    return cell;
}

#pragma mark 设置cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = floor((CGFloat)(collectionView.frameWidth)/4);
    return CGSizeMake(width, width);
}

#pragma mark 设置cell上下间隙
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - <UICollectionViewDelegate> 代理方法
#pragma mark 设置每组的顶部视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    AppEditHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        AppModelGroup *group = [_data objectAtIndex:indexPath.section];
        headerView.title = group.groupTitle;
    }
    
    return headerView;
}

#pragma mark 设置顶部视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    float h = 32.0f;
    if(DEVICE_SCREEN_INCH_IPAD)
        h = 51.2f;
    return (CGSize){WIDTH_SCREEN, h};
}

#pragma mark - 代理编辑按钮点击方法
- (void)appEditViewCellEditBtnClick:(UIButton *)sender {
    
    UIView *view = [sender superview];//获取父类view
    AppEditViewCell *cell = (AppEditViewCell *)[view superview];//获取cell
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];//获取cell对应的indexpath;
    
    if(sender.tag == 0){    // 移除方法
        //DLog(@"进入移除方法 -> senction = %ld, row = %ld",(long)indexpath.section,(long)indexpath.row);
        
        AppModelGroup *mineGroup = [self.data objectAtIndex:0];
        if(mineGroup.itemsCount > 1){
            AppModelItem *delItem = [mineGroup.items objectAtIndex:indexpath.row];
            [mineGroup.items removeObject:delItem];
            [self.collectionView reloadData];
        }else{
            [MBProgressHUD showHUDView:self.view text:@"已经是最后一个我的应用了" progressHUDMode:YZProgressHUDModeShow];
        }
    }
    if(sender.tag == 1){    // 添加方法
        //DLog(@"进入添加方法 -> senction = %ld, row = %ld",(long)indexpath.section,(long)indexpath.row);
        
        AppModelGroup *mineGroup = [self.data objectAtIndex:0];
        if(mineGroup.itemsCount < 12){
            AppModelGroup *allGroup = [self.data objectAtIndex:1];
            AppModelGroup *addItem = [allGroup.items objectAtIndex:indexpath.row];
            [mineGroup.items addObject:addItem];
            [self.collectionView reloadData];
        }else{
            [MBProgressHUD showHUDView:self.view text:@"最多添加12个我的应用" progressHUDMode:YZProgressHUDModeShow];
        }
    }
    
    [self.collectionView reloadData];
    
    // 点击编辑按钮后设置保存按钮可点击
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}

#pragma mark - 编辑方法
- (void)editAppData:(UIBarButtonItem *)sender{
    // 点击保存将数据写入SandBox覆盖以前数据
    AppModelGroup *mineGroup = [self.data objectAtIndex:0];
    AppModelGroup *otherGroup = [self.data objectAtIndex:1];
    AppModelGroup *allGroup = [self.data objectAtIndex:1];
    
    NSMutableArray *mineData = [[NSMutableArray alloc] init];
    NSMutableArray *otherData = [[NSMutableArray alloc] init];
    NSMutableArray *allData = [[NSMutableArray alloc] init];
    
    // 我的应用数据
    int ids = 1;
    for(AppModelItem *mineItem in mineGroup.items){
        DLog(@"mineItem.url = %@", mineItem.url);
        NSDictionary *mineDict = [NSDictionary dictionaryWithObjectsAndKeys: mineItem.no, @"appno", mineItem.title, @"appname", mineItem.webImg, @"appimage", mineItem.url, @"appurl", [NSString stringWithFormat:@"%d", ids], @"userappsort", @"1", @"apptype", mineItem.isNewApp ? @"Y" : @"N", @"isnewapp", nil];
        [mineData addObject:mineDict];
        ids++;
    }
    // 其他应用数据
    for(AppModelItem *otherItem in otherGroup.items){
        NSInteger i = 0;
        for(AppModelItem *mineItem in mineGroup.items){
            if([otherItem.no isEqualToString:mineItem.no]){
                i++;
            }
        }
        if(i == 0){
            NSDictionary *otherDict = [NSDictionary dictionaryWithObjectsAndKeys:otherItem.no, @"appno", otherItem.title, @"appname", otherItem.webImg, @"appimage", otherItem.url, @"appurl", @"2", @"apptype", otherItem.isNewApp ? @"Y" : @"N", @"isnewapp", nil];
            [otherData addObject:otherDict];
        }
    }
    
    // 全部应用数据
    for(AppModelItem *allItem in allGroup.items){
        NSDictionary *allDict = [NSDictionary dictionaryWithObjectsAndKeys:allItem.no, @"appno", allItem.title, @"appname", allItem.webImg, @"appimage", allItem.url, @"appurl", allItem.isNewApp ? @"Y" : @"N", @"isnewapp", nil];
        [allData addObject:allDict];
    }
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:mineData, @"mineData", otherData, @"otherData", allData, @"allData", nil];
    
    BOOL res = [[AppUtil sharedAppUtil] writeAppData:dataDict];
    if(res){
        [MBProgressHUD showHUDView:self.view text:@"保存成功！" progressHUDMode:YZProgressHUDModeShow];
        // 点击编辑按钮后设置保存按钮可点击
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        [MBProgressHUD showHUDView:self.view text:@"保存失败，请检查原因！" progressHUDMode:YZProgressHUDModeShow];
    }
}

@end
