//
//  buyListViewController.m
//  SHVPN
//
//  Created by Tommy on 2018/1/3.
//  Copyright © 2018年 TouchingApp. All rights reserved.
//

#import "buyListViewController.h"
#import "packageModel.h"
@interface buyListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *listArray;
@end

@implementation buyListViewController

-(void)viewWillAppear:(BOOL)animated{
    
      [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"line_nav"] forBarMetrics:UIBarMetricsDefault ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"key66", nil);
    [self buyListData];
    
    [self.view addSubview:self.table];
    self.table.delegate = self;
    self.table.dataSource = self;
}

-(NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

-(UITableView *)table{
    if (_table == nil) {
        _table = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    }
    return _table;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [self.listArray[indexPath.row]  goods_name];
    cell.detailTextLabel.text = [self.listArray[indexPath.row]  order_amount];
    return cell;
}

-(void)buyListData{
    
    NSString *str = [rootUrl stringByAppendingString:buyListUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"uuid":[UUID getUUID]};
    
    [manager POST:str parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess decode:str key:keyDES];
        NSDictionary *dic = [str jsonDictionary];
        NSLog(@"----%@",dic);
        if ([dic[@"error_code"] integerValue] == 0) {
            for (NSDictionary *dict in dic[@"data"]) {
                packageModel *model = [[packageModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                
                [self.listArray addObject:model];
            }
        }
        [self.table reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}

@end
