import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../models/movies_model.dart';
import '../widgets/main_pane.dart';

class SearchPage extends HookWidget {
  final List<MovieResults>? movieData;
  final ScrollController scrollController;
  final bool isGridview;

  const SearchPage(
      {required this.movieData,
      required this.scrollController,
      required this.isGridview,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      isGridview;
      return null;
    });
    return MainPane(
      movieData: movieData,
      scrollController: scrollController,
      isGridview: isGridview,
    );
  }
}
