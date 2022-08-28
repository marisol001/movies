import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movies_provider.dart';
import '../search/search_delegate.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
   
  const HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies Cinema'),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()),
            icon: const Icon(Icons.search_sharp))
        ],
      ),
      body: SingleChildScrollView(child: Column(
        children:  [
          // ignore: todo
          // TODO: CardSwiper
          // Listado horizontal de películas
          CardSwiper(movies: moviesProvider.onDisplayMovies),
          // Slider peliculas
          MovieSlider(
            movies: moviesProvider.popularMovies,
            title: 'Populares',
            nextPage: () => moviesProvider.getPopularMovies()),
        ],)
      )
    );
  }
}