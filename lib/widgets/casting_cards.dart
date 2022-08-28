import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:search_app/providers/movies_provider.dart';
import '../models/models.dart';

class CastingCards extends StatelessWidget {
  final int movieId;
  const CastingCards({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: ( _, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) { // check this condition
          return Container(
            constraints: const BoxConstraints(maxWidth: 150),
            height: 180,
            child: const CupertinoActivityIndicator(),
          );
        }
        final List<Cast> cast = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          height: 180,
          // color: Colors.red,
          child: ListView.builder(
            itemCount: cast.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: ( _ , int index) => _CastCard(cast[index])
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast actor;

  const _CastCard(this.actor);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 100,
      height: 100,
      // color: Colors.green,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              image: NetworkImage(actor.fullProfilePath), 
              placeholder: const AssetImage('assets/no-image.jpg'),
              height: 140,
              width: 100,
              fit: BoxFit.cover,),
          ),
          Text(
            actor.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,)
        ],
      ),
    );
  }
}
