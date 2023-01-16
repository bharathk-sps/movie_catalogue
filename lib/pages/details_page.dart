import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../utils/constants.dart';
import '../provider/movie_detail_provider.dart';

class MovieDetailsPage extends HookConsumerWidget {
  final int movieId;
  const MovieDetailsPage({required this.movieId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetailProvider = ref.watch(movieDetailProviderNotifier);
    final textController = useTextEditingController();
    final movieDetails = movieDetailProvider.movieDetailModel;
    useEffect(() {
      movieDetailProvider.getMovieDetails(movieId);
      movieDetailProvider.getMovieImages(movieId);
      return null;
    }, [textController]);
    return Scaffold(
      body: movieDetailProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : movieDetails == null
              ? const Center(
                  child: Text(
                    'Details not available',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: movieDetails.backdropPath != null
                      ? BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              backdropImageBase + movieDetails.backdropPath!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        )
                      : const BoxDecoration(color: Colors.grey),
                  child: Container(
                    color: Colors.black54,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 50.0,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${movieDetails.title!} (${movieDetails.releaseDate!.substring(0, 4)})',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text(
                                    movieDetails.tagline ?? '',
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'Overview',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 10,
                            ),
                            child: Text(
                              movieDetails.overview ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
