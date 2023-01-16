import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../provider/movie_provider.dart';
import '../widgets/nav_items.dart';
import '../utils/constants.dart';

// ignore: must_be_immutable
class LeftPane extends HookConsumerWidget {
  LeftPane({
    required this.selected,
    required this.onItemSelect,
    Key? key,
  }) : super(key: key);

  final int selected;
  final ValueChanged<int> onItemSelect;
  late int currentPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieProvider = ref.watch(movieProviderNotifier);
    final currentPage = useState(selected);
    return Column(
      children: [
        Container(
          height: screenHeight(context) * 0.25,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.indigo[700],
            border: const Border(
              bottom: BorderSide(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
          child: Image.asset('assets/images/tmdb.png'),
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 20),
              mainNavItem(
                screenWidth(context) / 75,
                () {
                  currentPage.value = 0;
                  onItemSelect(currentPage.value);
                  movieProvider.page = 1;
                  movieProvider.nowPlayingMovieResults.clear();
                  movieProvider.getNowPlayingMovies(true);
                },
                currentPage.value == 0,
                'Now Playing',
                Icons.play_circle_fill_outlined,
              ),
              mainNavItem(
                screenWidth(context) / 75,
                () {
                  currentPage.value = 1;
                  onItemSelect(currentPage.value);
                  movieProvider.page = 1;
                  movieProvider.popularMovieResults.clear();
                  movieProvider.getPopularMovies(true);
                },
                currentPage.value == 1,
                'Most Popular',
                Icons.emoji_events_outlined,
              ),
              mainNavItem(
                screenWidth(context) / 75,
                () {
                  currentPage.value = 2;
                  onItemSelect(currentPage.value);
                  movieProvider.upcomingMovieResults.clear();
                  movieProvider.getUpcomingMovies(true);
                },
                currentPage.value == 2,
                'Up Coming',
                Icons.new_releases_outlined,
              ),
              mainNavItem(
                screenWidth(context) / 75,
                () {
                  currentPage.value = 3;
                  onItemSelect(currentPage.value);
                  movieProvider.page = 1;
                  movieProvider.topRatedMovieResults.clear();
                  movieProvider.getTopRatedMovies(true);
                },
                currentPage.value == 3,
                'Top Chart',
                Icons.diamond_outlined,
              )
            ],
          ),
        ),
        const SizedBox(height: 30),
        Expanded(
          child: Column(
            children: [
              subNavItem(
                'My Collection',
                false,
                () {},
                Icons.stop_circle_rounded,
                Icons.arrow_drop_down,
                screenWidth(context) / 75,
                screenWidth(context) / 75,
              ),
              subNavItem(
                'Bookmark',
                false,
                () {},
                null,
                null,
                screenWidth(context) / 85,
                screenWidth(context) / 85,
              ),
              subNavItem(
                'History',
                false,
                () {},
                null,
                null,
                screenWidth(context) / 85,
                screenWidth(context) / 85,
              ),
              subNavItem(
                'Subscriptions',
                false,
                () {},
                null,
                null,
                screenWidth(context) / 85,
                screenWidth(context) / 85,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
