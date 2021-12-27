import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/model/data_model.dart';
import 'package:grocery_app/model/user.dart';
import 'package:grocery_app/screens/account_screen.dart';
import 'package:grocery_app/screens/campaigns_screen.dart';
import 'package:grocery_app/screens/cart/cart_screen.dart';
import 'package:grocery_app/screens/category/category_page.dart';
import 'package:grocery_app/screens/search_screen.dart';
import 'package:grocery_app/services/auth.dart';
import 'package:grocery_app/services/database.dart';
import 'notification_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  final AppUser user;
  final List<CategoryProduct> categories;

  const HomeScreen(this.user, this.categories,{Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;


  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavBar(widget.user,widget.categories),
    );
  }
}

class PromotionList extends StatefulWidget {
  const PromotionList({Key? key}) : super(key: key);

  @override
  _PromotionListState createState() => _PromotionListState();
}

class _PromotionListState extends State<PromotionList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: 10,
        controller: PageController(viewportFraction: 0.95),
        itemBuilder: (_, i) {
          return Transform.scale(
            scale: 1.05,
            child: TextButton(
              onPressed: () {},
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.amberAccent, width: 0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Promotion ${i + 1}",
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class BottomNavBar extends StatefulWidget {
  final List<CategoryProduct> categories;
  final AppUser user;


  const BottomNavBar(this.user,this.categories ,{Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  bool isClicked = false;
  static List<Widget> _widgetOptions = [];
  AppUser updatedUser = AppUser('', '', '', '', '', '', Type.none);
  List<CategoryProduct> categories = [];

  @override
  void initState() {
    super.initState();
    updatedUser = widget.user;
    categories = widget.categories;
    _widgetOptions = <Widget>[
      CategoryPage(updatedUser,categories),
      SearchPage(updatedUser,categories),
      CartScreen(updatedUser,categories),
      Campaigns(updatedUser,categories),
      AccountScreen(updatedUser,categories),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      isClicked = false;
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.amber,
        title: const Text('GROCERY APP',
            style:
                TextStyle(color: Colors.black, fontFamily: 'YOUR_FONT_FAMILY')),
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isClicked = !isClicked;
                    widget.user.setNotifications();
                    widget.user.update();
                  });
                },
                child: (widget.user.isNewNotification())?
                    Icon(
                      Icons.add_alert,
                      size: 26.0,
                      color: (isClicked)? Colors.white : Colors.black,
                    )
                    :Icon(
                      Icons.add_alert_outlined,
                      size: 26.0,
                      color: (isClicked)? Colors.white : Colors.black,
                    ),
              )
          ),
        ],
      ),
      body: Center(
        child: (!isClicked)? _widgetOptions.elementAt(_selectedIndex) : NotificationPage(updatedUser),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.campaign), label: 'Campaigns'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
