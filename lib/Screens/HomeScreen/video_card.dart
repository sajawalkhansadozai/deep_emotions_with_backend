import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_emotions_with_backend/Screens/HomeScreen/videodetailscreen.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/bottom_line.dart';
import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemChrome
import 'package:flutter_svg/svg.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../Reuseable_widget/heartRow.dart';
import 'comment_provider.dart';

class VideoCard extends StatelessWidget {
  final String videoId;
  final Map<String, dynamic> video;
  final CommentProvider commentProvider;

  const VideoCard({
    super.key,
    required this.videoId,
    required this.video,
    required this.commentProvider,
  });

  @override
  Widget build(BuildContext context) {
    final title = video['title'] ?? 'No Title';
    final link = video['link'] ?? '';
    final adminName = video['adminName'] ?? 'Unknown User';
    final profileImageUrl = video['profileImageUrl'] ?? '';
    final subText = video['subText'] ?? 'No Subtext';
    final videoYTId = YoutubePlayer.convertUrlToId(link);

    if (videoYTId == null) {
      return _buildErrorCard('Invalid YouTube URL for $title');
    }

    final controller = YoutubePlayerController(
      initialVideoId: videoYTId,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('Comments')
              .where('videoId', isEqualTo: videoId)
              .snapshots(),
      builder: (context, commentSnapshot) {
        int commentCount =
            commentSnapshot.hasData ? commentSnapshot.data!.docs.length : 0;

        return StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('Likes')
                  .where('videoId', isEqualTo: videoId)
                  .snapshots(),
          builder: (context, likeSnapshot) {
            int likeCount =
                likeSnapshot.hasData ? likeSnapshot.data!.docs.length : 0;

            bool isLiked = false;
            final currentUser = FirebaseAuth.instance.currentUser;

            if (currentUser != null && likeSnapshot.hasData) {
              isLiked = likeSnapshot.data!.docs.any(
                (doc) => doc['userId'] == currentUser.uid,
              );
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => VideoDetailScreen(
                          videoId: videoId,
                          video: video,
                          commentProvider: commentProvider,
                        ),
                  ),
                );
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(
                      adminName,
                      profileImageUrl,
                      subText,
                      title,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GestureDetector(
                        onTap: () {
                          _showFullScreenVideo(context, controller);
                        },
                        child: YoutubePlayer(
                          controller: controller,
                          showVideoProgressIndicator: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildInteractionRow(
                      context,
                      likeCount,
                      isLiked,
                      commentCount,
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showFullScreenVideo(
    BuildContext context,
    YoutubePlayerController controller,
  ) {
    // Hide system UI (status bar and navigation bar)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            fullscreenDialog: true, // Make it a full-screen dialog
            builder:
                (context) => WillPopScope(
                  onWillPop: () async {
                    // Restore system UI before popping the route
                    SystemChrome.setEnabledSystemUIMode(
                      SystemUiMode.edgeToEdge,
                    );
                    return true;
                  },
                  child: Scaffold(
                    backgroundColor: Colors.black, // Set background to black
                    body: Stack(
                      children: [
                        // Full-screen YouTube player
                        Center(
                          child: YoutubePlayer(
                            controller: controller,
                            showVideoProgressIndicator: true,
                            onReady: () {
                              controller.play();
                            },
                            bottomActions: [
                              CurrentPosition(),
                              ProgressBar(isExpanded: true),
                              RemainingDuration(),
                              FullScreenButton(), // Optional: Keep full-screen toggle in player controls
                            ],
                          ),
                        ),
                        // Optional: Add a close button in the top-left corner
                        Positioned(
                          top: 20,
                          left: 20,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              // Restore system UI and pop the route
                              SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.edgeToEdge,
                              );
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        )
        .then((_) {
          // Ensure the system UI is restored when exiting full-screen
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        });
  }

  Widget _buildProfileHeader(
    String adminName,
    String profileImageUrl,
    String subText,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(profileImageUrl),
                onBackgroundImageError: (_, __) {},
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adminName,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subText,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionRow(
    BuildContext context,
    int likeCount,
    bool isLiked,
    int commentCount,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildLikeButton(context, likeCount, isLiked),
            const SizedBox(width: 8),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 100, top: 3),
          child: HeartLine(videoId: videoId),
        ),
        _buildCommentButton(context, commentCount),
      ],
    );
  }

  Widget _buildLikeButton(BuildContext context, int likeCount, bool isLiked) {
    return GestureDetector(
      onTap: () async {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please sign in to like')),
          );
          return;
        }

        final likeDoc =
            await FirebaseFirestore.instance
                .collection('Likes')
                .where('videoId', isEqualTo: videoId)
                .where('userId', isEqualTo: currentUser.uid)
                .get();

        if (likeDoc.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('Likes')
              .doc(likeDoc.docs.first.id)
              .delete();
          await FirebaseFirestore.instance
              .collection('Videos')
              .doc(videoId)
              .update({'likeCount': FieldValue.increment(-1)});
        } else {
          final userName = currentUser.displayName ?? 'Anonymous';
          await FirebaseFirestore.instance.collection('Likes').add({
            'videoId': videoId,
            'userId': currentUser.uid,
            'name': userName,
            'timestamp': FieldValue.serverTimestamp(),
          });
          await FirebaseFirestore.instance
              .collection('Videos')
              .doc(videoId)
              .update({'likeCount': FieldValue.increment(1)});
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.CreamBlack,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.white,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              '$likeCount',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentButton(BuildContext context, int commentCount) {
    return GestureDetector(
      onTap: () {
        _showCommentBottomSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.CreamBlack,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/chat-bubble.svg',
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 3),
            Text(
              '$commentCount',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentBottomSheet(BuildContext context) {
    final TextEditingController _commentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Important for keyboard handling
      backgroundColor: Colors.transparent,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom:
                  MediaQuery.of(
                    context,
                  ).viewInsets.bottom, // Accounts for keyboard
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(context).size.height *
                    0.6, // Adjust height for keyboard
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with close button
                  const SizedBox(height: 30),
                  BottomLine(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.GoldCream,
                            borderRadius: BorderRadius.circular(
                              20,
                            ), // Circular edges
                          ),
                          child: const Text(
                            'Comments',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expanded comments list
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('Comments')
                              .where('videoId', isEqualTo: videoId)
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              'No comments yet.',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final comments = snapshot.data!.docs;
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 8),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final commentData =
                                comments[index].data() as Map<String, dynamic>;
                            final userName =
                                commentData['userName'] ?? 'Unknown User';
                            final commentText = commentData['comment'] ?? '';
                            final userAvatar = commentData['userAvatar'];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        userAvatar != null &&
                                                userAvatar.isNotEmpty
                                            ? NetworkImage(userAvatar)
                                            : const AssetImage(
                                                  'assets/default-avatar.png',
                                                )
                                                as ImageProvider,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          commentText,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // Comment input section (fixed at bottom)
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    color: Colors.grey[900],
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Write a comment...',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[800],
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            final commentText = _commentController.text.trim();
                            if (commentText.isNotEmpty) {
                              final currentUser = await _getCurrentUser();
                              if (currentUser != null) {
                                await FirebaseFirestore.instance
                                    .collection('Comments')
                                    .add({
                                      'videoId': videoId,
                                      'userId': currentUser['id'],
                                      'userName': currentUser['name'],
                                      'comment': commentText,
                                      'timestamp': FieldValue.serverTimestamp(),
                                      'userAvatar': currentUser['avatar'] ?? '',
                                    });
                                _commentController.clear();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please sign in to comment'),
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: AppColors.GoldCream,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 22,
                            ),
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

  Future<Map<String, dynamic>?> _getCurrentUser() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return null;

    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(firebaseUser.uid)
            .get();
    return userDoc.exists ? userDoc.data() as Map<String, dynamic> : null;
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
