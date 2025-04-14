import 'package:deep_emotions_with_backend/Screens/HomeScreen/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'comment_provider.dart';
import '../Reuseable_widget/DeepEmotionsRow.dart';
import '../Reuseable_widget/IconRow.dart';
import '../colors_and_other_constants/colors.dart';
import 'video_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _videoStream;
  final GlobalKey _menuKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _videoStream = _firestore.collection('Videos').snapshots();
  }

  void _showMenu() {
    final RenderBox button =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      color: AppColors.GoldCream,
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Toggle Theme'),
            onTap: () {
              Future.delayed(Duration(milliseconds: 100), () {
                final themeProvider = Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                );
                themeProvider.toggleTheme();
              });
            },
          ),
        ),
        PopupMenuItem(
          child: const ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
          ),
          onTap: () => context.go('/profile'),
        ),
        PopupMenuItem(
          child: const ListTile(
            leading: Icon(Icons.description),
            title: Text('Terms & Conditions'),
          ),
          onTap: () => context.go('/terms'),
        ),
        PopupMenuItem(
          child: const ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text('Contact Us'),
          ),
          onTap: () => context.go('/contact'),
        ),
        PopupMenuItem(
          child: const ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
          ),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            context.go('/signIn');
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<CommentProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            _buildDeepEmotionsRow(),
            const SizedBox(height: 15),
            _buildHomeFirstLine(),
            Expanded(child: _buildContentSection(commentProvider)),
            _buildIconRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeepEmotionsRow() => Deepemotionsrow();

  Widget _buildHomeFirstLine() {
    return Column(
      children: [
        HomeFirstLine(
          selectedIndex: _selectedIndex,
          onOptionSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          onMenuPressed: _showMenu,
          menuKey: _menuKey,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildContentSection(CommentProvider commentProvider) {
    return StreamBuilder<QuerySnapshot>(
      stream: _videoStream,
      builder: (context, snapshot) {
        if (snapshot.hasError ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.GoldCream),
          );
        }
        final videos = snapshot.data?.docs ?? [];
        String category = ['Hot', 'Funny', 'Scenery'][_selectedIndex];
        return SingleChildScrollView(
          key: ValueKey(_selectedIndex),
          child: Column(
            children: [
              _buildCategorySection(videos, category, commentProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySection(
    List<QueryDocumentSnapshot> videos,
    String category,
    CommentProvider commentProvider,
  ) {
    final filteredVideos =
        videos.where((video) {
          final data = video.data() as Map<String, dynamic>?;
          return data?['category'] == category;
        }).toList();

    return filteredVideos.isEmpty
        ? Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'No videos available in $category',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        )
        : Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children:
                filteredVideos.map((video) {
                  final videoData = video.data() as Map<String, dynamic>? ?? {};
                  return VideoCard(
                    videoId: video.id,
                    video: videoData,
                    commentProvider: commentProvider,
                  );
                }).toList(),
          ),
        );
  }

  Widget _buildIconRow() => IconRow();
}

class HomeFirstLine extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onOptionSelected;
  final VoidCallback onMenuPressed;
  final GlobalKey menuKey;

  const HomeFirstLine({
    super.key,
    required this.selectedIndex,
    required this.onOptionSelected,
    required this.onMenuPressed,
    required this.menuKey,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOptionContainer('Hot', 0, isDark),
            const SizedBox(width: 15),
            _buildOptionContainer('Funny', 1, isDark),
            const SizedBox(width: 15),
            _buildOptionContainer('Scenery', 2, isDark),
            const SizedBox(width: 45),
            GestureDetector(
              key: menuKey,
              onTap: onMenuPressed,
              child: Icon(
                Icons.menu,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionContainer(String text, int index, bool isDark) {
    return GestureDetector(
      onTap: () => onOptionSelected(index),
      child: Container(
        height: 30,
        width: 70,
        decoration: BoxDecoration(
          color:
              selectedIndex == index
                  ? AppColors.GoldCream
                  : (isDark ? AppColors.CharcoalBlack : Colors.grey[300]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color:
                  selectedIndex == index
                      ? Colors.black
                      : (isDark ? Colors.white : Colors.black),
              fontWeight:
                  selectedIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
