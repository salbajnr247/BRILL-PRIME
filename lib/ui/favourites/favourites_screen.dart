import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/favourite_model.dart';
import '../../providers/favourites_provider.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavouritesProvider()..fetchFavourites(context: context),
      child: Consumer<FavouritesProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('My Favourites'),
            ),
            body: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.errorMessage.isNotEmpty
                    ? Center(child: Text(provider.errorMessage))
                    : provider.favourites.isEmpty
                        ? const Center(child: Text('No favourites yet.'))
                        : ListView.builder(
                            itemCount: provider.favourites.length,
                            itemBuilder: (context, index) {
                              final fav = provider.favourites[index];
                              return ListTile(
                                title: Text('${fav.itemType} - ${fav.itemId}'),
                                subtitle: Text('Added: ${fav.createdAt.toLocal()}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final removed = await provider.removeFavourite(
                                      context: context,
                                      favouriteId: fav.id,
                                    );
                                    if (removed) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Removed from favourites.')),
                                      );
                                    } else if (provider.errorMessage.isNotEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(provider.errorMessage)),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
          );
        },
      ),
    );
  }
} 