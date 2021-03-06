//
//  WongoHttpMacros.h
//  Wongo
//
//  Created by rexsu on 2017/3/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#ifndef WongoHttpMacros_h
#define WongoHttpMacros_h
//外网
#define HttpHead(url)         [NSString stringWithFormat:@"http://119.23.32.206:8080/change/%@",(url)]
//内网
//#define HttpHead(url)           [NSString stringWithFormat:@"http://192.168.1.119:8080/change/%@",(url)]

/**
 *  登录url
 */
/**账户登录*/
#define LoginRequestUrl         HttpHead(@"userLogin")
/**第三方登录 sid, uname ,password, url */
#define UseraddsUrl             HttpHead(@"useradds")

/**注册*/
#define UseraddUrl              HttpHead(@"useradd")
/**发送验证码*/
#define SendUrl                 HttpHead(@"send")

/**修改用户头像*/
#define UpdataUserHeaderImage   HttpHead(@"saveImage")
/**修改用户信息*/
#define UpdateUserUrl           HttpHead(@"updateUser")


/**发布上传数据url*/
#define PushExchangeUrl         HttpHead(@"addGood")
/**商品类型url*/
#define CommodityTypeUrl        HttpHead(@"queryGoodClass")
/**精选-交换-数据请求*/
#define ExchangeHomePageUrl     HttpHead(@"queryGoods")
/**我的商品查询*/
#define MyGoodsUrl              HttpHead(@"queryUserGoods")
/**获取Token*/
#define GetTokenUrl             HttpHead(@"gettoken")
/**获取用户信息(聊天)*/
#define UserGetUrl              HttpHead(@"userget")
/**获取交换主题商品信息*/
#define ExchangeDetailGoodsUrl  HttpHead(@"getgood")
/**发布图片Url*/
#define PushImageUrl            HttpHead(@"upfile")
/**查询所有订单*/
#define QueryOrderList          HttpHead(@"queryOrderList")
/**查询指定订单*/
#define QueryOrder              HttpHead(@"queryOrder")
/**删除我的商品*/
#define DeleteMyGoods           HttpHead(@"delgood")
/**主页新品数据*/
#define QueryGoodsListNew       HttpHead(@"queryGoodsListNew")
/**主页交换数据*/
#define QueryGoodsListFb        HttpHead(@"queryGoodsListFb")
/**主页热卖数据*/
#define QueryGoodsListRm        HttpHead(@"queryGoodsListRm")
/**添加地址*/
#define AddAddressedUrl         HttpHead(@"addAddressed")
/**查询地址*/
#define QueryAddressedUrl       HttpHead(@"queryAddressed")
/**修改地址*/
#define UpdateAddressedUrl      HttpHead(@"updateAddressed")
/**删除地址*/
#define DeleteAddressedUrl      HttpHead(@"deleteAddressed")
/**修改默认地址*/
#define UpdAddressedStateUrl    HttpHead(@"updAddressedState")


/**
 *  生成订单
 */
/**生成交换订单*/
#define GenerateOrderUrl        HttpHead(@"addOrders")
/**生成造梦报名订单*/
#define SignupAddUrl            HttpHead(@"SignupAdd")
/**生成提现订单    uid*/
#define userMoneyOrderUrl       HttpHead(@"userMoneyOrder")
/**生成寄卖订单*/
#define LogisticsIssueOrdernumAdd   HttpHead(@"logisticsIssueOrdernumAdd")


/**
 *  搜索
 */
/**搜索商品(用户名关键字)*/
#define QueryGoodsGname         HttpHead(@"queryGoodsGname")
/**搜索用户信息*/
#define UserQueryNameUrl        HttpHead(@"userQueryName")
/**搜索页-查询交换商品*/
#define GetClassGoodsUrl        HttpHead(@"getClassGoods")
/**搜索页-查询造梦商品*/
#define GetClassProductUrl      HttpHead(@"getClassProduct")


/**一级分类*/
#define QueryClassoneUrl        HttpHead(@"queryClassone")
/**同意时修改订单状态接口*/
#define UpdateOrderUrl          HttpHead(@"updateOrder")
/**添加订单的地址 */
#define UpdateOrderAddressUrl   HttpHead(@"updateOrderAddress")
/**确认收货时修改订单状态接口 */
#define ConfirmReceiptUrl      HttpHead(@"updateOrderState")
/**添加物流信息接口 */
#define UpdateOrderLogUrl      HttpHead(@"updateOrderLog")
/**获取首页轮播信息 */
#define GetHomeBannerUrl       HttpHead(@"getGoodsList")
/**申请平台介入 */
#define UpdateOrderFalse        HttpHead(@"updateOrderFalse")
/**查询首页分类 */
#define QtQueryType             HttpHead(@"qtQueryType")
/**查询某一分类下的物品 */
#define QtQueryTypegdlist       HttpHead(@"qtQueryTypegdlist")

/**
 *      分类
 */
/**点击二级分类时查询商品方法 */
#define QueryGoodById           HttpHead(@"queryGoodById")

/**
 *      交换详情
 */

/**时间排序(所有)*/
#define QueryGoodsListNew       HttpHead(@"queryGoodsListNew")
/**点赞排序(所有)*/
#define QueryGoodsListPraise    HttpHead(@"queryGoodsListPraise")

/**时间排序(分类)*/
#define QueryUserGoodsCtidDate  HttpHead(@"queryGoodDate")
/**点赞排序(分类)*/
#define QueryUserGoodCtid       HttpHead(@"queryGoodParise")

/**
 *  寄卖
 */
/**查询所有寄卖 currPage分页数*/
#define QueryShoppingListPraise HttpHead(@"queryLog")
/**查询指定的寄卖详情*/
#define LogisticsQueryLid       HttpHead(@"logisticsQueryLid")
/**发布寄卖*/
#define LogisticsUserAdd        HttpHead(@"logisticsUserAdd")
/**上传寄卖图片*/
#define Upfilelog               HttpHead(@"upfilelog")
/**我的寄卖 uid*/
#define LogisticsUserquery      HttpHead(@"logisticsUserquery")
/**查询寄卖页商品分类*/
#define QueryClassoneLog        HttpHead(@"queryClassoneLog")
/**查询分类下的所有寄卖商品 currPage分页数 gcid分类*/
#define LogisticsQueryClo       HttpHead(@"logisticsQueryClo")
/**寄出寄卖商品*/
#define LogisticsUserUpdate     HttpHead(@"logisticsUserUpdate")


/**
 *      造梦
 */
/**进行中造梦(主页造梦也用此方法)*/
#define QuerySubIng             HttpHead(@"querySubIng")
/**筹备中造梦*/
#define QuerySub                HttpHead(@"querySub")
/**查询所有造梦计划*/
#define QueryProduct            HttpHead(@"queryPlanById")
/**某个造梦计划的参与造梦*/
#define QueryProductById        HttpHead(@"queryProductById")
/**造梦计划主页展示数据URL*/
#define DreamingHomePageUrl     HttpHead(@"querySub")
/**发布(报名)造梦计划*/
#define AddProduct              HttpHead(@"addProduct")
/**指定主题内的造梦计划查询*/
#define QueryPlanRul            HttpHead(@"queryPlan")
/**发布造梦图片*/
#define UpProFileUrl            HttpHead(@"upProFile")
/**加入他人造梦*/
#define JoinProUrl              HttpHead(@"joinPro")
/**造梦计划详情查询*/
#define GetPlanUrl              HttpHead(@"queryPlanByIdOne")
/**造梦订单查询*/
#define QueryPlordersUrl        HttpHead(@"queryPlorders")
/**搜索造梦*/
#define QueryProductOneUrl      HttpHead(@"queryProductOne")
/**造梦发货 */
#define UpdatePlorderUrl        HttpHead(@"updatePlorder")
/**造梦确认收货 */
#define UpdatePlorderStateUrl   HttpHead(@"updatePlorderState")
/**查询用户商品故事*/
#define QueryPlanStory          HttpHead(@"queryPlanStory")
/**增加主题浏览量方法*/
#define Subreadview             HttpHead(@"subreadview")

/**
 *  个人中心(我的店铺)
 */
/**个人中心(我的店铺) uid*/
#define QureygoodUid            HttpHead(@"qureygoodUid")

/**
 *  支付
 */
/**造梦支付 ploid amount*/
#define AliPayProductUrl        HttpHead(@"aliPayProduct")
/**交换支付 oid  amount*/
#define AliPayUrl               HttpHead(@"aliPay")
/**押金支付 signupid amount*/
#define AliPaySignup            HttpHead(@"aliPaySignup")
/**寄卖支付 loid amount*/
#define AliPayLog               HttpHead(@"aliPayLog")


/**
 *  点赞
 */
/** 点赞*/
#define ThumUpAddUrl                HttpHead(@"IncensesAdd")
/**取消点赞*/
#define ThumUpCancelUrl             HttpHead(@"IncensesDel")
/**造梦点赞 uid ，proid*/
#define IncensesproductAdd          HttpHead(@"IncensesproductAdd")
/**造梦取消点赞 uid ，proid*/
#define IncensesproductDel          HttpHead(@"IncensesproductDel")
/**查询点赞商品 uid*/
#define IncensesUidSelect           HttpHead(@"IncensesUidSelect")
/**查询造梦点赞商品*/
#define IncensesUidSelectPrdouct    HttpHead(@"IncensesUidSelectPrdouct")
/**
 *  收藏
 */
/**添加收藏*/
#define CollectionAddUrl        HttpHead(@"CollectionAdd")
/**取消收藏*/
#define CollectionCancelUrl     HttpHead(@"delCollection")
/**查询收藏商品*/
#define QueryUserCollectionUrl  HttpHead(@"queryUserCollection")

/**
 *  评论
 */
/**添加交换评论*/
#define AddCommentUrl           HttpHead(@"addComment")
/**查询交换评论*/
#define QueryUserCommentUrl     HttpHead(@"queryUserComment")
/**添加造梦评论*/
#define CommentproductsUrl      HttpHead(@"CommentproductsAdd")
/**查询造梦评论*/
#define QueryUserCommentproduct HttpHead(@"queryUserCommentproduct")

/**
 *  关注
 */
/**添加关注*/
#define FollowFAddUrl           HttpHead(@"FollowFAdd")
/**取消关注  uidF:被关注用户 uid:当前登录用户 */
#define FollowFDelUrl           HttpHead(@"FollowFDel")
/**查询关注  uid*/
#define QueryUidFollowUrl       HttpHead(@"queryUidFollow")
/**查询用户粉丝*/
#define QueryUidFollowsUrl      HttpHead(@"queryUidFollows")

/**
 *  排行榜
 */
/**查询排行榜*/
#define Queryuserorder          HttpHead(@"queryuserorder")

/**
 *  推荐
 */
/**首页推荐*/
#define Queryboutique           HttpHead(@"queryboutique")
/**首页推荐(造梦计划)*/
#define Queryboutiqueproduct    HttpHead(@"queryboutiqueproduct")

/**
 *  邀请码
 */
/**输入邀请码  uid:当前用户id   activation邀请码id*/
#define SetUserActivationUrl    HttpHead(@"setUserActivation")

/**
 *  余额、提现
 */
/**提现 moneyid 订单ID ,amount 支付金*/
#define AliPayMoneyOrderUrl     HttpHead(@"aliPayMoneyOrder")
/**余额*/
#define AliPayMoneyOrderUrl     HttpHead(@"aliPayMoneyOrder")

#endif /* WongoHttpMacros_h */

