//
//  ViewController.m
//  BLC
//
//  Created by yxf on 2018/1/11.
//  Copyright © 2018年 yxf. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>{
    CBCentralManager *_cm;
    CBPeripheral *_cp;
}

/*arr*/
@property (nonatomic,strong)NSMutableArray *pArray;

@end

@implementation ViewController

-(NSMutableArray *)pArray{
    if (!_pArray) {
        _pArray = [NSMutableArray array];
    }
    return _pArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.建立中心管家
    _cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
}

#pragma mark - CBCentralManagerDelegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBManagerStatePoweredOn) {
        //2.扫描外部设备
        NSLog(@"扫描外部设备");
        [_cm scanForPeripheralsWithServices:nil options:nil];
    }
}

//3.发现外部设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(nonnull CBPeripheral *)peripheral advertisementData:(nonnull NSDictionary<NSString *,id> *)advertisementData RSSI:(nonnull NSNumber *)RSSI{
    NSLog(@"发现外部设备:%@",peripheral);
    
    //在这里展示peripheral.name
    //用户可以根据peripheral.name进行连接
    if (peripheral.state == CBPeripheralStateDisconnected) {
        [self.pArray addObject:peripheral];
        _cp = peripheral;
        _cp.delegate = self;
        [_cm connectPeripheral:_cp options:nil];
    }
}

//4.连接外设成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"连接外设成功 : %@",peripheral);
    [peripheral discoverServices:nil];
    [central stopScan];
}

//连接服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"services:%@",peripheral.services);
}








@end
