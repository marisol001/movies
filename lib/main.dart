import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_app/pages/pages.dart';
import 'package:search_app/providers/movies_provider.dart';

 
 void main() => runApp(AppState());

 class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) =>
      MoviesProvider(),
      lazy: false,)
    ],
    child: const MyApp(),);
  }
}
 
 class MyApp extends StatelessWidget {
   const MyApp({super.key});
 
   @override
   Widget build(BuildContext context) {
     return MaterialApp(
      debugShowCheckedModeBanner: false,
       title: 'Movies',
       initialRoute: 'home',
       routes: {
        'home': ( _ ) =>  const HomePage(),
        'details': ( _ ) => const DetailsPage(),
       },
       theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.deepPurpleAccent
        )
       ),
     );
   }
 }