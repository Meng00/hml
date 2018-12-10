//
//  HMGlobal.h
//  hml
//
//  Created by 刘学 on 2018/9/15.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#ifndef HMGlobal_h
#define HMGlobal_h

//////************** 接口地址 **************/////
#define HM_API_SERVER_URL @"https://www.hanmolian.com/hml-web/"
#define HM_WEB_URL @"https://www.hanmolian.com/hml-web/"
//#define HM_API_SERVER_URL @"http://demo.4008988518.com/hml-web/"
//#define HM_WEB_URL @"http://demo.4008988518.com/hml-web/"
//#define HM_API_SERVER_URL @"http://192.168.1.167:8090/hml/"
//#define HM_WEB_URL @"http://192.168.1.167:8090/hml/"
//#define HM_API_SERVER_URL @"http://192.168.1.195:8090/hml/"
//#define HM_WEB_URL @"http://192.168.1.195:8090/hml/"

//#define HM_API_SERVER_URL @"http://192.168.10.211:8090/hml/"
//#define HM_WEB_URL @"http://192.168.10.211:8090/hml/"
#define HM_IMGSRV_PREFIX @"https://www.hanmolian.com/uploadfiles/upload"

#define HM_API_SendCode @"api/sms/code"
#define HM_API_Login @"api/app/login"
#define HM_API_ThirdP_Login @"api/app/thirdP/login"
#define HM_API_Binding @"api/binding.htm"

#define HM_API_Register @"api/app/register"
#define HM_API_UpdatePwd @"api/app/updatePassword"

#define HM_API_Adlist @"ad/list"
#define HM_API_Subchain @"api/subchain/list"

#define HM_API_Classify @"classify/list"
#define HM_API_ArtList @"api/art/list"


#define HM_API_FXText @"getSignInfo.htm"

#endif /* HMGlobal_h */

