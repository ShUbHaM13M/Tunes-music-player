import 'package:flutter/material.dart';
import 'package:tunes/screens/home/app_bar.dart';
import 'package:tunes/screens/home/home_screen_bottom.dart';
import 'package:tunes/screens/home/tabs/tabs.dart';
import 'package:tunes/screens/settings/settings.dart';
import 'package:tunes/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<HomeScreen> {
  late final TabController _controller;

  @override
  initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(),
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [
            TabBarView(
              controller: _controller,
              children: const [
                SongTab(),
                AlbumTab(),
                ArtistTab(),
                // PlayListTab(),
                SettingsPage()
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: HomeScreenBottom(
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
