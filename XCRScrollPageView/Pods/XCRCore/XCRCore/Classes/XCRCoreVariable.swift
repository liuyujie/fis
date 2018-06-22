//
//  XCRGlobalVariable.swift
//  XCar
//
//  Created by XuJunquan on 16/6/12.
//  Copyright © 2016年 塞纳德（北京）信息技术有限公司. All rights reserved.
//

//iphone硬件型号
public let iPhone4 = (CGSize(width: 640, height: 960).equalTo(UIScreen.main.currentMode!.size))
public let iPhone5 = (CGSize(width: 640, height: 1136).equalTo(UIScreen.main.currentMode!.size))
public let iPhone6 = (CGSize(width: 750, height: 1334).equalTo(UIScreen.main.currentMode!.size))
public let iPhone6P = (CGSize(width: 1242, height: 2208).equalTo(UIScreen.main.currentMode!.size))
public let iPhoneX = (CGSize(width: 1125, height: 2436).equalTo(UIScreen.main.currentMode!.size))

// 沙盒文档路径
public let kSandDocumentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
