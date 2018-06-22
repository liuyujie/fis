//
//  XCRIDFV.h
//  keychain+idfv
//
//  Created by aayongche on 16/2/25.
//  Copyright © 2016年 程磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCRIDFV : NSObject

+ (XCRIDFV *)shared;
/**
*  先从内存中获取idfv，如果没有再从钥匙串中获取，如果还没有就生成一个新的idfv，并保存到钥匙串中供以后使用
*
*  @return 设备唯一标识码
*/
- (id)readIDFV;
/**
 *  从Keychain中删除唯一设备吗
 */
- (void)deleteIDFV;

@end
