import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_social/simple_bloc_observer.dart';
import 'package:image_social/social/bloc/comment_bloc/comment_bloc.dart';
import 'package:image_social/social/bloc/photo_bloc/photo_bloc.dart';
import 'package:image_social/social/bloc/post_bloc/post_bloc.dart';
import 'package:image_social/social/router/build_router.dart';
import 'package:http/http.dart' as http;

void main() {
  Bloc.observer = const SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blueAccent,
      primary: const Color(0xFF0C5FBF),
      secondary: Colors.grey,
      surface: Colors.white,
      onSecondary: Colors.black,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            log('Integrating BlocProvider into widget treee');
            return PostBloc(
                httpClient: http.Client(),)
              ..add(PostFetched());
          },
        ),
        BlocProvider(create: (_) {
          log('Integrating CommentBloc to widget tree');
          return CommentBloc(httpClient: http.Client());
        }),
        BlocProvider(
          create: (_) {
            log('Integrating PhotoBloc to widget tree');
            return PhotoBloc(httpClient: http.Client())..add(PhotoFetched());
          },
        )
      ],
      child: MaterialApp.router(
        title: 'Social Photo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 4,
              shadowColor: colorScheme.shadow),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: colorScheme.secondary,
            showUnselectedLabels: true,
          ),
        ),
        routerConfig: buildRouter(),
      ),
    );
  }
}
