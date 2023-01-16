import 'dart:ui';

import 'package:flutter/material.dart';
import '../pages/most_popular_page.dart';
import '../pages/now_playing_page.dart';
import '../pages/search_page.dart';
import '../pages/top_chart_page.dart';
import '../pages/upcoming_page.dart';
import '../pages/app_search_page.dart';
import '../provider/movie_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widgets/sort_control.dart';
import '../widgets/profile_section.dart';
import '../widgets/search_bar.dart';
import '../widgets/left_pane.dart';

import '../utils/responsive.dart';
import '../utils/constants.dart';

class AppLayout extends HookConsumerWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final textController = useTextEditingController();
    final isGridView = useState(true);
    final currentPage = useState(0);
    final screen = useState([]);
    final movieProvider = ref.watch(movieProviderNotifier);
    useEffect(() {
      movieProvider.getNowPlayingMovies(true);
      movieProvider.getPopularMovies(true);
      movieProvider.getUpcomingMovies(true);
      movieProvider.getTopRatedMovies(true);
      screen.value = [
        NowPlayingPage(
          movieData: movieProvider.nowPlayingMovieResults,
          scrollController: scrollController,
          isGridview: isGridView.value,
        ),
        MostPopularPage(
          movieData: movieProvider.popularMovieResults,
          scrollController: scrollController,
          isGridview: isGridView.value,
        ),
        UpcomingPage(
          movieData: movieProvider.upcomingMovieResults,
          scrollController: scrollController,
          isGridview: isGridView.value,
        ),
        TopChartPage(
          movieData: movieProvider.topRatedMovieResults,
          scrollController: scrollController,
          isGridview: isGridView.value,
        ),
        SearchPage(
          movieData: movieProvider.searchMovieResults,
          scrollController: scrollController,
          isGridview: isGridView.value,
        )
      ];
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent &&
            !movieProvider.isLoading) {
          if (movieProvider.page != movieProvider.moviesModel?.totalPages) {
            movieProvider.page++;
            if (currentPage.value == 0) {
              movieProvider.getNowPlayingMovies(false);
            } else if (currentPage.value == 1) {
              movieProvider.getPopularMovies(false);
            } else if (currentPage.value == 2) {
              movieProvider.getUpcomingMovies(false);
            } else if (currentPage.value == 3) {
              movieProvider.getTopRatedMovies(false);
            } else if (currentPage.value == 4) {
              movieProvider.searchMovie(
                false,
                textController.text,
              );
            }
          }
        }
      });
      return null;
    }, [textController]);

    return Scaffold(
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? AppBar(
              backgroundColor: Colors.indigo.withOpacity(0.80),
              actions: [
                IconButton(
                  onPressed: () {
                    isGridView.value = false;
                  },
                  icon: const Icon(
                    Icons.view_list,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    isGridView.value = true;
                  },
                  icon: const Icon(
                    Icons.view_module,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white54)),
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>  AppSearchPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Search',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),
                ),
              ],
            )
          : null,
      drawer: ResponsiveWidget.isSmallScreen(context)
          ? Drawer(
              backgroundColor: Colors.indigo.withOpacity(0.80),
              child: LeftPane(
                selected: currentPage.value,
                onItemSelect: (value) {
                  currentPage.value = value;
                },
              ),
            )
          : null,
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
          child: ResponsiveWidget.isSmallScreen(context)

              ///showing loading indicator
              ? Center(
                  child: movieProvider.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.indigo,
                        )

                      /// Showing only main pane for mobile view
                      : screen.value[currentPage.value],
                )

              /// Main parent row
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Left pane column for navigation section
                    Container(
                      width: screenWidth(context) * .20,
                      color: Colors.indigo.withOpacity(0.95),
                      child: LeftPane(
                        selected: currentPage.value,
                        onItemSelect: (value) {
                          currentPage.value = value;
                        },
                      ),
                    ),

                    /// Right column for header and main pane
                    Expanded(
                      child: Column(
                        children: [
                          /// Header section with search and profile
                          Container(
                            height: screenHeight(context) * 0.15,
                            color: Colors.indigo.withOpacity(0.80),
                            child: Row(
                              children: [
                                searchBar(textController, (value) {
                                  currentPage.value = 4;
                                  movieProvider.page = 1;
                                  movieProvider.searchMovieResults.clear();
                                  movieProvider.searchMovie(true, value);
                                }),
                                profileSection(),
                              ],
                            ),
                          ),

                          /// Filter section
                          Container(
                            height: screenHeight(context) * 0.15,
                            color: Colors.deepPurple.withOpacity(0.60),
                            child: sortControl(
                              context,
                              () {
                                isGridView.value = false;
                              },
                              () {
                                isGridView.value = true;
                              },
                            ),
                          ),

                          /// Main Pane section
                          Expanded(
                            child: Center(
                              child: movieProvider.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.indigo,
                                    )
                                  : screen.value[currentPage.value],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
