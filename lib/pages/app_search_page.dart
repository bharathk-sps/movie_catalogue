import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


import '../pages/search_page.dart';
import '../provider/movie_provider.dart';

class AppSearchPage extends HookConsumerWidget {
  const AppSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final textController = useTextEditingController();
    final movieProvider = ref.watch(movieProviderNotifier);
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent &&
            !movieProvider.isLoading) {
          if (movieProvider.page != movieProvider.moviesModel?.totalPages) {
            movieProvider.page++;
            movieProvider.searchMovie(false, textController.text);
          }
        }
      });
      return null;
    }, [textController]);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              controller: textController,
              onChanged: (value) {
                movieProvider.page = 1;
                movieProvider.searchMovieResults.clear();
                movieProvider.searchMovie(true, value);
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      textController.clear();
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: Container(
        ///Setting a background image for entire layout
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),

        /// Using Backdrop filter to blur the image
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Center(
            child: textController.text.isEmpty
                ? const Center(
                    child: Text(
                      'Search Movies',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  )
                : movieProvider.isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : SearchPage(
                        movieData: movieProvider.searchMovieResults,
                        scrollController: scrollController,
                        isGridview: true,
                      ),
          ),
        ),
      ),
    );
  }
}
