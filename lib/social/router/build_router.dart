import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_social/social/view/photos/photo_screen.dart';
import 'package:image_social/social/view/posts/post_screen.dart';
import 'package:image_social/social/view/scaffold_with_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter buildRouter() {
  return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/photo',
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return ScaffoldWithNavBar(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(routes: <RouteBase>[
                GoRoute(
                  name: 'photo',
                  path: '/photo',
                  builder: (context, state) => const PhotoScreen(),
                )
              ]),
              StatefulShellBranch(routes: <RouteBase>[
                GoRoute(
                  name: 'post',
                  path: '/post',
                  builder: (context, state) => const PostScreen(),
                )
              ])
            ])
      ]);
}
