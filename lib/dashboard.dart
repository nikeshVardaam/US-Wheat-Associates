import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/dashboard_page/calculator.dart';
import 'package:uswheat/dashboard_page/prices.dart';
import 'package:uswheat/dashboard_page/reports.dart';
import 'package:uswheat/dashboard_page/watchList.dart';
import 'package:uswheat/provider/dashboard_provider.dart';
import 'package:uswheat/utils/app_assets.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      right: false,
      left: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.c45413b,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.cFFFFFF),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(8),
            child: SizedBox(),
          ),
          title: Image.asset(
            AppAssets.darkLogo,
            scale: 5,
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.notifications_none_outlined),
            )
          ],
        ),
        drawer: Drawer(
          backgroundColor: AppColors.cFFFFFF,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  color: Colors.blueAccent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()),);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 24),
                      child: const Column(
                        children: [
                          CircleAvatar(
                            radius: 52,
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNtaWx5JTIwZmFjZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'
                                // 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c21pbHklMjBmYWNlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'
                                ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Sophia',
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                          Text(
                            '@sophia.com',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home_outlined),
                      title: const Text('Home'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Watchlist()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite_border),
                      title: const Text('Favourites'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Prices()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.workspaces),
                      title: const Text('Workflow'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.update),
                      title: const Text('Updates'),
                      onTap: () {},
                    ),
                    const Divider(
                      color: Colors.black45,
                    ),
                    ListTile(
                      leading: const Icon(Icons.account_tree_outlined),
                      title: const Text('Plugins'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: const Text('Notifications'),
                      onTap: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        body: Consumer<DashboardProvider>(
          builder: (context, dp, child) {
            return Container(
              child: dp.widgetOptions[dp.selectedIndex],
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            Provider.of<DashboardProvider>(context, listen: false).onItemTapped(value);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.c45413b,
          selectedItemColor: AppColors.cec8d30,
          unselectedItemColor: AppColors.cFFFFFF,
          items: [
            BottomNavigationBarItem(label: AppStrings.price, icon: const Icon(Icons.percent), backgroundColor: AppColors.c45413b),
            BottomNavigationBarItem(label: AppStrings.quality, icon: const Icon(Icons.done), backgroundColor: AppColors.c45413b),
            BottomNavigationBarItem(label: AppStrings.watchlist, icon: const Icon(Icons.star_border_outlined), backgroundColor: AppColors.c45413b),
            BottomNavigationBarItem(label: AppStrings.reports, icon: const Icon(Icons.auto_graph_rounded), backgroundColor: AppColors.c45413b),
            BottomNavigationBarItem(label: AppStrings.calculator, icon: const Icon(Icons.calculate_outlined), backgroundColor: AppColors.c45413b),
          ],
        ),
      ),
    );
  }
}
