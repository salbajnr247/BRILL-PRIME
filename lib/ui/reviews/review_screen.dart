
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/review_model.dart';
import '../../providers/review_provider.dart';
import '../../providers/image_upload_provider.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/loading_indicator.dart';

class ReviewScreen extends StatefulWidget {
  final String itemId;
  final String itemType; // 'product' or 'vendor'
  final String itemName;
  const ReviewScreen({
    Key? key, 
    required this.itemId, 
    required this.itemType,
    required this.itemName,
  }) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> with TickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  int _rating = 5;
  List<File> _selectedImages = [];
  bool _isSubmitting = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ReviewProvider>(context, listen: false);
      if (widget.itemType == 'product') {
        provider.fetchProductReviews(context: context, productId: widget.itemId);
      } else {
        provider.fetchVendorReviews(context: context, vendorId: widget.itemId);
      }
      provider.fetchPhotoReviews(
        context: context, 
        itemId: widget.itemId, 
        itemType: widget.itemType
      );
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty && images.length <= 5) {
      setState(() {
        _selectedImages = images.map((xfile) => File(xfile.path)).toList();
      });
    } else if (images.length > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 5 images allowed')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitReview(BuildContext context) async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a review comment')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
      final imageProvider = Provider.of<ImageUploadProvider>(context, listen: false);
      
      List<String>? photoUrls;
      
      // Upload images if selected
      if (_selectedImages.isNotEmpty) {
        final uploadResult = await imageProvider.uploadMultipleImages(
          context: context,
          files: _selectedImages,
        );
        if (uploadResult.isNotEmpty) {
          photoUrls = uploadResult;
        }
      }

      final review = ReviewModel(
        id: '',
        userId: '', // Will be set by backend from auth token
        itemId: widget.itemId,
        itemType: widget.itemType,
        rating: _rating,
        comment: _commentController.text.trim(),
        createdAt: DateTime.now(),
      );

      bool success;
      if (widget.itemType == 'product') {
        success = await reviewProvider.submitProductReview(
          context: context,
          productId: widget.itemId,
          review: review,
          photoUrls: photoUrls,
        );
      } else {
        success = await reviewProvider.submitVendorReview(
          context: context,
          vendorId: widget.itemId,
          review: review,
          photoUrls: photoUrls,
        );
      }

      if (success) {
        _commentController.clear();
        setState(() {
          _rating = 5;
          _selectedImages.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully!')),
        );
      } else if (reviewProvider.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(reviewProvider.errorMessage)),
        );
      }
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Reviews - ${widget.itemName}",
        showBackArrow: true,
      ),
      body: Consumer<ReviewProvider>(
        builder: (context, provider, _) {
          final reviews = widget.itemType == 'product'
              ? provider.productReviews
              : provider.vendorReviews;
          
          final avgRating = provider.getAverageRating(widget.itemId);
          final reviewCount = provider.getReviewCount(widget.itemId);

          return Column(
            children: [
              // Rating Summary
              _buildRatingSummary(avgRating, reviewCount),
              
              // Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.grey600,
                  tabs: const [
                    Tab(text: "Reviews"),
                    Tab(text: "Photos"),
                  ],
                ),
              ),
              
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildReviewsList(provider, reviews),
                    _buildPhotosGrid(provider),
                  ],
                ),
              ),
              
              // Write Review Section
              _buildWriteReviewSection(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRatingSummary(double avgRating, int reviewCount) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                avgRating.toStringAsFixed(1),
                style: TextStyle(
                  fontFamily: FontConstants.montserratBold,
                  fontSize: 32.sp,
                  color: AppColors.primary,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < avgRating.floor() 
                        ? Icons.star 
                        : index < avgRating 
                            ? Icons.star_half 
                            : Icons.star_border,
                    color: Colors.amber,
                    size: 20.sp,
                  );
                }),
              ),
              Text(
                "$reviewCount reviews",
                style: TextStyle(
                  fontFamily: FontConstants.montserratMedium,
                  fontSize: 14.sp,
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              // Scroll to write review section
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Write Review",
              style: TextStyle(
                fontFamily: FontConstants.montserratMedium,
                fontSize: 14.sp,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList(ReviewProvider provider, List<ReviewModel> reviews) {
    if (provider.loading) {
      return const Center(child: LoadingIndicator());
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          provider.errorMessage,
          style: TextStyle(
            fontFamily: FontConstants.montserratMedium,
            fontSize: 16.sp,
            color: AppColors.red,
          ),
        ),
      );
    }

    if (reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 64.sp,
              color: AppColors.grey400,
            ),
            SizedBox(height: 16.h),
            Text(
              "No reviews yet",
              style: TextStyle(
                fontFamily: FontConstants.montserratMedium,
                fontSize: 18.sp,
                color: AppColors.grey600,
              ),
            ),
            Text(
              "Be the first to review this ${widget.itemType}",
              style: TextStyle(
                fontFamily: FontConstants.montserratRegular,
                fontSize: 14.sp,
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return _buildReviewItem(review);
      },
    );
  }

  Widget _buildReviewItem(ReviewModel review) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.primary,
                child: Text(
                  review.userId.isNotEmpty ? review.userId[0].toUpperCase() : 'U',
                  style: TextStyle(
                    fontFamily: FontConstants.montserratBold,
                    fontSize: 16.sp,
                    color: AppColors.white,
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
                          review.createdAt.toString().split(' ')[0],
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
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: AppColors.grey600),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.report, color: AppColors.red, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text('Report'),
                      ],
                    ),
                    onTap: () => _reportReview(review.id),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            review.comment,
            style: TextStyle(
              fontFamily: FontConstants.montserratRegular,
              fontSize: 14.sp,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosGrid(ReviewProvider provider) {
    if (provider.photoReviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64.sp,
              color: AppColors.grey400,
            ),
            SizedBox(height: 16.h),
            Text(
              "No photos yet",
              style: TextStyle(
                fontFamily: FontConstants.montserratMedium,
                fontSize: 18.sp,
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: provider.photoReviews.length,
      itemBuilder: (context, index) {
        final photo = provider.photoReviews[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            photo.url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.grey200,
                child: Icon(
                  Icons.broken_image,
                  color: AppColors.grey500,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildWriteReviewSection(ReviewProvider provider) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Write a Review",
            style: TextStyle(
              fontFamily: FontConstants.montserratSemiBold,
              fontSize: 18.sp,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Rating Selection
          Row(
            children: [
              Text(
                "Rating:",
                style: TextStyle(
                  fontFamily: FontConstants.montserratMedium,
                  fontSize: 16.sp,
                  color: AppColors.black,
                ),
              ),
              SizedBox(width: 12.w),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => _rating = index + 1),
                    child: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 24.sp,
                    ),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Comment Field
          TextField(
            controller: _commentController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Your review',
              hintText: 'Share your experience...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          
          // Photo Selection
          Row(
            children: [
              Text(
                "Photos:",
                style: TextStyle(
                  fontFamily: FontConstants.montserratMedium,
                  fontSize: 16.sp,
                  color: AppColors.black,
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt, color: AppColors.primary, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        "Add Photos",
                        style: TextStyle(
                          fontFamily: FontConstants.montserratMedium,
                          fontSize: 12.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Selected Images Preview
          if (_selectedImages.isNotEmpty) ...[
            SizedBox(height: 12.h),
            SizedBox(
              height: 80.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 8.w),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.file(
                            _selectedImages[index],
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4.h,
                          right: 4.w,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          
          SizedBox(height: 16.h),
          
          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : () => _submitReview(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: _isSubmitting
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                      ),
                    )
                  : Text(
                      "Submit Review",
                      style: TextStyle(
                        fontFamily: FontConstants.montserratSemiBold,
                        fontSize: 16.sp,
                        color: AppColors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _reportReview(String reviewId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Review'),
        content: const Text('Are you sure you want to report this review as inappropriate?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = Provider.of<ReviewProvider>(context, listen: false);
              final success = await provider.reportReview(
                context: context,
                reviewId: reviewId,
                reason: 'Inappropriate content',
              );
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Review reported successfully')),
                );
              }
            },
            child: Text('Report', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }
}
