import 'package:deep_emotions_with_backend/Screens/HomeScreen/ThemeProvider.dart';
import 'package:deep_emotions_with_backend/Screens/HomeScreen/comment_provider.dart'
    show CommentProvider;
import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'video_card.dart';

class VideoDetailScreen extends StatelessWidget {
  final String videoId;
  final Map<String, dynamic> video;
  final CommentProvider commentProvider;
  const VideoDetailScreen({
    super.key,
    required this.videoId,
    required this.video,
    required this.commentProvider,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final bgColor = isDark ? AppColors.CharcoalBlack : Colors.white;
    final iconColor = isDark ? Colors.white : Colors.black;

    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          leading: IconButton(
            onPressed: () => context.go('/home'),
            icon: Icon(Icons.arrow_back, color: iconColor),
          ),
        ),
        body: SingleChildScrollView(
          child: VideoCard(
            videoId: videoId,
            video: video,
            commentProvider: commentProvider,
          ),
        ),
      ),
    );
  }
}
