import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/review_model.dart';
import '../../providers/review_provider.dart';

class ReviewScreen extends StatefulWidget {
  final String itemId;
  final String itemType; // 'product' or 'vendor'
  const ReviewScreen({Key? key, required this.itemId, required this.itemType}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _commentController = TextEditingController();
  int _rating = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ReviewProvider>(context, listen: false);
      if (widget.itemType == 'product') {
        provider.fetchProductReviews(context: context, productId: widget.itemId);
      } else {
        provider.fetchVendorReviews(context: context, vendorId: widget.itemId);
      }
    });
  }

  void _submitReview(BuildContext context) async {
    final provider = Provider.of<ReviewProvider>(context, listen: false);
    final review = ReviewModel(
      id: '',
      userId: '', // Set from auth/user context if available
      itemId: widget.itemId,
      itemType: widget.itemType,
      rating: _rating,
      comment: _commentController.text,
      createdAt: DateTime.now(),
    );
    bool success;
    if (widget.itemType == 'product') {
      success = await provider.submitProductReview(
        context: context,
        productId: widget.itemId,
        review: review,
      );
    } else {
      success = await provider.submitVendorReview(
        context: context,
        vendorId: widget.itemId,
        review: review,
      );
    }
    if (success) {
      _commentController.clear();
      setState(() => _rating = 5);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted!')),
      );
    } else if (provider.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReviewProvider(),
      child: Consumer<ReviewProvider>(
        builder: (context, provider, _) {
          final reviews = widget.itemType == 'product'
              ? provider.productReviews
              : provider.vendorReviews;
          final avgRating = reviews.isEmpty
              ? 0.0
              : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
          return Scaffold(
            appBar: AppBar(title: const Text('Reviews')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Average Rating: ${avgRating.toStringAsFixed(1)}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  if (provider.loading)
                    const Center(child: CircularProgressIndicator()),
                  if (!provider.loading && provider.errorMessage.isNotEmpty)
                    Center(child: Text(provider.errorMessage)),
                  if (!provider.loading && provider.errorMessage.isEmpty)
                    Expanded(
                      child: reviews.isEmpty
                          ? const Center(child: Text('No reviews yet.'))
                          : ListView.builder(
                              itemCount: reviews.length,
                              itemBuilder: (context, index) {
                                final review = reviews[index];
                                return ListTile(
                                  leading: CircleAvatar(child: Text('${review.rating}')),
                                  title: Text(review.comment),
                                  subtitle: Text('By ${review.userId} on ${review.createdAt.toLocal()}'),
                                );
                              },
                            ),
                    ),
                  const SizedBox(height: 16),
                  Text('Submit a Review', style: Theme.of(context).textTheme.subtitle1),
                  Row(
                    children: [
                      const Text('Rating:'),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: _rating,
                        items: List.generate(5, (i) => i + 1)
                            .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                            .toList(),
                        onChanged: (val) => setState(() => _rating = val ?? 5),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'Comment',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _submitReview(context),
                    child: const Text('Submit Review'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 