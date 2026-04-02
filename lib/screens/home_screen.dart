import 'package:ai_hairstyle_preview_app/models/hairstyle_model.dart';
import 'package:ai_hairstyle_preview_app/screens/upload_screen.dart';
import 'package:ai_hairstyle_preview_app/widgets/hairstyle_card.dart';
import 'package:ai_hairstyle_preview_app/screens/profile_screen.dart';
import 'package:ai_hairstyle_preview_app/screens/history_screen.dart';
import 'package:ai_hairstyle_preview_app/services/auth_service.dart';
import 'package:ai_hairstyle_preview_app/utils/design_system.dart';
import 'package:ai_hairstyle_preview_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:ai_hairstyle_preview_app/widgets/ai_style_insight_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HairstyleDashboard(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          selectedIndex: _selectedIndex,
          height: 70,
          elevation: 0,
          backgroundColor: Theme.of(context).cardTheme.color,
          indicatorColor: DesignSystem.primaryGradientStart.withValues(alpha: 0.1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined, size: 24),
              selectedIcon: Icon(Icons.grid_view_rounded, color: DesignSystem.primaryGradientStart),
              label: 'Styles',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined, size: 24),
              selectedIcon: Icon(Icons.history_rounded, color: DesignSystem.primaryGradientStart),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, size: 24),
              selectedIcon: Icon(Icons.person_rounded, color: DesignSystem.primaryGradientStart),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class HairstyleDashboard extends ConsumerStatefulWidget {
  const HairstyleDashboard({super.key});

  @override
  ConsumerState<HairstyleDashboard> createState() => _HairstyleDashboardState();
}

class _HairstyleDashboardState extends ConsumerState<HairstyleDashboard> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['All', 'Male', 'Female', 'Trending', 'Popular'];

  List<HairstyleModel> _getFilteredHairstyles() {
    return sampleHairstyles.where((style) {
      bool matchesCategory = false;
      if (_selectedCategory == 'All') {
        matchesCategory = true;
      } else if (_selectedCategory == 'Trending') {
        matchesCategory = style.isTrending;
      } else if (_selectedCategory == 'Popular') {
        matchesCategory = style.isPopular;
      } else {
        matchesCategory = style.gender == _selectedCategory.toLowerCase();
      }
      
      final matchesSearch = style.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(authServiceProvider).currentUser;
    final userName = user?.displayName?.split(' ').first ?? 'Guest';
    final hairstyles = _getFilteredHairstyles();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            DesignSystem.primaryGradientStart.withValues(alpha: 0.05),
            theme.scaffoldBackgroundColor,
          ],
        ),
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $userName 👋',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Find your perfect style today',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: StyleCard(
                padding: EdgeInsets.zero,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search hairstyles...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = category);
                    },
                    selectedColor: DesignSystem.primaryGradientStart.withValues(alpha: 0.1),
                    backgroundColor: theme.cardTheme.color,
                    labelStyle: TextStyle(
                      color: isSelected ? DesignSystem.primaryGradientStart : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? DesignSystem.primaryGradientStart : Colors.transparent,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    showCheckmark: false,
                  );
                },
              ),
            ),
          ),

          if (_selectedCategory == 'All' && _searchQuery.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: AIStyleInsightCard(),
              ),
            ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final style = hairstyles[index];
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: HairstyleCard(
                      key: ValueKey('${_selectedCategory}_${style.id}'),
                      hairstyle: style,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UploadScreen(selectedHairstyle: style),
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: hairstyles.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }
}
