import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          navigationShell,
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) => _onTap(context, index),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.photo),
                  label: 'Photos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.comment),
                  label: 'Posts',
                )
              ],
            ),
          ),
        ],
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: navigationShell.currentIndex,
      //   onTap: (index) => _onTap(context, index),
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.photo),
      //       label: 'Photos',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.comment),
      //       label: 'Posts',
      //     )
      //   ],
      // ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(index,
        initialLocation: index == navigationShell.currentIndex);
  }
}
