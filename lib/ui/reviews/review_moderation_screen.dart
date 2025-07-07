
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/review_model.dart';
import '../../providers/review_provider.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/loading_indicator.dart';

class ReviewModerationScreen extends StatefulWidget {
  const ReviewModerationScreen({super.key});

  @override
  State<ReviewModerationScreen> createState() => _ReviewModerationScreenState();
}

class _ReviewModerationScreenState extends State<ReviewModerationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReviewProvider>(context, listen: false)
          .fetchPendingReviews(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Review Moderation",
        showBackArrow: true,
      ),
      body: Consumer<ReviewProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return const Center(child: LoadingIndicator());
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: AppColors.red,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    provider.errorMessage,
                    style: TextStyle(
                      fontFamily: FontConstants.montserratMedium,
                      fontSize: 16.sp,
                      color: AppColors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (provider.pendingReviews.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64.sp,
                    color: AppColors.green,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "No pending reviews",
                    style: TextStyle(
                      fontFamily: FontConstants.montserratSemiBold,
                      fontSize: 20.sp,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    "All reviews have been moderated",
                    style: TextStyle(
                      fontFamily: FontConstants.montserratRegular,
                      fontSize: 14.sp,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: provider.pendingReviews.length,
            itemBuilder: (context, index) {
              final review = provider.pendingReviews[index];
              return _buildReviewCard(review, provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review, ReviewProvider provider) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey300),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  review.userId.isNotEmpty ? review.userId[0].toUpperCase() : 'U',
                  style: TextStyle(
                    fontFamily: FontConstants.montserratBold,
                    fontSize: 16.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userId.isNotEmpty ? review.userId : 'Anonymous User',
                      style: TextStyle(
                        fontFamily: FontConstants.montserratSemiBold,
                        fontSize: 16.sp,
                        color: AppColors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < review.rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 16.sp,
                            );
                          }),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "${review.itemType} • ${review.createdAt.toString().split(' ')[0]}",
                          style: TextStyle(
                            fontFamily: FontConstants.montserratRegular,
                            fontSize: 12.sp,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "PENDING",
                  style: TextStyle(
                    fontFamily: FontConstants.montserratBold,
                    fontSize: 10.sp,
                    color: AppColors.orange,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          // Review Content
          Text(
            review.comment,
            style: TextStyle(
              fontFamily: FontConstants.montserratRegular,
              fontSize: 14.sp,
              color: AppColors.black,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _moderateReview(review.id, false, provider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    "Reject",
                    style: TextStyle(
                      fontFamily: FontConstants.montserratSemiBold,
                      fontSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _moderateReview(review.id, true, provider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    "Approve",
                    style: TextStyle(
                      fontFamily: FontConstants.montserratSemiBold,
                      fontSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _moderateReview(String reviewId, bool approve, ReviewProvider provider) {
    if (!approve) {
      // Show reason dialog for rejection
      _showRejectReasonDialog(reviewId, provider);
    } else {
      _performModeration(reviewId, approve, null, provider);
    }
  }

  void _showRejectReasonDialog(String reviewId, ReviewProvider provider) {
    final TextEditingController reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reject Review',
          style: TextStyle(
            fontFamily: FontConstants.montserratSemiBold,
            fontSize: 18.sp,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Please provide a reason for rejecting this review:',
              style: TextStyle(
                fontFamily: FontConstants.montserratRegular,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter rejection reason...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.grey600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performModeration(reviewId, false, reasonController.text, provider);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _performModeration(String reviewId, bool approve, String? reason, ReviewProvider provider) async {
    final success = await provider.moderateReview(
      context: context,
      reviewId: reviewId,
      approve: approve,
      reason: reason,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(approve ? 'Review approved' : 'Review rejected'),
          backgroundColor: approve ? AppColors.green : AppColors.red,
        ),
      );
    }
  }
}
