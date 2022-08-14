import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gnon/constants/color_constans.dart';
import 'package:gnon/constants/themes.dart';
import 'package:gnon/screens/account/order/order_bloc/order_cubit.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../localization/localization_constants.dart';
import '../../../models/order_list_model.dart';
import 'order_details_screen.dart';

class OrdersListScreen extends StatefulWidget {
   OrdersListScreen(this.lang,{Key? key}) : super(key: key);
  String? lang;
  @override
  _OrdersListScreenState createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit()..getOrderL(widget.lang,),
      child: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var ordersListData = OrderCubit.get(context).ordersListData;
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              elevation: 1,
              leading: IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon:
              Icon(
                Icons.arrow_back_ios, size: 14, color: HexColor("#9098B1"),)),
              title: customText(
                  getTranslated(context, "Order")!
                  , fontWeight: FontWeight.bold),
              backgroundColor: Colors.white,
            ),
            body: state is GetLoadingOrderListOrderState?
            const Center(
                child:   SpinKitChasingDots(
                  color: customColor,
                  size: 40,
                )):
            ordersListData.isEmpty?
                Center(
                  child: Text(
                    getTranslated(context, "No Orders Yet")!,style:
                  TextStyle(color: customColor,fontSize: 18),
                  ),
                ):
            ListView.builder(itemBuilder: (context, index) {
              return shipItem(index,ordersListData);
            }, itemCount: ordersListData.length,),
          );
        },
      ),
    );
  }

  Widget shipItem(int index,List<OrderList> ordersListData) {
    String? getStatus(){
      String? status;
      switch(ordersListData[index].status){
        case 0:
          status =getTranslated(context, "Packing");
          break;
        case 1:
          status =getTranslated(context, "Shipping");
          break;
        case 2:
          status =getTranslated(context, "Arriving");
          break;
        case 3:
          status =getTranslated(context, "success");
          break;
        case 4:
          status =getTranslated(context, "cancel");
          break;

      }
      return status;

    }
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                OrderDetailsScreen(
                ordersListData[index]
            )));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: HexColor("#EBF0FF"))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
                "${getTranslated(context, "Order Number:")}   ${ordersListData[index].id.toString()}",
                fontWeight: FontWeight.bold),
            SizedBox(height: 10,),

            customText("Order at E-comm ${
                ordersListData[index].shippingDate
            }",
                color: HexColor("9098B1"),
                size: 12),
            SizedBox(height: 10,),
            Row(
              children: List.generate(150 ~/ 1.5, (index) =>
                  Expanded(
                    child: Container(
                      color: index % 2 == 0 ? Colors.transparent
                          : HexColor("#EBF0FF"),
                      height: 2,
                    ),
                  )),
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                customText(
                    getTranslated(context, "Order Status")!
                    , color: customTextColor.withOpacity(.5)),
                Spacer(),

                customText(
                    getStatus()!,
                    color: customTextColor),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                customText(getTranslated(context, "Items")!
                    , color: customTextColor.withOpacity(.5)),
                Spacer(),
                customText((ordersListData[index].itemsCount).toString(), color: customTextColor),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                customText(
                    getTranslated(context, "Price")!,
                    color: customTextColor.withOpacity(.5)),
                Spacer(),
                customText("AED ${
                    int.parse(ordersListData[index].total!)-
                    int.parse(ordersListData[index].discount!)
                }", color: HexColor("#40BFFF"),
                    fontWeight: FontWeight.bold),
              ],
            )
          ],
        ),
      ),
    );
  }

}
