//
//  notificationListViewController.m
//  SHVPN
//
//  Created by Tommy on 2018/4/26.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "notificationListViewController.h"
#import "textTableViewCell.h"
#import "adViewController.h"
#import "activityModel.h"
@interface notificationListViewController ()<UITableViewDelegate,UITableViewDataSource>
    
@property(nonatomic,strong)UITableView *table;
    @property(nonatomic,strong)NSMutableArray *dataArr;
//    @property(nonatomic,strong)NSMutableArray *detailArray;
@end

@implementation notificationListViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"line_nav"] forBarMetrics:UIBarMetricsDefault ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息列表";
    [self getNoticeData];
    
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.table];
    
    [self.table registerNib:[UINib nibWithNibName:@"textTableViewCell" bundle:nil] forCellReuseIdentifier:@"text"];
}

    
    
-(UITableView *)table{
    if(_table == nil){
        _table = [[UITableView alloc]initWithFrame:self.view.bounds];
    }
    
    return _table;
}
    
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
    
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
    
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40 * KHeight_Scale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80 *KHeight_Scale;
}
    
    
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *v = [[UILabel alloc]init];

    v.textAlignment =  NSTextAlignmentCenter;
     activityModel *model = self.dataArr[section];
    if(self.dataArr.count != 0){
        v.font = [UIFont systemFontOfSize:13];
        v.textColor = [UIColor grayColor];
        
        v.text = model.start_date;
    }
  
    return v;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    textTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"text"  forIndexPath:indexPath];
    activityModel *model = self.dataArr[indexPath.section];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    cell.textLabel.text = model.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     activityModel *model = self.dataArr[indexPath.section];
    if (model.link) {
        adViewController *ad = [[adViewController alloc]init];
        
        ad.adURL = model.link;
        [self.navigationController pushViewController:ad animated:YES];
    }
   
}
-(void)getNoticeData{
    
    NSString *str = [rootUrl stringByAppendingString:notificationUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    [manager POST:str parameters:@{@"bundle_id":[NSBundle mainBundle].bundleIdentifier} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess decode:str key:keyDES];
        NSDictionary *dicData = [str jsonDictionary];
        for(NSDictionary *dic in dicData[@"data"]){
            activityModel *model = [[activityModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:model];
        }
        
        [_table reloadData];
        NSLog(@"促销信息数据：%@",dicData);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(NSMutableArray *)dataArr{
    if(_dataArr == nil){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
