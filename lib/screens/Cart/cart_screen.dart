import 'package:decorated_icon/decorated_icon.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gnon/constants/color_constans.dart';
import 'package:gnon/constants/themes.dart';
import 'package:gnon/models/order_data_model.dart';
import 'package:gnon/screens/Cart/address_bloc/address_bloc.dart';
import 'package:gnon/screens/Cart/ship_to_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:like_button/like_button.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../constants/widget.dart';
import '../../localization/localization_constants.dart';
import '../../models/cart_data_model.dart';
import '../../sharedPreferences.dart';
import '../auth/login/login_screen.dart';

class CartScreen extends StatefulWidget {
   CartScreen(this.mycontext,this.lang,this.phone,{Key? key}) : super(key: key);
  String? lang;
  var mycontext;
   String phone;
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  TextEditingController couponTextEditingController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => AddressCubit()..getCartData(widget.lang),
  child: BlocConsumer<AddressCubit, AddressState>(
  listener: (context, state) {
    // TODO: implement listener
  },
   builder: (context, state) {
    var cartDataModel = AddressCubit.get(context).cartDataModel;
    var cartModel = AddressCubit.get(context).cartModel;
    return
      AddressCubit.get(context).isLogin==true?
      Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: customText(

            getTranslated(context, "Your Cart",)!
            ,
            color: customTextColor, fontWeight: FontWeight.bold),
        centerTitle: false,
      ),

      body: state is GetLoadingCartDateState?
          cartDataModel!.isEmpty?
          const Center(
            child:  SpinKitChasingDots(
              color: customColor,
              size: 40,
            ),
          ):

      const Center(
        child:  SpinKitChasingDots(
          color: customColor,
          size: 40,
        ),
      ):
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: AddressCubit.get(context).cartModel==null?
        const Center(
          child:  SpinKitChasingDots(
            color: customColor,
            size: 40,
          ),
        ):
        SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                itemBuilder: (context, index) =>  Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CartItem(cartDataModel!,index),
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cartDataModel!.length,
              ),
              const SizedBox(
                height: 20,
              ),
              AddressCubit.get(context).cartDataModel!.isEmpty?
                  Container():
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 1.2,
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (val) =>val!.isEmpty?
                    getTranslated(context, "please Enter Cupon",)!
                        : null,
                    controller: couponTextEditingController,
                    decoration: InputDecoration(
                        labelText: getTranslated(context, "Enter Cupon Code",)!,
                        contentPadding: const EdgeInsets.all(10),
                        suffixIcon: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)
                              )
                          ),
                          child: state is GetLoadingCouponCartDateState?
                          const Center(
                            child:  SpinKitChasingDots(
                              color: customColor,
                              size: 40,
                            ),
                          ):
                          MaterialButton(onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              MySharedPreferences().getUserId().then((value) {
                                AddressCubit.get(context).
                                checkCupounItemCart(
                                    Localizations
                                        .localeOf(context)
                                        .languageCode,
                                    value,
                                    AddressCubit
                                        .get(context)
                                        .cartModel!
                                        .data!
                                        .id,
                                    couponTextEditingController.text
                                );
                              });
                            }
                          },
                            minWidth: 100,
                            color: customColor,
                            child:  Text(
                              getTranslated(context, "Apply",)!
                              , style: const TextStyle(color:
                            Colors.white),
                            ),),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AddressCubit.get(context).cartDataModel!.isEmpty?
              Container(
                height: 400,
                child: Center(
                  child: Text(getTranslated(context, "No Orders")!,
                  style: TextStyle(
                    color: customColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),),
                ),
              ):
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: HexColor("#EBF0FF"))
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          customText(
                              getTranslated(context, "Items",)!
                              ,color: HexColor("#9098B1"),
                              size: 12),
                          customText(
                          AddressCubit.get(context).cartModel!.data!.itemsCount.toString()
                         ,color: HexColor("#9098B1"),
                          size: 12),
                          const Spacer(),
                          customText(
                              "AED ${AddressCubit.get(context).cartModel!.data!.total!}"
                          ,color: customTextColor,
                              size: 12),
                        ],
                      ),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          customText(getTranslated(context, "Shipping",)!
                              ,color: HexColor("#9098B1"),
                              size: 12),
                          const Spacer(),
                          customText("\$41.86",color: customTextColor,
                              size: 12),
                        ],
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          customText(
                              getTranslated(context, "Discount",)!

                              ,color: HexColor("#9098B1"),
                              size: 12),
                          const Spacer(),
                          customText(
                              "AED ${AddressCubit.get(context).cartModel!.data!.discount!}"
                          ,color: customTextColor,
                              size: 12),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: List.generate(150~/1.5, (index) => Expanded(
                        child: Container(
                          color: index%2==0?Colors.transparent
                              :HexColor("#EBF0FF"),
                          height: 3,
                        ),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          customText(
                              getTranslated(context,  "Total Price",)!
                             ,color:customTextColor,
                              size: 12),
                          const Spacer(),
                          customText(
                              "AED ${
                                 int.parse( AddressCubit.get(context).cartModel!.data!.total!)-
                                      int.parse(AddressCubit.
                                            get(context).cartModel!.data!.discount!)
                              }"
                              ,color: HexColor("#40BFFF"),
                              size: 12),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: connectWithUsWhatsApp(context,widget.phone),
      floatingActionButton: AddressCubit.get(context).cartDataModel!.isEmpty?
      Container():customFloatingActionButton(context,
          text:getTranslated(context,  "Check Out",)!
          , onPress: () {
            MySharedPreferences().getUserId().then((value) {
              print(value);
            });
            pushNewScreen(
              context,
              screen: ShipToScreen(
                  Localizations.localeOf(context).languageCode,
                  withFloatingActionButton:true,
                  orderData:
                OrderData(
                  orderId: cartModel!.data!.id.toString(),
                  orderAmount: "${
                int.parse( AddressCubit.get(context).cartModel!.data!.total!)-
                int.parse(AddressCubit.
                get(context).cartModel!.data!.discount!)}",
                  orderDescription: cartModel.message,
                  currencyCode: "AED",
                ),
              ),
              withNavBar: false, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          }),
    ):
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: customText(

              getTranslated(context, "Your Cart",)!
              ,
              color: customTextColor, fontWeight: FontWeight.bold),
          centerTitle: false,
        ),
        body:  Container(
          padding: const EdgeInsets.all(30),
          height: double.infinity,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const SizedBox(
                  height: 10,
                ),
                customText(
                    getTranslated(context,  "You Want To Login",)!
                    ,
                    color: customTextColor,
                    fontWeight: FontWeight.bold,
                    size: 16),
                const SizedBox(
                  height: 60,
                ),
                Material(
                  elevation: 5,
                  child: Container(
                    width:
                    MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: HexColor("#087DA9"),
                        border: Border.all(
                            color: customTextColor
                                .withOpacity(.2)),
                        borderRadius:
                        BorderRadius.circular(4)),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(widget.mycontext,
                            MaterialPageRoute(builder: (context)=>LoginScreen()),
                                (route) => false);
                      },
                      child: customText(
                          getTranslated(context,  "Sign In",)!
                          ,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        )
      );
     },
     ),
   );
  }
}


class CartItem extends StatefulWidget {
   CartItem(this.cartDataModel,this.index,{Key? key}) : super(key: key);
   List<ItemsCartData> cartDataModel;
   int index;
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  var _itemCount=1;
  @override
  Widget build(BuildContext context) {
    Future<bool> onLikeButtonTapped(bool isLiked) async {
      var useId = await MySharedPreferences().getUserId();
      if (useId != null&& useId != "") {
        if (isLiked) {
          AddressCubit.get(context).makeDisLikeProduct(
              widget.cartDataModel[widget.index].id!,
              useId,
              Localizations.localeOf(context).languageCode
          );
          print("isLiked");
          return !isLiked;
        } else {
          print("isNotLiked");
          AddressCubit.get(context).makeLikeProduct(
              widget.cartDataModel[widget.index].id!,
              useId,
              Localizations.localeOf(context).languageCode
          );
          return !isLiked;
        }
      }else{
        return isLiked;
      }
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: HexColor("#EBF0FF")),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 100,
              width: 100,
              child: widget.cartDataModel[widget.index].photos!.isEmpty?
                  Image.asset("lib/images/gnon-red-logo.png"):
              customCachedNetworkImage(
                url:widget.cartDataModel[widget.index].photos![0].url,
                context: context,
              ),
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                     Expanded(
                      flex: 6,
                      child:  ExpandableText(
                        widget.cartDataModel[widget.index].name!,
                        expandText: 'show more',
                        collapseText: 'show less',
                        expandOnTextTap: true,
                        maxLines: 2,
                        style: const TextStyle(
                            color: customTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                        linkColor: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Expanded(
                      flex: 1,
                      child: LikeButton(
                        onTap: onLikeButtonTapped,
                        size: 20,
                        isLiked: widget.cartDataModel[widget.index].isLiked=="0"?false:true,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        circleColor:
                        const CircleColor(start:  Color(0xff00ddff),
                            end: Color(0xff0099cc)),
                        bubblesColor: const BubblesColor(
                          dotPrimaryColor:  Color(0xff33b5e5),
                          dotSecondaryColor: Color(0xff0099cc),
                        ),
                        likeBuilder: (bool isLiked) {
                          print(isLiked.toString());
                          return DecoratedIcon(
                            isLiked ? Icons.favorite : Icons.favorite_outline,
                            color: isLiked ? HexColor("#FB7181") :
                            Colors.white,
                            size: 20.0,
                            shadows: const[
                              BoxShadow(
                                blurRadius: 12.0,
                                color: customColor,
                              ),
                              BoxShadow(
                                blurRadius: 12.0,
                                color: customColor,
                                offset:  Offset(0, 6.0),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15,),
                    Expanded(
                        flex:1,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                            });
                            MySharedPreferences().getUserId().then((value){
                              AddressCubit.get(context).removeItemCart(
                                  Localizations.localeOf(context).languageCode,
                                  value,
                                  widget.cartDataModel[widget.index].id
                              );
                            });
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            color: HexColor("#9098B1"),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 5,),
                widget.cartDataModel[widget.index].offer == null ?
                Container() :
                Row(
                  children: [
                    SizedBox(
                      child: Text(
                        "${widget.cartDataModel[widget.index].price!} AED",
                        maxLines: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: HexColor("#9098B1"),
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                            decoration: TextDecoration.lineThrough
                        ),
                      ),
                    ),
                    const SizedBox(width: 8,),
                    SizedBox(
                      child: Text(
                        "${getOffer( widget.cartDataModel[widget.index].offer!,
                            widget.cartDataModel[widget.index].price!)} %"
                        ,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: HexColor("#FB7181"),
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: widget.cartDataModel[widget.index].price == null ?
                      Container() :
                      Text(
                        widget.cartDataModel[widget.index].offer == null ?
                        "AED ${widget.cartDataModel[widget.index].price!}" :
                        "AED ${widget.cartDataModel[widget.index].offer!}",
                        maxLines: 1,
                        style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor("#40BFFF"),
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: HexColor("#EBF0FF"),),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        children: <Widget>[
                          InkWell(child: const Icon(Icons.remove),
                            onTap: ()=>int.parse(widget.cartDataModel[widget.index].quantity!)
                                ==1?  setState((){
                              print("sdgdsgsdgeds");

                                MySharedPreferences().getUserId().then((value){
                                  AddressCubit.get(context).removeItemCart(
                                      Localizations.localeOf(context).languageCode,
                                      value,
                                      widget.cartDataModel[widget.index].id
                                  );
                                });
                            }):
                            setState((){
                              _itemCount =
                                  int.parse(widget.cartDataModel[widget.index].quantity!)-1;
                              MySharedPreferences().getUserId().then((value){
                                AddressCubit.get(context).changeQuantityItem(
                                    Localizations.localeOf(context).languageCode,
                                    value,
                                    widget.cartDataModel[widget.index].id,
                                    _itemCount
                                );
                              });
                            }),),
                          /*IconButton(icon:  Icon(Icons.remove),
                            onPressed: ()=>_itemCount !=0?setState(()=>_itemCount--):(){},),*/
                          const SizedBox(width: 5,),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                              decoration: BoxDecoration(
                                color: HexColor("#EBF0FF"),
                              ),
                              child: Text(widget.cartDataModel[widget.index].quantity!)),
                          const SizedBox(width: 5,),
                          InkWell(
                              child: const Icon(Icons.add,size: 20,),
                              onTap:()=>setState(() {
                                print("$_itemCount");
                                _itemCount =
                                    int.parse(widget.cartDataModel[widget.index].quantity!)+1;
                                MySharedPreferences().getUserId().then((value){
                                  AddressCubit.get(context).changeQuantityItem(
                                      Localizations.localeOf(context).languageCode,
                                      value,
                                      widget.cartDataModel[widget.index].id,
                                      _itemCount
                                  );
                                });
                              })),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  double getOffer(String offer, String price) {
    return ((int.parse(price) - int.parse(offer)) /
        int.parse(price)) * 100;
  }
}

