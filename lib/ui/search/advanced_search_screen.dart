
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/custom_appbar.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({Key? key}) : super(key: key);

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  String _selectedCategory = '';
  double _selectedRating = 0.0;
  String _selectedSortBy = 'relevance';
  bool? _inStock;

  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Home & Garden',
    'Sports',
    'Books',
    'Food & Beverages',
  ];

  final List<String> _sortOptions = [
    'relevance',
    'price_low_to_high',
    'price_high_to_low',
    'rating',
    'newest',
    'popularity',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, _) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Advanced Search'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Query
                TextField(
                  controller: _queryController,
                  decoration: const InputDecoration(
                    labelText: 'Search Keywords',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),

                // Search History
                if (searchProvider.searchHistory.isNotEmpty) ...[
                  Text(
                    'Recent Searches',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: searchProvider.searchHistory.length,
                      itemBuilder: (context, index) {
                        final query = searchProvider.searchHistory[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(query),
                            onSelected: (_) {
                              _queryController.text = query;
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Saved Searches
                if (searchProvider.savedSearches.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saved Searches',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton(
                        onPressed: () => _showSavedSearchesDialog(context, searchProvider),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...searchProvider.savedSearches.take(3).map((savedSearch) =>
                    ListTile(
                      leading: const Icon(Icons.bookmark),
                      title: Text(savedSearch.name),
                      subtitle: Text(savedSearch.query),
                      trailing: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () => _applySavedSearch(savedSearch, searchProvider),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Category Filter
                Text(
                  'Category',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCategory.isEmpty ? null : _selectedCategory,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select Category',
                  ),
                  items: _categories.map((category) =>
                    DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value ?? '';
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Price Range
                Text(
                  'Price Range',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Min Price',
                          border: OutlineInputBorder(),
                          prefixText: '\$',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _maxPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Max Price',
                          border: OutlineInputBorder(),
                          prefixText: '\$',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Location
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),

                // Rating Filter
                Text(
                  'Minimum Rating',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _selectedRating,
                        min: 0,
                        max: 5,
                        divisions: 5,
                        label: _selectedRating == 0 ? 'Any' : '${_selectedRating.toInt()}+ stars',
                        onChanged: (value) {
                          setState(() {
                            _selectedRating = value;
                          });
                        },
                      ),
                    ),
                    Text('${_selectedRating.toInt()}+ stars'),
                  ],
                ),
                const SizedBox(height: 16),

                // Stock Filter
                Text(
                  'Availability',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    RadioListTile<bool?>(
                      title: const Text('All Items'),
                      value: null,
                      groupValue: _inStock,
                      onChanged: (value) {
                        setState(() {
                          _inStock = value;
                        });
                      },
                    ),
                    RadioListTile<bool?>(
                      title: const Text('In Stock Only'),
                      value: true,
                      groupValue: _inStock,
                      onChanged: (value) {
                        setState(() {
                          _inStock = value;
                        });
                      },
                    ),
                    RadioListTile<bool?>(
                      title: const Text('Out of Stock'),
                      value: false,
                      groupValue: _inStock,
                      onChanged: (value) {
                        setState(() {
                          _inStock = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Sort By
                Text(
                  'Sort By',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedSortBy,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: _sortOptions.map((option) =>
                    DropdownMenuItem(
                      value: option,
                      child: Text(_getSortDisplayName(option)),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSortBy = value ?? 'relevance';
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _clearFilters,
                        child: const Text('Clear Filters'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _performSearch(context, searchProvider),
                        child: const Text('Search'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Save Search
                if (_queryController.text.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.bookmark_add),
                      label: const Text('Save This Search'),
                      onPressed: () => _showSaveSearchDialog(context, searchProvider),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getSortDisplayName(String option) {
    switch (option) {
      case 'price_low_to_high':
        return 'Price: Low to High';
      case 'price_high_to_low':
        return 'Price: High to Low';
      case 'rating':
        return 'Customer Rating';
      case 'newest':
        return 'Newest First';
      case 'popularity':
        return 'Most Popular';
      default:
        return 'Relevance';
    }
  }

  void _clearFilters() {
    setState(() {
      _queryController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      _locationController.clear();
      _selectedCategory = '';
      _selectedRating = 0.0;
      _selectedSortBy = 'relevance';
      _inStock = null;
    });
  }

  void _performSearch(BuildContext context, SearchProvider searchProvider) {
    final filter = SearchFilter(
      category: _selectedCategory,
      minPrice: double.tryParse(_minPriceController.text),
      maxPrice: double.tryParse(_maxPriceController.text),
      location: _locationController.text.isEmpty ? null : _locationController.text,
      rating: _selectedRating == 0 ? null : _selectedRating,
      sortBy: _selectedSortBy,
      inStock: _inStock,
    );

    searchProvider.updateFilter(filter);
    searchProvider.searchProducts(
      context: context,
      query: _queryController.text,
      filter: filter,
    );

    Navigator.pop(context);
  }

  void _showSaveSearchDialog(BuildContext context, SearchProvider searchProvider) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Search'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Search Name',
            hintText: 'Enter a name for this search',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await searchProvider.saveCurrentSearch(
                  nameController.text,
                  _queryController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Search saved successfully')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSavedSearchesDialog(BuildContext context, SearchProvider searchProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Saved Searches'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: searchProvider.savedSearches.length,
            itemBuilder: (context, index) {
              final savedSearch = searchProvider.savedSearches[index];
              return ListTile(
                title: Text(savedSearch.name),
                subtitle: Text(savedSearch.query),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        Navigator.pop(context);
                        _applySavedSearch(savedSearch, searchProvider);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        searchProvider.removeSavedSearch(savedSearch.id);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _applySavedSearch(SavedSearch savedSearch, SearchProvider searchProvider) {
    setState(() {
      _queryController.text = savedSearch.query;
      _selectedCategory = savedSearch.filter.category;
      _minPriceController.text = savedSearch.filter.minPrice?.toString() ?? '';
      _maxPriceController.text = savedSearch.filter.maxPrice?.toString() ?? '';
      _locationController.text = savedSearch.filter.location ?? '';
      _selectedRating = savedSearch.filter.rating ?? 0.0;
      _selectedSortBy = savedSearch.filter.sortBy ?? 'relevance';
      _inStock = savedSearch.filter.inStock;
    });

    searchProvider.updateFilter(savedSearch.filter);
    searchProvider.searchProducts(
      context: context,
      query: savedSearch.query,
      filter: savedSearch.filter,
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _queryController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
