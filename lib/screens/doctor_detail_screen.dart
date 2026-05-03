import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animal1/l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../services/session.dart';
import '../theme/app_theme.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/lookup_service.dart';

import '../widgets/star_rating_widget.dart';

class DoctorDetailScreen extends StatefulWidget {
  final Map doctor;
  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  late Map currentDoctor;
  bool isRefreshing = false;
  List reviews = [];
  bool isLoadingReviews = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    currentDoctor = widget.doctor;
    _refreshDoctorData();
    _loadReviews();
    _timer = Timer.periodic(const Duration(seconds: 5), (t) => _refreshDoctorData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refreshDoctorData() async {
    if (currentDoctor['email'] == null) return;
    final freshData = await ApiService.getProviderProfile(currentDoctor['email']);
    if (freshData != null && mounted) {
      setState(() {
        currentDoctor = freshData;
      });
    }
  }

  Future<void> _loadReviews() async {
    if (currentDoctor['id'] == null) return;
    final data = await ApiService.getProviderReviews(currentDoctor['id']);
    if (mounted) {
      setState(() {
        reviews = data;
        isLoadingReviews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: RefreshIndicator(
        onRefresh: _refreshDoctorData,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    _buildAbout(),
                    const SizedBox(height: 32),
                    _buildClinicDetails(),
                    const SizedBox(height: 32),
                    _buildStats(),
                    const SizedBox(height: 32),
                    _buildReviews(),
                    const SizedBox(height: 40),
                    _buildActionButtons(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(currentDoctor['name'], style: const TextStyle(color: Colors.white, fontSize: 16)),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
            ),
          ),
          child: const Center(
            child: Icon(Icons.person, size: 80, color: Colors.white24),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentDoctor['name'], style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28)),
                  Text(currentDoctor['specialization'] ?? AppLocalizations.of(context)!.veterinarySpecialist, 
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(currentDoctor['doctorType'] ?? "PRIVATE", 
                style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            StarRatingWidget(rating: (currentDoctor['avgRating'] ?? 0.0).toDouble(), size: 20),
            const SizedBox(width: 8),
            Text("(${AppLocalizations.of(context)!.nReviews(currentDoctor['totalReviews'] ?? 0)})", 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ],
    );
  }

  Widget _buildReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.reviews, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (reviews.isNotEmpty)
              Text("${reviews.length} ${AppLocalizations.of(context)!.total}", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 16),
        if (isLoadingReviews)
          const Center(child: CircularProgressIndicator())
        else if (reviews.isEmpty)
          Center(
            child: Text("No reviews yet", style: TextStyle(color: Colors.grey.shade400)),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length > 3 ? 3 : reviews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _reviewCard(reviews[index]),
          ),
      ],
    );
  }

  Widget _reviewCard(Map r) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(r['reviewerName'] ?? "Anonymous", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              StarRatingWidget(rating: (r['rating'] ?? 0).toDouble(), size: 12, showText: false),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            r['comment'] ?? "",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildAbout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.aboutDoctor, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(
          currentDoctor['description'] ?? AppLocalizations.of(context)!.noBioProvided,
          style: TextStyle(color: Colors.grey.shade700, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildClinicDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _infoTile(Icons.storefront_outlined, AppLocalizations.of(context)!.clinicName, currentDoctor['clinicName'] ?? "Clinic"),
          const Divider(height: 32),
          _infoTile(Icons.location_on_outlined, AppLocalizations.of(context)!.location, currentDoctor['district'] ?? AppLocalizations.of(context)!.notSet),
          const Divider(height: 32),
          _infoTile(Icons.access_time, AppLocalizations.of(context)!.workingHours, currentDoctor['workingHours'] ?? AppLocalizations.of(context)!.notSet),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statItem("1,200+", AppLocalizations.of(context)!.patients),
        _statItem("10 Years", AppLocalizations.of(context)!.experience),
        _statItem("${currentDoctor['avgRating'] ?? 0.0}/5", AppLocalizations.of(context)!.rating),
      ],
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _bookAppointment(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(AppLocalizations.of(context)!.bookAppointment, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => launchUrl(Uri.parse("tel:${currentDoctor['phone'] ?? '9999999999'}")),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
            ),
            child: const Icon(Icons.call, color: AppTheme.primaryColor),
          ),
        ),
      ],
    );
  }

  void _bookAppointment(BuildContext context) async {
    final user = Session.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.pleaseLoginToBook)));
      return;
    }

    String? selectedService = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text("Select Service"),
        children: lookup.services.map((s) => SimpleDialogOption(
          onPressed: () => Navigator.pop(ctx, s),
          child: Text(s),
        )).toList(),
      ),
    );

    if (selectedService == null) return;

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      helpText: AppLocalizations.of(context)!.selectAppointmentDate,
    );

    if (selectedDate == null) return;

    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      helpText: AppLocalizations.of(context)!.selectAppointmentTime,
    );

    if (selectedTime == null) return;

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final dateStr = selectedDate.toString().split(' ')[0];
    final timeStr = "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')} ${selectedTime.period == DayPeriod.am ? 'AM' : 'PM'}";

    await ApiService.createBooking(
      user['email'], 
      selectedService,
      providerEmail: currentDoctor['email'],
      date: dateStr,
      time: timeStr,
    );
    
    if (context.mounted) {
      Navigator.pop(context); // Close loading
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.appointmentRequested, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.requestSentTo(currentDoctor['name'])),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        ),
      );
    }
  }
}
