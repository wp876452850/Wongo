//
//  WongoHttpMacros.h
//  Wongo
//
//  Created by rexsu on 2017/3/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#ifndef WongoHttpMacros_h
#define WongoHttpMacros_h

/**登录url*/
#define LoginRequestUrl         @"http://119.23.32.206:8080/change/userLogin"
/**发布上传数据url*/
#define PushExchangeUrl         @"http://119.23.32.206:8080/change/addGood"
/**商品类型url*/
#define CommodityTypeUrl        @"http://119.23.32.206:8080/change/queryGoodClass"
/**精选-交换-数据请求*/
#define ExchangeHomePageUrl     @"http://119.23.32.206:8080/change/queryGoods"
/**我的商品查询*/
#define MyGoodsUrl              @"http://119.23.32.206:8080/change/queryUserGoods"
/**获取Token*/
#define GetTokenUrl             @"http://119.23.32.206:8080/change/gettoken"
/**获取用户信息(聊天)*/
#define UserGetUrl              @"http://119.23.32.206:8080/change/userget"
/**获取交换主题商品信息*/
#define ExchangeDetailGoodsUrl  @"http://119.23.32.206:8080/change/getgood"
/**发布图片Url*/
#define PushImageUrl            @"http://119.23.32.206:8080/change/upfile"
/**生成交换订单*/
#define GenerateOrderUrl        @"http://119.23.32.206:8080/change/addOrders"
/**查询所有订单*/
#define QueryOrderList          @"http://119.23.32.206:8080/change/queryOrderList"
/**查询指定订单*/
#define QueryOrder              @"http://119.23.32.206:8080/change/queryOrder"
/**删除我的商品*/
#define DeleteMyGoods           @"http://119.23.32.206:8080/change/delgood"
/**主页新品数据*/
#define QueryGoodsListNew       @"http://119.23.32.206:8080/change/queryGoodsListNew"
/**主页交换数据*/
#define QueryGoodsListFb        @"http://119.23.32.206:8080/change/queryGoodsListFb"
/**主页热卖数据*/
#define QueryGoodsListRm        @"http://119.23.32.206:8080/change/queryGoodsListRm"
/**添加地址*/
#define AddAddressedUrl         @"http://119.23.32.206:8080/change/addAddressed"
/**查询地址*/
#define QueryAddressedUrl       @"http://119.23.32.206:8080/change/queryAddressed"
/**修改地址*/
#define UpdateAddressedUrl      @"http://119.23.32.206:8080/change/updateAddressed"
/**删除地址*/
#define DeleteAddressedUrl      @"http://119.23.32.206:8080/change/deleteAddressed"
/**修改默认地址*/
#define UpdAddressedStateUrl    @"http://119.23.32.206:8080/change/updAddressedState"
/**添加收藏*/
#define UpdgdfreightAddUrl      @"http://119.23.32.206:8080/change/updgdfreightAdd"
/**取消收藏*/
#define UpdgdfreightUrl         @"http://119.23.32.206:8080/change/updgdfreight"
/**修改用户头像*/
#define UpdataUserHeaderImage   @"http://119.23.32.206:8080/change/saveImage"
/**注册*/
#define UseraddUrl              @"http://119.23.32.206:8080/change/useradd"
/**修改用户信息*/
#define UpdateUserUrl           @"http://119.23.32.206:8080/change/updateUser"
/**造梦计划主页展示数据URL*/
#define DreamingHomePageUrl     @""
/**精选-造梦计划*/
#define QuerySubUrl             @"http://119.23.32.206:8080/change/querySub"
/**发布(报名)造梦计划*/
#define AddProduct              @"http://119.23.32.206:8080/change/addProduct"
/**发布造梦图片*/
#define UpProFileUrl            @"http://119.23.32.206:8080/change/upProFile"
/**加入他人造梦*/
#define JoinProUrl              @"http://119.23.32.206:8080/change/joinPro"
/**指定主题内的造梦计划查询*/
#define QueryPlanRul            @"http://119.23.32.206:8080/change/queryPlan"
/**造梦计划详情查询*/
#define GetPlanUrl              @"http://119.23.32.206:8080/change/getPlan"
/**造梦订单查询*/
#define QueryPlordersUrl        @"http://119.23.32.206:8080/change/queryPlorders"
/**搜索用户*/
#define UserQueryNameUrl        @"http://119.23.32.206:8080/change/userQueryName"
/**搜索造梦*/
#define QueryProductOneUrl      @"http://119.23.32.206:8080/change/queryProductOne"
/**搜索页-查询交换商品*/
#define GetClassGoodsUrl        @"http://119.23.32.206:8080/change/getClassGoods"
/**搜索页-查询造梦商品*/
#define GetClassProductUrl      @"http://119.23.32.206:8080/change/getClassProduct"
/**一级分类*/
#define QueryClassoneUrl        @"http://119.23.32.206:8080/change/queryClassone"
/**同意时修改订单状态接口*/
#define UpdateOrderUrl          @"http://119.23.32.206:8080/change/updateOrder"
/**添加订单的地址 */
#define UpdateOrderAddressUrl   @"http://119.23.32.206:8080/change/updateOrderAddress"
/**确认收货时修改订单状态接口 */
#define  ConfirmReceiptUrl      @"http://119.23.32.206:8080/change/updateOrderState"
/**添加物流信息接口 */
#define  UpdateOrderLogUrl      @"http://119.23.32.206:8080/change/updateOrderLog"
/**获取首页轮播信息 */
#define  GetHomeBannerUrl       @"http://119.23.32.206:8080/change/getGoodsList"
/**获取活动物品列表 */
#define GetGoodClassList        @"http://119.23.32.206:8080/change/getGoodClassList"
/**申请平台介入 */
#define UpdateOrderFalse        @"http://119.23.32.206:8080/change/updateOrderFalse"
/**查询首页分类 */
#define QtQueryType             @"http://119.23.32.206:8080/change/qtQueryType"
/**查询某一分类下的物品 */
#define QtQueryTypegdlist       @"http://119.23.32.206:8080/change/qtQueryTypegdlist"
/**造梦支付 */
#define AliPayProductUrl        @"http://119.23.32.206:8080/change/aliPayProduct"
/**交换支付 */
#define AliPayUrl               @"http://119.23.32.206:8080/change/aliPay"
/**造梦发货 */
#define UpdatePlorderUrl        @"http://119.23.32.206:8080/change/updatePlorder"
/**造梦确认收货 */
#define UpdatePlorderStateUrl   @"http://119.23.32.206:8080/change/updatePlorderState"
/**点赞*/
#define UpdgdfreightAddUrl      @"http://119.23.32.206:8080/change/updgdfreightAdd"
/**取消点赞*/
#define UpdgdfreightUrl         @"http://119.23.32.206:8080/change/updgdfreight"


#endif /* WongoHttpMacros_h */
