//
//  Define.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 4/3/23.
//

import Foundation

import UIKit

var window: UIWindow?

let TEXT_COLOR = UIColor(red: 66.0/255.0, green: 79.0/255.0, blue: 134.0/255.0, alpha: 1.0)
let collectionViewBgColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
let viewBorderColor = UIColor(red: 226.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 1.0)

let DEVICE_HEIGHT = UIScreen.main.bounds.size.height
let DEVICE_WIDTH = UIScreen.main.bounds.size.width

let IS_IPHONE_4 = UIScreen.main.bounds.size.height == 480.0
let IS_IPHONE_5 = UIScreen.main.bounds.size.height == 568.0
let IS_IPHONE_6 = UIScreen.main.bounds.size.height == 667.0
let IS_IPHONE_6S_PLUS = UIScreen.main.bounds.size.height == 736.0
let IS_IPHONE_X = DEVICE_HEIGHT == 812.0
let IS_IPHONE_XMAX = DEVICE_HEIGHT == 896.0 && DEVICE_WIDTH == 414.0
let IS_IPHONE_12_PRO_MAX = DEVICE_HEIGHT == 926.0 && DEVICE_WIDTH == 428.0
let IS_IPHONE_12_PRO = DEVICE_HEIGHT == 844.0 && DEVICE_WIDTH == 390.0
let IS_IPHONE_XR = DEVICE_HEIGHT == 896.0 && DEVICE_WIDTH == 414.0
let IS_IPHONE_XS = DEVICE_HEIGHT == 812.0 && DEVICE_WIDTH == 375.0

let IS_IPHONE_XSMAX_DEVICE = UIScreen.main.nativeBounds.size.height == 2688
let IS_IPHONE_XR_DEVICE = UIScreen.main.nativeBounds.size.height == 1792
let IS_IPHONE_X_XS_DEVICE = UIScreen.main.nativeBounds.size.height == 2436
let IS_IPHONE_6S_DEVICE = (UIScreen.main.nativeBounds.size.height == 1920) || (UIScreen.main.nativeBounds.size.height == 2208)
let IS_IPHONE_6_DEVICE = UIScreen.main.nativeBounds.size.height == 1334
let IS_IPHONE_5_DEVICE = UIScreen.main.nativeBounds.size.height == 1136

let IS_SMALL_PHONE = (IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6S_PLUS)
let IS_NOTCH_PHONE = (IS_IPHONE_X || IS_IPHONE_XMAX || IS_IPHONE_12_PRO_MAX || IS_IPHONE_12_PRO)
let IS_IPHONE_X_SERIES = IS_IPHONE_X || IS_IPHONE_XMAX || IS_IPHONE_XR || IS_IPHONE_XS || IS_IPHONE_12_PRO_MAX || IS_IPHONE_12_PRO


//---------Ipad ------//

let IS_DEVICE_IPAD = UIDevice.current.responds(to: #selector(getter: UIDevice.userInterfaceIdiom)) && UIDevice.current.userInterfaceIdiom == .pad

let IS_IPAD_PRO_1366 = IS_DEVICE_IPAD && DEVICE_HEIGHT == 1366.0
let IS_IPAD_PRO_1024 = IS_DEVICE_IPAD && DEVICE_HEIGHT == 1024.0
let IS_IPAD_PRO_1194 = IS_DEVICE_IPAD && DEVICE_HEIGHT == 1194.0
let IS_IPAD_PRO_1112 = IS_DEVICE_IPAD && DEVICE_HEIGHT == 1112.0
let IS_IPAD = (IS_IPAD_PRO_1366 || IS_IPAD_PRO_1024 || IS_IPAD_PRO_1194 || IS_IPAD_PRO_1112)

///directory
let APP_ROOT_DIR = "Directory_SCANNER"
let APP_CACHE_DIR = "Cache_SCANNER"
let APP_ORIGINAL_DIR = "ORIGINAL_SCANNER"

let APP_ID = "id1546433378"

//let IS_DEFAULT_ALBUM_CREATED ""
enum UserDefaults_TAG: String, CaseIterable {
    case iS_default_album_created = "IS_DEFAULT_ALBUM_CREATED";
}
let placeHolderColor = UIColor(red: (190.0/255.0), green: (189.0/255.0), blue: (191.0/255.0), alpha: 1.0)

let DELEGATE = UIApplication.shared.delegate as! AppDelegate

func loadVCfromStoryBoard(name: String, identifier: String) -> UIViewController {
    
    if #available(iOS 13.0, *) {
        return UIStoryboard(name: name, bundle: nil).instantiateViewController(identifier: identifier)
    } else {
        return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}

func deviceHeight() -> CGFloat {
    return UIScreen.main.bounds.size.height
}

func deviceWidth() -> CGFloat {
    return UIScreen.main.bounds.size.width
}

