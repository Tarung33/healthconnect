import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// ============================================================
/// SKELETON LOADER — Enhanced perceived performance system
/// ============================================================
/// Multiple skeleton variants for different content types.
/// Dark mode aware, theme-responsive shimmer effects.
/// ============================================================

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// List skeleton for doctor/record lists
class ListSkeleton extends StatelessWidget {
  final int count;
  const ListSkeleton({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              const SkeletonLoader(width: 60, height: 60, borderRadius: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonLoader(width: double.infinity, height: 16),
                    const SizedBox(height: 8),
                    SkeletonLoader(width: MediaQuery.of(context).size.width * 0.5, height: 12),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

/// Card skeleton for dashboard tiles
class CardSkeleton extends StatelessWidget {
  const CardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SkeletonLoader(width: 52, height: 52, borderRadius: 14),
          SizedBox(height: 12),
          SkeletonLoader(width: 80, height: 14),
        ],
      ),
    );
  }
}

/// Profile skeleton
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SkeletonLoader(width: 80, height: 80, borderRadius: 40),
          SizedBox(height: 16),
          SkeletonLoader(width: 150, height: 20),
          SizedBox(height: 8),
          SkeletonLoader(width: 200, height: 14),
          SizedBox(height: 24),
          SkeletonLoader(width: double.infinity, height: 56, borderRadius: 12),
          SizedBox(height: 12),
          SkeletonLoader(width: double.infinity, height: 56, borderRadius: 12),
          SizedBox(height: 12),
          SkeletonLoader(width: double.infinity, height: 56, borderRadius: 12),
        ],
      ),
    );
  }
}

/// Dashboard grid skeleton
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header skeleton
          const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader(width: 120, height: 16),
                    SizedBox(height: 8),
                    SkeletonLoader(width: 180, height: 24),
                  ],
                ),
              ),
              SkeletonLoader(width: 48, height: 48, borderRadius: 24),
            ],
          ),
          const SizedBox(height: 24),
          // Grid skeleton
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.1,
            children: const [
              CardSkeleton(),
              CardSkeleton(),
              CardSkeleton(),
              CardSkeleton(),
            ],
          ),
          const SizedBox(height: 24),
          const SkeletonLoader(width: 160, height: 18),
          const SizedBox(height: 12),
          const SkeletonLoader(width: double.infinity, height: 80, borderRadius: 12),
        ],
      ),
    );
  }
}

/// Doctor card skeleton
class DoctorCardSkeleton extends StatelessWidget {
  const DoctorCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          SkeletonLoader(width: 64, height: 64, borderRadius: 32),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: double.infinity, height: 16),
                SizedBox(height: 6),
                SkeletonLoader(width: 120, height: 12),
                SizedBox(height: 6),
                SkeletonLoader(width: 80, height: 12),
              ],
            ),
          ),
          SizedBox(width: 8),
          SkeletonLoader(width: 70, height: 32, borderRadius: 8),
        ],
      ),
    );
  }
}
