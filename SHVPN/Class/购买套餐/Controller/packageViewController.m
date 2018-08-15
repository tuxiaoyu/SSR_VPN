//
//  packageViewController.m
//  SHVPN
//
//  Created by Tommy on 2017/12/15.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "packageViewController.h"
#import "packageItemTableViewCell.h"
#import "packageView.h"
#import <StoreKit/StoreKit.h>
#import "packageModel.h"
#import "telAndPsdViewController.h"
#import "protocolViewController.h"
#import "tipsView.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface packageViewController ()<UITableViewDelegate,UITableViewDataSource,SKPaymentTransactionObserver,SKProductsRequestDelegate,tipsdelegate>

@property(nonatomic,strong)UIView *centerView;

@property(nonatomic,strong)UITableView *table;

//产品上架的id
@property(nonatomic,copy)NSString *productID;
//套餐细信息
@property(nonatomic,strong)NSMutableArray *infoArray;

//续费说明
@property(nonatomic,strong)UILabel *introLabel;

@property(nonatomic,strong)UIScrollView *scroller;


@end

@implementation packageViewController


+(instancetype)sharePay{
    
    static  dispatch_once_t onceToken;
    static packageViewController  *_package;
    
    dispatch_once(&onceToken, ^{
        if (_package == nil) {
            _package = [[super alloc]init];
        }
    });
    
    return  _package;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault ];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    if (self.presentingViewController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back2)];
    }
    
}

-(void)back2{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UILabel *)introLabel{
    if (_introLabel == nil) {
        _introLabel = [[UILabel alloc]init];
    }
    
    return _introLabel;
}

-(NSMutableArray *)infoArray{
    if (_infoArray ==nil) {
        _infoArray = [NSMutableArray array];
    }
    return _infoArray;
}

-(UITableView *)table{
    if (_table == nil) {
        _table = [[UITableView alloc]init];
    }
    
    return _table;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self getPackageInfo];
    self.view.backgroundColor = colorRGB(241, 241, 241);

    self.navigationItem.title = NSLocalizedString(@"key19", nil);

    [self creatHeaderView];

    [self itemView];

    [self footView];

}




-(void)creatHeaderView{
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"rec_Backgroud"];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.leading.equalTo(@(0));
        make.trailing.equalTo(@(0));
        make.height.equalTo(@(200 * KHeight_Scale));
    }];
}

//itemView
-(void)itemView{

 
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    self.centerView = bgView;
    [self.view addSubview:bgView];
    
    [self.view bringSubviewToFront:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(@(10 * KHeight_Scale + 64 * KHeight_Scale));
        make.left.equalTo(@(10 * KWidth_Scale));
        make.right.equalTo(@(-10 * KWidth_Scale));
        make.height.equalTo(@((kHeight/2) - 64));
    }];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 10;
    
    [self.view layoutIfNeeded];
    
    
    self.table = [[UITableView alloc]init];
    self.table.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:self.table];
    self.table.bounces = NO;
    self.table.showsVerticalScrollIndicator = NO;
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.table registerNib:[UINib nibWithNibName:@"packageItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"package"];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(5 * KHeight_Scale));
        make.left.equalTo(self.view.mas_left).with.offset(10 * KWidth_Scale);
        make.right.equalTo(self.view.mas_right).with.offset(-10 * KWidth_Scale);
        make.bottom.equalTo(@(-5 * KHeight_Scale));
    }];
    
   
        self.scroller = [[UIScrollView alloc]init];
        [self.view addSubview:self.scroller];
        self.scroller.scrollEnabled = YES;
        [self.scroller mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_bottom).with.offset(0 * KHeight_Scale);
            make.left.mas_equalTo(@(0 * KWidth_Scale));
            make.right.mas_equalTo(@(-0 * KWidth_Scale));
            //        make.height.equalTo(@(10000));
            make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-10 * KHeight_Scale);
        }];
    
    

        //续费说明
        self.introLabel = [[UILabel alloc]init];
        self.introLabel.backgroundColor = [UIColor redColor];
        [self.scroller addSubview:self.introLabel];
        self.introLabel.numberOfLines = 0;
        [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scroller.mas_top).with.offset(20 * KHeight_Scale);
            make.left.equalTo(self.scroller.mas_left).with.offset(20 * KWidth_Scale);
            make.width.equalTo(@(kWidth - 40 * KWidth_Scale));
        }];
        self.introLabel.backgroundColor = [UIColor whiteColor];
        self.introLabel.font = [UIFont systemFontOfSize:12];
        self.introLabel.textColor = colorRGB(100, 100, 100);
        self.introLabel.text = [NSString stringWithFormat:NSLocalizedString(@"key94", @"续期订阅协议")];

        //会员服务协议    自动续费协议
        UIButton *btn  = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor cyanColor];
        btn.userInteractionEnabled = YES;
        [btn  setTitle:NSLocalizedString(@"key96", @"会员服务协议") forState:UIControlStateNormal];
        [self.scroller addSubview:btn];
        [btn addTarget:self action:@selector(protocolAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100001;
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.introLabel.mas_bottom).with.offset(0);
            make.left.equalTo(self.introLabel.mas_left).with.offset(0);
            make.height.equalTo(@(40 * KHeight_Scale));

        }];


        UIButton *btn1  = [[UIButton alloc]init];
        btn1.backgroundColor = [UIColor redColor];
        btn1.userInteractionEnabled = YES;
        btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn1  setTitle:NSLocalizedString(@"key97", @"自动续费协议") forState:UIControlStateNormal];
        btn1.backgroundColor = [UIColor whiteColor];
        [btn1  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.scroller addSubview:btn1];
        btn1.tag = 100002;
        [btn1 addTarget:self action:@selector(protocolAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn1  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.introLabel.mas_bottom).with.offset(0);
            make.left.equalTo(btn.mas_right).with.offset(0);
            make.width.equalTo(btn.mas_width);
            make.right.equalTo(self.introLabel.mas_right).with.offset(0);
            make.height.equalTo(btn.mas_height);
        }];
    

    
    UILabel *label = [[UILabel alloc]init];
    [self.scroller addSubview:label];
    label.backgroundColor = colorRGB(241, 241, 241);
    label.text = @"VIP享有的特权";
    if (self.isShowProtocal == 1) {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom).with.offset(20 * KHeight_Scale);
            make.left.equalTo(self.scroller.mas_left).with.offset(10 * KWidth_Scale);
        }];
    }else{
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scroller.mas_top).with.offset(20 * KHeight_Scale);
            make.left.equalTo(self.scroller.mas_left).with.offset(10 * KWidth_Scale);
        }];
        
        self.introLabel.hidden = YES;
        btn1.hidden = YES;
        btn.hidden = YES;
    }
    
    

    UIView  *vipView  = [[UIView alloc]init];

    [self.scroller addSubview:vipView];
    [vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).with.offset(10 * KHeight_Scale);
        make.left.equalTo(self.scroller.mas_left).with.offset(10 * KWidth_Scale);
        make.height.equalTo(@(250 * KHeight_Scale));
        make.bottom.equalTo(self.scroller.mas_bottom).mas_offset(0);
    }];
    
    
    NSArray *titleArray = @[NSLocalizedString(@"key20", nil),NSLocalizedString(@"key21", nil),NSLocalizedString(@"key22", nil),NSLocalizedString(@"key23", nil),NSLocalizedString(@"key24", nil),NSLocalizedString(@"key25", nil)];
    CGFloat width = (self.view.frame.size.width - 20 * KWidth_Scale)/3;
    CGFloat height = 250 * KHeight_Scale/2 ;

    for (int i = 0; i < 6; i++) {
        packageView *pv = [[packageView alloc]init];
        pv.backgroundColor = [UIColor whiteColor];
        if (i < 3) {
            pv.frame = CGRectMake(i * width, 0, width, height);
        }else{
            pv.frame = CGRectMake((i - 3) * width, height, width, height);
        }

        pv.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"item_%d",i]];
        pv.titleLabel.text = titleArray[i];
        
        [vipView  addSubview:pv];
    }
  
}


-(void)footView{

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]init];
    [v addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15 * KWidth_Scale));
        make.right.equalTo(@(-15 * KWidth_Scale));
        make.top.equalTo(@(10 * KHeight_Scale));
        make.bottom.equalTo(@(-10 * KHeight_Scale));
    }];
    label.font = [UIFont systemFontOfSize:15];
    label.text = NSLocalizedString(@"key26", nil);
    
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40 * KHeight_Scale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55 * KHeight_Scale;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    packageItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"package" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger num = indexPath.row % 4 ;
    cell.model = self.infoArray[indexPath.row];
    cell.bgImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%ld", num + 1]];
    return cell;
}

#pragma mark获取套餐信息
-(void)getPackageInfo{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
 
    NSDictionary *parameters = @{@"bundle_id":[[NSBundle mainBundle]bundleIdentifier]};
     NSString *str = [rootUrl stringByAppendingString:goodsListUrl];
    [manager POST:str parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [JoDess decode:string key:keyDES];
        NSDictionary *dict = [jsonStr jsonDictionary];
        if ([dict[@"error_code"] integerValue] == 0) {
            
            NSArray *arr = dict[@"data"][@"items_list"];
            NSLog(@"商品：%@",arr);
            for (NSDictionary *dic in arr) {
                packageModel *model = [[packageModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.infoArray addObject:model];
            }
        }
        [self.table reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
    }];
}


//内购
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//
//    //产品上架的id
    packageModel *model = self.infoArray[indexPath.row];
    
    //获取IP
    NSString *IP = [self deviceWANIPAddress];

    NSString *subIP = [IP substringFromIndex:3];

    if (self.payTypeInt == 1 && ![subIP isEqualToString:@"17."]) {
        
//      [self thirdPayWithProductModel:model];
        
    }else{
        //    //添加交易的观察者
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        self.productID = model.goods_id;
        
        if ([SKPaymentQueue canMakePayments]) {
            
            [self requestProductData:self.productID];
            
        }else{
            
            [SVProgressHUD showWithStatus:NSLocalizedString(@"key27", nil)];
            NSLog(@"不能支付");
        }
    }
}

#pragma Mark 第三方支付
-(void)thirdPayWithProductModel:(packageModel *)model{
    
//    [[GameManager sharedManager] PayProductName:model.goods_name Money:model.goods_price Uuid:[UUID getUUID] Goods_id:model.goods_id Result:^(int code, NSString *reason) {
        //        *  0 支付失败
        //        *  1 支付成功
        //        *  2 用户取消
        //        *  3 结果不明
        //        *  4 验证未通过
//        NSLog(@"code = %d message = %@",code,reason);
//    }];
}

//从苹果服务器请求产品的信息
-(void)requestProductData:(NSString *)productID{
    
    [SVProgressHUD show];
    NSArray *pruductArr = [[NSArray alloc]initWithObjects:productID, nil];
    NSSet *productSet = [NSSet setWithArray:pruductArr];
    SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:productSet];
    request.delegate = self;
    [request start];
}

//收到的产品返回信息
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *productArr = response.products;
    if (productArr.count == 0) {
        [SVProgressHUD dismiss];
        
        [keyWindow makeToast:NSLocalizedString(@"key28", nil) duration:tipsSeecond position:@"center"];
        NSLog(@"没有该商品");
        return ;
    }
    
    SKProduct *p = nil;
    //SKProduct 产品模型
    for (SKProduct *pro in productArr) {
       
        if ([pro.productIdentifier isEqualToString:self.productID]) {
            p = pro;
        }
    }
 
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    //发送内购请求
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

//SKRequest代理
-(void)requestDidFinish:(SKRequest *)request{
    
    [SVProgressHUD dismiss];
    
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"key29", nil)];
}

//监听购买结果
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *tra in transactions) {

        NSString *temptransactionReceipt  = [[NSString alloc] initWithData:tra.transactionReceipt encoding:NSUTF8StringEncoding];
        
        NSString *base64 = [JoDess  encodeBase64WithString:temptransactionReceipt  ];
        switch (tra.transactionState) {
                //交易完成
            case SKPaymentTransactionStatePurchased:
                //向自己的服务器验证订单信息
                [self completeTransaction:base64 payModel:tra];
                
                [[SKPaymentQueue defaultQueue]finishTransaction:tra];
               
                break;
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                
                break;
            case SKPaymentTransactionStateRestored: //购买过
                // 发送到苹果服务器验证凭证
                [[SKPaymentQueue defaultQueue]finishTransaction:tra];
                break;
            case SKPaymentTransactionStateFailed: //交易失败
                
                [[SKPaymentQueue defaultQueue]finishTransaction:tra];
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"key30", nil)];
                break;
                
            default:
                break;
        }
    }
}

//验证购买(自己服务器)
- (void)completeTransaction:(NSString *)baseString  payModel:(SKPaymentTransaction *)transaction{

    [keyWindow  makeToastActivity];
    NSString *uuID = [UUID getUUID];
    NSString *bundleId = [[NSBundle mainBundle]bundleIdentifier];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:baseString forKey:@"receipt"];
    [dic setValue:self.productID forKey:@"goods_id"];
    [dic setValue:uuID forKey:@"uuid"];
    [dic setValue:bundleId forKey:@"bundle_id"];
    NSString *str = [rootUrl stringByAppendingString:userPayUrl];
 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

  
    [manager POST:str parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [JoDess decode:string key:keyDES];
        NSDictionary *dict = [jsonStr jsonDictionary];
        NSLog(@"购买：%@",dict);
        if ([dict[@"error_code"]  integerValue] == 0) {
         if ([dict[@"data"][@"order_state"]  integerValue] == 1 ) {
                
            
            [keyWindow makeToast:NSLocalizedString(@"key53", nil) duration:1.0 position:@"center"];
            
            [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
            
            [self.buyDelegate   UIRefreshWithToken:dict[@"data"][@"token"]];
            
            if ([dict[@"data"][@"token"] length] > 0) {
                
                [KeyChainStore save:KEY_USERNAME_TOKEN data:dict[@"data"][@"token"]];
            }
            
            if (!self.model || !self.model.phone) {
                
                [self alertTips];
            }else{
                
                [self.navigationController  popViewControllerAnimated:YES];
            }
            
            }
        }else{
            
            [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
            [keyWindow hideToastActivity];
            [keyWindow makeToast:NSLocalizedString(@"key54", nil) duration:1.0 position:@"center"];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          [keyWindow hideToastActivity];
         [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    }];
}

-(void)alertTips{
    
    tipsView *tip = [[[NSBundle mainBundle] loadNibNamed:@"tipsView" owner:nil options:nil] firstObject];
    tip.layer.masksToBounds = YES;
    tip.layer.cornerRadius = 4;
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPad"]) {
        tip.frame = CGRectMake(40 * KWidth_Scale, (kHeight/2) - (200 * KHeight_Scale), kWidth - 80 * KWidth_Scale, 400);
    }else{
        tip.frame = CGRectMake(40 * KWidth_Scale, (kHeight/2) - (200 * KHeight_Scale), kWidth - 80 * KWidth_Scale, 380 * KHeight_Scale);
    }

    tip.delegate = self;
    [self.view addSubview:tip];
    
    
    
}

-(void)bindTelorEmail{
    
     telAndPsdViewController *bind = [[telAndPsdViewController alloc]init];
    [self.navigationController pushViewController:bind animated:YES];
    
}

-(void)verifyPurchaseWithPaymentTrasaction{
   
    //获取购买的凭证
    NSURL *receptURL =  [[NSBundle mainBundle] appStoreReceiptURL];
    //从沙盒中获取购买凭据
    NSData *receptData = [NSData dataWithContentsOfURL:receptURL];
    
    NSString *baseString = [receptData base64EncodedStringWithOptions:0];
    
    NSDictionary *dic = @{@"receipt-data":baseString};
    // 获取网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求格式为json
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/plain", nil];
    // 发出请求
    [manager POST:packageURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject = %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
        
    }];

    
}

//交易完成

-(void)dealloc{
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
}




//续期订阅
-(void)getSubscribeTime{
    //获取购买的凭证
    NSURL *receptURL =  [[NSBundle mainBundle] appStoreReceiptURL];
    //从沙盒中获取购买凭据
    NSData *receptData = [NSData dataWithContentsOfURL:receptURL];
    
    NSString *baseString = [receptData base64EncodedStringWithOptions:0];
    if (baseString.length > 0) {
             //到期 向后台请求新的时间
                [self getNewTime:baseString];
        
    }
 

}



//到期 查看是否续期
-(void)getNewTime:(NSString *)string{
    
       NSString *str = [rootUrl stringByAppendingString:getNewTimeUrl];
        NSDictionary *dic = @{@"receipt":string,@"uuid":[UUID getUUID]};
        // 获取网络管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 设置请求格式为json
    
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
        // 发出请求
        [manager POST:str parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *jsonStr = [JoDess decode:string key:keyDES];
            NSDictionary *dict = [jsonStr jsonDictionary];
            if ([dict[@"data"] integerValue] == 1) {
                [self.buyDelegate   UIRefreshWithToken:[UUID getToken]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"error = %@", error);
            
        }];
   
    
    
}
-(NSString *)getcurrentTime{
    
    NSDate *date = [NSDate  dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval time = [date timeIntervalSince1970];
    
    NSString *string = [NSString stringWithFormat:@"%.f",time];
    
    return string;
}

-(void)protocolAction:(UIButton *)sender{
    
    if (sender.tag == 100001) {
        //会员服务协议
        protocolViewController *pro = [[protocolViewController alloc]init];
        pro.urltring = self.service;
        [self.navigationController pushViewController:pro animated:YES];
    }
    if (sender.tag == 100002) {
        //自动续费协议
        protocolViewController *pro = [[protocolViewController alloc]init];
        pro.urltring = self.protocol;
        [self.navigationController pushViewController:pro animated:YES];
    }
}


//获取用户的ip地址
//必须在有网的情况下才能获取手机的IP地址
-(NSString *)deviceWANIPAddress
{
    NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
    NSData *data = [NSData dataWithContentsOfURL:ipURL];
    NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]; 
    NSString *ipStr = nil;
    if (ipDic && [ipDic[@"code"] integerValue] == 0) { //获取成功
        ipStr = ipDic[@"data"][@"ip"];
    }
    return (ipStr ? ipStr : @"");
}
@end
