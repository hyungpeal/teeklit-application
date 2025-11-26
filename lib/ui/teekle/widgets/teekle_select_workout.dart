import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

import '../../../data/services/api/workout_api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class TeekleSelectWorkoutScreen extends StatefulWidget {
  const TeekleSelectWorkoutScreen({super.key});

  @override
  State<TeekleSelectWorkoutScreen> createState() =>
      _TeekleSelectWorkoutScreenState();
}

class _TeekleSelectWorkoutScreenState extends State<TeekleSelectWorkoutScreen> {
  bool _isBookmarkMode = false;
  final WorkoutApiService _api = WorkoutApiService();
  final ScrollController _scrollController = ScrollController();
  var videos = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;

  final Set<String> _bookmarkedVideoUrls = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_isBookmarkMode) return;

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayVideos = _isBookmarkMode
        ? videos
              .where((v) => _bookmarkedVideoUrls.contains(v.videoUrl))
              .toList()
        : videos;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios),
          color: AppColors.txtGray,
        ),
        title: Text(
          '운동 선택하기',
          style: TextStyle(
            fontFamily: 'Paperlogy',
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildTabBar(),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: displayVideos.length,
              itemBuilder: (context, index) {
                final video = displayVideos[index];
                final videoId = video.videoUrl.split('/').last;

                final isBookmarked = _bookmarkedVideoUrls.contains(
                  video.videoUrl,
                );

                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, {
                      'title': video.title,
                      'videoUrl': video.videoUrl,
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.txtGray),
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.network(
                              'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
                              fit: BoxFit.cover,
                              width: 160,
                              height: 90,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 160,
                                  height: 90,
                                  color: Colors.grey[800],
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.white54,
                                      size: 32,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.0),
                                child: Text(
                                  videos[index].title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Paperlogy',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        launchUrl(
                                          Uri.parse(videos[index].videoUrl),
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icons/flowbite_link-outline.svg',
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isBookmarked) {
                                            _bookmarkedVideoUrls.remove(
                                              video.videoUrl,
                                            );
                                          } else {
                                            _bookmarkedVideoUrls.add(
                                              video.videoUrl,
                                            );
                                          }
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        isBookmarked
                                            ? 'assets/icons/bookmark.svg'
                                            : 'assets/icons/bookmark_uncheck.svg',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isBookmarkMode = false;
                });
              },
              child: Container(
                alignment: Alignment.center,
                height: 48,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: !_isBookmarkMode
                          ? AppColors.green
                          : Colors.transparent,
                    ),
                  ),
                ),
                child: Text(
                  '전체',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Paperlogy',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: !_isBookmarkMode
                        ? AppColors.green
                        : AppColors.txtGray,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isBookmarkMode = true;
                });
              },
              child: Container(
                alignment: Alignment.center,
                height: 48,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _isBookmarkMode
                          ? AppColors.green
                          : Colors.transparent,
                    ),
                  ),
                ),
                child: Text(
                  '북마크',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Paperlogy',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: _isBookmarkMode
                        ? AppColors.green
                        : AppColors.txtGray,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final futureWorkouts = await _api.fetchWorkouts(
        page: _currentPage,
        perPage: 10,
      );
      if (futureWorkouts.data.isEmpty) {
        _hasMoreData = false;
        print('데이터 없음');
      }
      setState(() {
        videos.addAll(futureWorkouts.data);
        _currentPage = _currentPage + 1;
      });
    } catch (e) {
      print('데이터를 불러오는 중 오류가 발생했어요 ');
      print('${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
