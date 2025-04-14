import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_emotions_with_backend/Screens/HomeScreen/Videodetailscreen.dart';
import 'package:deep_emotions_with_backend/Screens/HomeScreen/comment_provider.dart';
import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.CharcoalBlack,
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Notifications', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Videos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No videos available.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final videos = snapshot.data!.docs;

          return ListView.separated(
            itemCount: videos.length,
            separatorBuilder:
                (context, index) => Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 1,
                  indent: 70,
                ),
            itemBuilder: (context, index) {
              final videoData = videos[index].data() as Map<String, dynamic>;
              final videoId = videos[index].id;
              final title = videoData['title'] ?? 'No Title';
              final link = videoData['link'] ?? '';
              final adminName = videoData['adminName'] ?? 'Unknown User';
              final profileImageUrl = videoData['profileImageUrl'] ?? '';

              // Extract YouTube video ID from the link
              final videoYTId = YoutubePlayer.convertUrlToId(link);
              if (videoYTId == null) {
                return _buildErrorCard('Invalid YouTube URL for $title');
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => VideoDetailScreen(
                            videoId: videoId,
                            video: videoData,
                            commentProvider: CommentProvider(),
                          ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(profileImageUrl),
                        onBackgroundImageError: (_, __) {},
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              adminName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4, width: 90),
                            Text(
                              title,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  'https://img.youtube.com/vi/$videoYTId/0.jpg',
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
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
          );
        },
      ),
    );
  }

  Widget _buildErrorCard(String message) => Center(
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
  );
}
