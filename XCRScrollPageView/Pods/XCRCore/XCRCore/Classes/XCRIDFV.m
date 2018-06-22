//
//  XCRIDFV.m
//  keychain+IDFV
//
//  Created by aayongche on 16/2/25.
//  Copyright © 2016年 程磊. All rights reserved.
//

#import "XCRIDFV.h"
#import <UIKit/UIKit.h>
//导入Keychain依赖库
#import <Security/Security.h>
#import "XCRKeychain.h"
#define KEY_IN_KEYCHAIN     @"com.xcar.analytics"

@interface XCRIDFV ()

@property (nonatomic, strong) NSString *idfv;

@end

static XCRIDFV *sharedInstance = nil;

@implementation XCRIDFV

+ (XCRIDFV *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] init];
    });
    return sharedInstance;
}

#pragma mark -获取IDFV
#pragma mark 保存IDFV到钥匙串

- (void)saveIDFV:(NSString *)IDFV {
    //[self save:KEY_IN_KEYCHAIN data:IDFV];
    [XCRKeychain setPassword:IDFV forService:@"com.xcar.analytics" account:@"com.xcar"];
}

/**

 *此IDFV在相同的一个程序里面-相同的vindor-相同的设备下是不会改变的

 *此IDFV是唯一的，但应用删除再重新安装后会变化，采取的措施是：只获取一次保存在钥匙串中，之后就从钥匙串中获取

 **/

- (NSString *)getIDFV {
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return identifierForVendor;
}

#pragma mark 读取IDFV

/**

 *先从内存中获取IDFV，如果没有再从钥匙串中获取，如果还没有就生成一个新的IDFV，并保存到钥匙串中供以后使用

 **/
- (id)readIDFV {
    if (_idfv == nil || _idfv.length == 0) {
        NSString *idfvstr = [XCRKeychain passwordForService:@"com.xcar.analytics" account:@"com.xcar"];
        if (idfvstr == nil || idfvstr.length == 0) {
            idfvstr = [[UIDevice currentDevice].identifierForVendor UUIDString];
            [self saveIDFV:idfvstr];
        }
        _idfv = idfvstr;
    }
    return _idfv;
}

#pragma mark 删除IDFV

- (void)deleteIDFV {
    [XCRKeychain deletePasswordForService:@"com.xcar.analytics" account:@"com.xcar"];
    //[self delete:KEY_IN_KEYCHAIN];
}

@end
