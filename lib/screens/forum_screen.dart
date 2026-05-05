import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("Q&A Forum"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildWelcomeBanner(),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Recent Discussions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("View All", style: TextStyle(color: AppTheme.doctorPrimary, fontSize: 12)),
                ],
              ),
            ),
            _buildForumPost(
              "Dr. Rahul Sharma",
              "How to handle FMD outbreak in cattle?",
              "I have seen a sudden increase in Foot and Mouth Disease cases in the nearby village. What are the best preventive measures?",
              "2 hours ago",
              12,
              5,
            ),
            _buildForumPost(
              "Dr. Priya Patil",
              "Recommended vaccines for poultry in summer",
              "The heat is affecting the birds. Any specific adjustments to the vaccination schedule for summer months?",
              "5 hours ago",
              8,
              3,
            ),
            _buildForumPost(
              "Dr. Amit Verma",
              "New regulation for dairy farming",
              "Has anyone read the latest government circular regarding animal welfare standards for dairy farms?",
              "1 day ago",
              25,
              10,
            ),
            const SizedBox(height: 40),
            _buildComingSoonCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.doctorPrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.purple.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.forum, color: Colors.purple, size: 32),
          const SizedBox(height: 16),
          const Text(
            "Community Forum",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purple),
          ),
          const SizedBox(height: 8),
          Text(
            "Connect with other veterinarians, share knowledge, and help farmers with their queries.",
            style: TextStyle(color: Colors.purple.shade700, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildForumPost(String author, String title, String snippet, String time, int likes, int comments) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: Text(author[4]), // Dr. [R]ahul
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(snippet, 
            maxLines: 2, 
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          const SizedBox(height: 20),
          Row(
            children: [
              _iconStat(Icons.thumb_up_outlined, likes.toString()),
              const SizedBox(width: 20),
              _iconStat(Icons.chat_bubble_outline, comments.toString()),
              const Spacer(),
              const Icon(Icons.share_outlined, size: 18, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 6),
        Text(value, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }

  Widget _buildComingSoonCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.amber),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("AI Assistant Coming Soon!", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Get instant answers to medical queries from our AI model.", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
