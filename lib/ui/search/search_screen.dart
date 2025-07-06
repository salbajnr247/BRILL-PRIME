import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _filterController = TextEditingController();
  final TextEditingController _sortController = TextEditingController();
  String _searchType = 'products';

  void _onSearch(BuildContext context) {
    final provider = Provider.of<SearchProvider>(context, listen: false);
    if (_searchType == 'products') {
      provider.searchProducts(
        context: context,
        query: _searchController.text,
        filter: _filterController.text,
        sort: _sortController.text,
      );
    } else {
      provider.searchVendors(
        context: context,
        query: _searchController.text,
        filter: _filterController.text,
        sort: _sortController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Consumer<SearchProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Search')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _onSearch(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _searchType,
                        items: const [
                          DropdownMenuItem(value: 'products', child: Text('Products')),
                          DropdownMenuItem(value: 'vendors', child: Text('Vendors')),
                        ],
                        onChanged: (val) {
                          setState(() => _searchType = val ?? 'products');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _filterController,
                          decoration: const InputDecoration(
                            labelText: 'Filter (optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _sortController,
                          decoration: const InputDecoration(
                            labelText: 'Sort (optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => _onSearch(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (provider.loading)
                    const Center(child: CircularProgressIndicator()),
                  if (!provider.loading && provider.errorMessage.isNotEmpty)
                    Center(child: Text(provider.errorMessage)),
                  if (!provider.loading && provider.errorMessage.isEmpty)
                    Expanded(
                      child: _searchType == 'products'
                          ? (provider.productResults.isEmpty
                              ? const Center(child: Text('No products found.'))
                              : ListView.builder(
                                  itemCount: provider.productResults.length,
                                  itemBuilder: (context, index) {
                                    final product = provider.productResults[index];
                                    return ListTile(
                                      title: Text(product.name ?? 'Unnamed Product'),
                                      subtitle: Text(product.description ?? ''),
                                    );
                                  },
                                ))
                          : (provider.vendorResults.isEmpty
                              ? const Center(child: Text('No vendors found.'))
                              : ListView.builder(
                                  itemCount: provider.vendorResults.length,
                                  itemBuilder: (context, index) {
                                    final vendor = provider.vendorResults[index];
                                    return ListTile(
                                      title: Text(vendor.businessName ?? 'Unnamed Vendor'),
                                      subtitle: Text(vendor.businessCategory ?? ''),
                                    );
                                  },
                                )),
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