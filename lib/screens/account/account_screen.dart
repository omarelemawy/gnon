import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gnon/constants/color_constans.dart';
import 'package:gnon/constants/themes.dart';
import 'package:gnon/screens/account/account_bloc/account_cubit.dart';
import 'package:gnon/screens/account/account_bloc/account_state.dart';
import 'package:gnon/screens/account/profile_screen.dart';
import 'package:gnon/screens/account/view_dialog.dart';
import 'package:gnon/screens/auth/login/login_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../constants/widget.dart';
import '../../localization/localization_constants.dart';
import '../../models/language.dart';
import '../../models/user_data.dart';
import '../../sharedPreferences.dart';
import '../Cart/ship_to_screen.dart';
import 'order/orders_list_screen.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen(this.context1, this.email, this.phone, {Key? key})
      : super(key: key);
  var context1;
  String email;
  String phone;

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountCubit(),
      child: BlocConsumer<AccountCubit, AccountState>(
        builder: (context, state) {
          Widget deleteAccount(context) {
            return BlocProvider(
              create: (context) => AccountCubit(),
              child: BlocConsumer<AccountCubit, AccountState>
                (
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return AlertDialog(
                    title: Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                      size: 30,
                    ),
                    actions: [
                      Container(
                        padding: const EdgeInsets.all(30),
                        height: MediaQuery
                            .of(context)
                            .size
                            .height / 2.3,
                        color: Colors.white,
                        child: Column(
                          children: [
                            customText(
                                getTranslated(context, "Are you sure?",)!,
                                fontWeight: FontWeight.bold, size: 18),
                            const SizedBox(
                              height: 10,
                            ),
                            customText(
                                getTranslated(context,
                                  "Please be aware that you cannot retrieve this data again",)!
                                ,
                                color: customTextColor.withOpacity(.3),
                                fontWeight: FontWeight.bold,
                                size: 12),
                            const SizedBox(
                              height: 60,
                            ),
                            state is DeleteProfileLoadingAccountState ?
                            const Center(
                                child: SpinKitChasingDots(
                                  color: customColor,
                                  size: 40,
                                )) :
                            Material(
                              elevation: 5,
                              child: Container(
                                width:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                decoration: BoxDecoration(
                                    color: HexColor("#087DA9"),
                                    border: Border.all(
                                        color: customTextColor
                                            .withOpacity(.2)),
                                    borderRadius:
                                    BorderRadius.circular(4)),
                                child: MaterialButton(
                                  onPressed: () {
                                    MySharedPreferences().getUserId().then((
                                        value) {
                                      AccountCubit.get(context).deleteMyProfile
                                        (widget.context1,
                                          Localizations
                                              .localeOf(context)
                                              .languageCode
                                          , value,context);
                                    });

                                  },
                                  child: customText(
                                      getTranslated(context, "Submit",)!
                                      ,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: customTextColor
                                          .withOpacity(.2)),
                                  borderRadius:
                                  BorderRadius.circular(4)),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: customText(
                                    getTranslated(context, "Cancel",)!
                                    ,
                                    color:
                                    customTextColor.withOpacity(.5),
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            );
          }
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  customText(getTranslated(context, "Account")!,
                      fontWeight: FontWeight.bold, size: 16),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: HexColor("#EBF0FF"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: customText(getTranslated(context, "Profile")!,
                        color: customTextColor, fontWeight: FontWeight.w600),
                    leading: Icon(
                      Icons.person_outline,
                      color: HexColor("#40BFFF"),
                    ),
                    onTap: () {
                      getUserDate().then((value) {
                        if (value.email == "" || value.email == null) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return deleteDialog(context);
                              });
                        } else {
                          pushNewScreen(
                            context,
                            screen: ProfileScreen(
                                Localizations
                                    .localeOf(context)
                                    .languageCode),
                            withNavBar: false,
                            // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation
                                .cupertino,
                          );
                        }
                      }
                      );
                    },
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: HexColor("#EBF0FF"),
                  ),
                  ListTile(
                    onTap: () {
                      getUserDate().then((value) {
                        if (value.email == "" || value.email == null) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return deleteDialog(context);
                              });
                        } else {
                          pushNewScreen(
                            context,
                            screen: OrdersListScreen(
                                Localizations
                                    .localeOf(context)
                                    .languageCode
                            ),
                            withNavBar: false,
                            // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation
                                .cupertino,
                          );
                        }
                      }
                      );
                    },
                    leading: Icon(
                      Icons.shopping_bag_outlined,
                      color: HexColor("#40BFFF"),
                    ),
                    title: customText(getTranslated(context, "Order")!,
                        color: customTextColor, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: HexColor("#EBF0FF"),
                  ),
                  ListTile(
                    title: customText(getTranslated(context, "Address")!,
                        color: customTextColor, fontWeight: FontWeight.w600),
                    leading: Icon(
                      Icons.location_on_outlined,
                      color: HexColor("#40BFFF"),
                    ),
                    onTap: () {
                      getUserDate().then((value) {
                        if (value.email == "" || value.email == null) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return deleteDialog(context);
                              });
                        } else {
                          pushNewScreen(
                            context,
                            screen: ShipToScreen(
                              Localizations
                                  .localeOf(context)
                                  .languageCode,
                              withFloatingActionButton: false,
                            ),
                            withNavBar: false,
                            // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation
                                .cupertino,
                          );
                        }
                      }
                      );
                    },
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: HexColor("#EBF0FF"),
                  ),
                  ListTile(
                    onTap: () {
                      getUserDate().then((value) {
                        print(value);
                        if (value.email == "" || value.email == null) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return deleteDialog(context);
                              });
                        } else {
                          pushNewScreen(
                            context,
                            screen: ShipToScreen(
                              Localizations
                                  .localeOf(context)
                                  .languageCode,
                              withFloatingActionButton: false,
                            ),
                            withNavBar: false,
                            // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation
                                .cupertino,
                          );
                        }
                      }
                      );
                    },
                    title: customText(
                        getTranslated(
                          context,
                          "Payment",
                        )!,
                        color: customTextColor,
                        fontWeight: FontWeight.w600),
                    leading: Icon(
                      Icons.payment,
                      color: HexColor("#40BFFF"),
                    ),
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: HexColor("#EBF0FF"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: customText(
                        getTranslated(
                          context,
                          "Language",
                        )!,
                        color: customTextColor,
                        fontWeight: FontWeight.w600),
                    leading: Icon(
                      Icons.language,
                      color: HexColor("#40BFFF"),
                    ),
                    trailing: DropdownButton<Language>(
                      dropdownColor: Colors.white,
                      underline: SizedBox(),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: HexColor("#40BFFF"),
                      ),
                      onChanged: (Language? language) {
                        AccountCubit.get(context)
                            .changeLanguage(language!, context);
                      },
                      items: Language.languageList()
                          .map<DropdownMenuItem<Language>>(
                            (e) =>
                            DropdownMenuItem<Language>(
                              value: e,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    e.flag,
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Text(e.name)
                                ],
                              ),
                            ),
                      )
                          .toList(),
                    ),
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: HexColor("#EBF0FF"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: customText(
                        widget.email != "" || widget.email == "null" ?
                        getTranslated(
                          context,
                          "Log Out",
                        )! : getTranslated(
                          context,
                          "Sign In",
                        )!,
                        color: customTextColor,
                        fontWeight: FontWeight.w600),
                    leading: Icon(
                      widget.email != "" || widget.email == "null" ?
                      Icons.logout : Icons.login,
                      color: HexColor("#40BFFF"),
                    ),
                    onTap: () {
                      MySharedPreferences.saveUserId("");
                      MySharedPreferences.saveUserUserName("");
                      MySharedPreferences.saveUserUserEmail("");
                      MySharedPreferences.saveUserUserPhoneNumber("");
                      MySharedPreferences.saveUserImageUrl("");
                      MySharedPreferences.saveUserCountryName("");
                      MySharedPreferences.saveCountryCode("");
                      Navigator.pushAndRemoveUntil(
                          widget.context1,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                              (route) => false);
                    },
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: HexColor("#EBF0FF"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  widget.email != "" || widget.email == "null" ?
                  ListTile(
                    title: customText(
                        getTranslated(
                          context,
                          "Remove Account",
                        )!,
                        color: Colors.red,
                        fontWeight: FontWeight.w600),
                    leading: Icon(
                      Icons.remove_circle,
                      color: Colors.red /*HexColor("#40BFFF")*/,
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return deleteAccount(context);
                          });
                    },
                  ) : SizedBox(),
                ],
              ),
            ),
            bottomNavigationBar: connectWithUsWhatsApp(context, widget.phone),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
