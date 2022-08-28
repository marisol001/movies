import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_app/providers/movies_provider.dart';
import 'package:search_app/models/movie.dart';

class MovieSearchDelegate extends SearchDelegate{

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Search movie';

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.close)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Text('buildResults');
    
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    //return Text('buildSuggestions: $query');

    if (query.isEmpty) {
      return _emptyContainer();
    }
    print('http request');
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionByQuery(query);
    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();
        final movies = snapshot.data!;
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: ( _, int index) => _MovieItem(movies[index]));
      });
  }

  Widget _emptyContainer() {
    return const Center(
      child: Icon(Icons.movie_creation_outlined,
      color: Colors.black38,
      size: 130)
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  _MovieItem(this.movie);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          image: NetworkImage(movie.fullPosterImg),
          placeholder: const AssetImage('assets/no-image.jpg'),
          width: 50,
          fit: BoxFit.cover),
      ),
        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
    );
  }
}