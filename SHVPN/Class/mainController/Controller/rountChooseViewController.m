//
//  rountChooseViewController.m
//  SHVPN
//
//  Created by Tommy on 2017/12/15.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "rountChooseViewController.h"
#import "routeTableViewCell.h"
#import "listModel.h"
#import "routeModel.h"
#import "packageViewController.h"
#import "noDataView.h"

@interface rountChooseViewController ()<UITableViewDelegate,UITableViewDataSource,refreshDelegate>

@property(nonatomic,strong)UITableView *table;
//是否选中
@property(nonatomic,assign)NSInteger selectedSection;

@property(nonatomic,assign)NSInteger selectedRow;

@property(nonatomic,strong)routeModel *model;

@property(nonatomic,strong)noDataView *refreshUIView;

@property(nonatomic,strong)NSMutableArray *listArray;
@end

@implementation rountChooseViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"line_nav"] forBarMetrics:UIBarMetricsDefault ];
    
    if (self.presentingViewController) {
      self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back1)];
    }
}

-(void)back1{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UITableView *)table{
    if (_table == nil) {
        _table = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    }
    
    return _table;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = NSLocalizedString(@"key13", nil);
    
    NSString *section = [[NSUserDefaults standardUserDefaults]valueForKey:@"section"];
    NSString *row = [[NSUserDefaults standardUserDefaults]valueForKey:@"row"];
    if (section.length > 0 || row.length > 0 ) {
        
        self.selectedSection = section.integerValue;
        self.selectedRow = row.integerValue;
        
    }else{
        
        self.selectedSection = 1000000000000;
        self.selectedRow = 1000000000000;
    }
 
    self.view.backgroundColor = colorRGB(239, 239, 239);
    //获取线路列表数据
    [self getRounteList];
    
    if ([NetWorkReachability internetStatus] == NO) {
      //没网  显示背景图

        self.refreshUIView = [[noDataView alloc]initWithFrame:CGRectMake(0,150 * KHeight_Scale, kWidth, kHeight)];
        self.refreshUIView.delegate = self;
        [self.view addSubview:self.refreshUIView];
        
    }else{
        
         [self.view addSubview:self.table];
    }
    
    self.table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.bounces = NO;
    //cell注册
    [self.table registerNib:[UINib nibWithNibName:@"routeTableViewCell" bundle:nil] forCellReuseIdentifier:@"route"];
  

}

//没网络时显示的界面
-(void)refreshUI{
    if ([NetWorkReachability internetStatus]) {
        self.refreshUIView.hidden = YES;
        [self getRounteList];
        
        //服务器访问不通时
//        [self cookieData];
        [self.view addSubview:self.table];
    }
}

#pragma mark 缓存数据
-(void)cookieData{
    //    1.获取保存的数据
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
    
    if (data.length > 0) {
        
        //2.初始化解归档对象
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        //3.解归档
        self.listArray = [unarchiver decodeObjectForKey:@"listArray"];
        
        //4.完成解归档
        [unarchiver finishDecoding];
        
        [self.table reloadData];
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.listArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.listArray[section] count];
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45 * KHeight_Scale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 * KHeight_Scale;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    UIView *bg = [[UIView alloc]init];
    
    UILabel *label = [[UILabel alloc]init];
    
    [bg addSubview: label];
    
    label.backgroundColor = [UIColor whiteColor];
    
    label.textColor = colorRGB(152, 152, 152);
    if (section == 0) {
        label.text = NSLocalizedString(@"key14", nil);
    }
    if (section == 1) {
        label.text = NSLocalizedString(@"key15", nil);
    }

    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15 * KWidth_Scale));
        make.right.equalTo(@(-15 * KWidth_Scale));
        make.top.equalTo(@(5 * KHeight_Scale));
        make.bottom.equalTo(@(-5 *KHeight_Scale));
    }];
    
    return bg;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    routeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"route" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    listModel *model = self.listArray[indexPath.section][indexPath.row];


    if ( indexPath.section == self.selectedSection && indexPath.row == self.selectedRow) {
        cell.chooseImageView.hidden = NO;
    }else{
        cell.chooseImageView.hidden = YES;
    }
      cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.usermoder.user_type isEqualToString:@"free"] && indexPath.section == 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"key8", nil) message:NSLocalizedString(@"key16", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"key17", nil) style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"key18", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            packageViewController *pack = [[packageViewController alloc]init];
            pack.model = self.usermoder;
            [self.navigationController pushViewController:pack animated:YES];
        }];
        
        [alert addAction:action];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        self.selectedSection = indexPath.section;
        self.selectedRow = indexPath.row;
        [tableView reloadData];
        listModel *model = self.listArray[indexPath.section][indexPath.row];

        [self.Delegate chooseRouteInfo:model];
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld",indexPath.section] forKey:@"section"];
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld",indexPath.row] forKey:@"row"];
        
        
        NSDictionary *data = @{@"type":model.type,@"area_code":model.area_code,@"area_name":model.area_name};
        //today 中使用的数据
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"lineInfo"];
        NSUserDefaults *share = [[NSUserDefaults alloc]initWithSuiteName:todayShare];
        
        [share setObject:[data jsonString] forKey:@"routeInfo"];
        
        if (self.presentingViewController) {
            NSNotification *notification =[NSNotification notificationWithName:@"dataChangeNotification" object:nil userInfo:@{@"data":model}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}
#pragma mark 线路的接口数据

-(void)getRounteList{
    NSString *urlString = [rootUrl stringByAppendingString:routeListUrl];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer  serializer];
    
    manger.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
    
    __weak typeof(self) weakSelf = self;
    //临时存放数据的数组
    NSMutableArray *freeArray = [NSMutableArray array];
    NSMutableArray *vipArray = [NSMutableArray array];
    weakSelf.listArray = [NSMutableArray array];
    [manger POST:urlString parameters:@{@"show_where":appKind} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [JoDess decode:str key:keyDES];
        NSDictionary *dic = [str jsonDictionary];
        NSArray *dataArr = dic[@"data"];
        for (NSDictionary *dic in dataArr) {
            listModel *model = [[listModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            if ([model.type isEqualToString:@"free"]) {
                [freeArray addObject:model];
            }else{
                [vipArray addObject:model];
            }
        }
        [weakSelf.listArray addObject:freeArray];
        [weakSelf.listArray addObject:vipArray];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"data"];
#pragma mark  使用归档对数据进行本地保存
        NSMutableData *data = [NSMutableData data];
        //1.初始化
        NSKeyedArchiver *archivier = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        //2.归档
        [archivier encodeObject:weakSelf.listArray forKey:@"listArray"];
        //3.完成归档
        [archivier finishEncoding];
        //4.保存
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"data"];
        
        NSLog(@"线路：%@",dic);
        [weakSelf.table reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#pragma mark   数据缓存（断网取数据）
        [self cookieData];
        NSLog(@"失败%@",error);
    }];
    
}

-(NSArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
