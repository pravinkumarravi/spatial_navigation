import 'package:flutter/material.dart';
import 'package:spatial_navigation/spatial_navigation.dart';

void main() {
  runApp(const SpatialNavigationDemoApp());
}

class SpatialNavigationDemoApp extends StatelessWidget {
  const SpatialNavigationDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spatial Navigation TV Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF07080B),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          surface: Color(0xFF13151D),
        ),
      ),
      home: const TvDemoHomePage(),
    );
  }
}

// ---------------------------------------------------------------------------
// Mock Data Models
// ---------------------------------------------------------------------------
class MediaItem {
  final String id;
  final String title;
  final String category;
  final String year;
  final String certification;
  final String genre;
  final String provider;
  final String description;
  final List<Color> gradient;

  const MediaItem({
    required this.id,
    required this.title,
    required this.category,
    required this.year,
    required this.certification,
    required this.genre,
    required this.provider,
    required this.description,
    required this.gradient,
  });
}

class ChannelItem {
  final String id;
  final String name;
  final String category;
  final String currentProgram;
  final String timeRemaining;
  final Color logoColor;

  const ChannelItem({
    required this.id,
    required this.name,
    required this.category,
    required this.currentProgram,
    required this.timeRemaining,
    required this.logoColor,
  });
}

// ---------------------------------------------------------------------------
// Mock Database (Generic Demo Boxes & Cards)
// ---------------------------------------------------------------------------
final List<MediaItem> heroCarousel = [
  const MediaItem(
    id: 'hero_item_1',
    title: 'Featured Demo Item Alpha',
    category: 'Sci-Fi Action',
    year: '2024',
    certification: 'PG-13',
    genre: 'Sci-Fi | English | 2024 | PG-13',
    provider: 'Channel Alpha',
    description:
        'A futuristic exploration showcasing high-performance 2D spatial navigation for Android TV remotes and D-Pad input devices.',
    gradient: [Color(0xFF312E81), Color(0xFF1E1B4B), Color(0xFF0F0E2A)],
  ),
  const MediaItem(
    id: 'hero_item_2',
    title: 'Featured Demo Item Beta',
    category: 'Action Thriller',
    year: '2024',
    certification: 'TV-MA',
    genre: 'Action | 2024 | TV-MA',
    provider: 'Channel Beta',
    description:
        'Seamless D-Pad navigation across horizontal card shelves, sidebar menus, and interactive modal dialog overlays.',
    gradient: [Color(0xFF831843), Color(0xFF500724), Color(0xFF1F020E)],
  ),
  const MediaItem(
    id: 'hero_item_3',
    title: 'Featured Demo Item Gamma',
    category: 'Adventure',
    year: '2024',
    certification: 'PG',
    genre: 'Adventure | 2024 | PG',
    provider: 'Channel Gamma',
    description:
        'Configurable focus boundaries, modal isolation, and real-time visual spatial debugging overlay.',
    gradient: [Color(0xFF064E3B), Color(0xFF022C22), Color(0xFF01140F)],
  ),
];

final List<MediaItem> whatsNewItems = [
  const MediaItem(
    id: 'wn_item_1',
    title: 'Content Tile #1',
    category: 'Action',
    year: '2024',
    certification: 'PG-13',
    genre: 'Action | 2024',
    provider: 'Stream 1',
    description: 'Sample content box demonstration for spatial navigation card shelves.',
    gradient: [Color(0xFF3B1808), Color(0xFF1A0A03), Color(0xFF0D0501)],
  ),
  const MediaItem(
    id: 'wn_item_2',
    title: 'Content Tile #2',
    category: 'Epic',
    year: '2023',
    certification: 'PG-13',
    genre: 'Drama | 2023',
    provider: 'Stream 2',
    description: 'Sample content box demonstration for spatial navigation card shelves.',
    gradient: [Color(0xFF78350F), Color(0xFF451A03), Color(0xFF1C0A00)],
  ),
  const MediaItem(
    id: 'wn_item_3',
    title: 'Content Tile #3',
    category: 'Comedy',
    year: '2024',
    certification: 'PG',
    genre: 'Comedy | 2024',
    provider: 'Stream 3',
    description: 'Sample content box demonstration for spatial navigation card shelves.',
    gradient: [Color(0xFF064E3B), Color(0xFF022C22), Color(0xFF01140F)],
  ),
  const MediaItem(
    id: 'wn_item_4',
    title: 'Content Tile #4',
    category: 'Thriller',
    year: '2024',
    certification: 'TV-MA',
    genre: 'Thriller | 2024',
    provider: 'Stream 4',
    description: 'Sample content box demonstration for spatial navigation card shelves.',
    gradient: [Color(0xFF1E3A8A), Color(0xFF0F172A), Color(0xFF020617)],
  ),
  const MediaItem(
    id: 'wn_item_5',
    title: 'Content Tile #5',
    category: 'Romance',
    year: '2023',
    certification: 'PG-13',
    genre: 'Romance | 2023',
    provider: 'Stream 5',
    description: 'Sample content box demonstration for spatial navigation card shelves.',
    gradient: [Color(0xFF831843), Color(0xFF500724), Color(0xFF1F020E)],
  ),
];

final List<MediaItem> trendingNowItems = [
  const MediaItem(
    id: 'tr_item_1',
    title: 'Trending Box #1',
    category: 'Action',
    year: '2024',
    certification: 'PG-13',
    genre: 'Action | 2024',
    provider: 'Provider 1',
    description: 'Trending media item demonstration for TV D-Pad focus controls.',
    gradient: [Color(0xFF7C2D12), Color(0xFF431407), Color(0xFF1C0802)],
  ),
  const MediaItem(
    id: 'tr_item_2',
    title: 'Trending Box #2',
    category: 'Thriller',
    year: '2024',
    certification: 'TV-MA',
    genre: 'Thriller | 2024',
    provider: 'Provider 2',
    description: 'Trending media item demonstration for TV D-Pad focus controls.',
    gradient: [Color(0xFF713F12), Color(0xFF3F2206), Color(0xFF1A0E02)],
  ),
  const MediaItem(
    id: 'tr_item_3',
    title: 'Trending Box #3',
    category: 'Sci-Fi',
    year: '2024',
    certification: 'PG-13',
    genre: 'Sci-Fi | 2024',
    provider: 'Provider 3',
    description: 'Trending media item demonstration for TV D-Pad focus controls.',
    gradient: [Color(0xFF0369A1), Color(0xFF075985), Color(0xFF082F49)],
  ),
  const MediaItem(
    id: 'tr_item_4',
    title: 'Trending Box #4',
    category: 'Drama',
    year: '2024',
    certification: 'TV-MA',
    genre: 'Drama | 2024',
    provider: 'Provider 4',
    description: 'Trending media item demonstration for TV D-Pad focus controls.',
    gradient: [Color(0xFF7F1D1D), Color(0xFF450A0A), Color(0xFF1C0303)],
  ),
];

final List<ChannelItem> liveChannels = [
  const ChannelItem(
    id: 'ch_channel_1',
    name: 'Channel 1 HD',
    category: 'Entertainment',
    currentProgram: 'Program Broadcast A',
    timeRemaining: '20m left',
    logoColor: Color(0xFFE11D48),
  ),
  const ChannelItem(
    id: 'ch_channel_2',
    name: 'Channel 2 HD',
    category: 'General',
    currentProgram: 'Program Broadcast B',
    timeRemaining: '45m left',
    logoColor: Color(0xFF0284C7),
  ),
  const ChannelItem(
    id: 'ch_channel_3',
    name: 'Channel 3 HD',
    category: 'Movies',
    currentProgram: 'Program Broadcast C',
    timeRemaining: '15m left',
    logoColor: Color(0xFF9333EA),
  ),
  const ChannelItem(
    id: 'ch_channel_4',
    name: 'Channel 4 HD',
    category: 'News',
    currentProgram: 'Live News Broadcast',
    timeRemaining: 'LIVE',
    logoColor: Color(0xFFDC2626),
  ),
  const ChannelItem(
    id: 'ch_channel_5',
    name: 'Channel 5 HD',
    category: 'Sports',
    currentProgram: 'Live Sports Event',
    timeRemaining: 'LIVE',
    logoColor: Color(0xFF16A34A),
  ),
  const ChannelItem(
    id: 'ch_channel_6',
    name: 'Channel 6 HD',
    category: 'Documentary',
    currentProgram: 'Nature & Wildlife Special',
    timeRemaining: '30m left',
    logoColor: Color(0xFF0D9488),
  ),
];

// ---------------------------------------------------------------------------
// Main TV Home Page
// ---------------------------------------------------------------------------
class TvDemoHomePage extends StatefulWidget {
  const TvDemoHomePage({super.key});

  @override
  State<TvDemoHomePage> createState() => _TvDemoHomePageState();
}

class _TvDemoHomePageState extends State<TvDemoHomePage> {
  late final SpatialNavigationController _navigationController;
  final ScrollController _mainScrollController = ScrollController();

  int _selectedCategoryIndex = 0;
  int _heroIndex = 0;
  bool _debugOverlayEnabled = false;
  MediaItem? _selectedMedia;
  ChannelItem? _selectedChannel;

  final List<String> _categories = [
    'Home',
    'Channels',
    'Movies',
    'Shows',
    'Categories',
    'Favorites',
    'Settings',
  ];

  @override
  void initState() {
    super.initState();
    _navigationController = SpatialNavigationController();
  }

  @override
  void dispose() {
    _navigationController.dispose();
    _mainScrollController.dispose();
    super.dispose();
  }

  void _openMediaDetail(MediaItem item) {
    setState(() {
      _selectedMedia = item;
      _selectedChannel = null;
    });
    _navigationController.showModal('detail_modal_scope');
  }

  void _openChannelDetail(ChannelItem channel) {
    setState(() {
      _selectedChannel = channel;
      _selectedMedia = null;
    });
    _navigationController.showModal('detail_modal_scope');
  }

  void _closeModal() {
    _navigationController.hideModal('detail_modal_scope');
    setState(() {
      _selectedMedia = null;
      _selectedChannel = null;
    });
  }

  void _scrollToTop() {
    if (_mainScrollController.hasClients) {
      _mainScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentHero = heroCarousel[_heroIndex];

    return TvNavigationListener(
      controller: _navigationController,
      onBack: () {
        if (_navigationController.scope.hasModal) {
          _closeModal();
        }
      },
      child: SpatialNavigationDebugger(
        controller: _navigationController,
        enabled: _debugOverlayEnabled,
        child: Scaffold(
          backgroundColor: const Color(0xFF07080B),
          body: Stack(
            children: [
              // Atmospheric Background Gradient
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.75, -0.4),
                      radius: 1.2,
                      colors: [
                        currentHero.gradient[0],
                        currentHero.gradient[1],
                        const Color(0xFF07080B),
                      ],
                      stops: const [0.0, 0.5, 0.95],
                    ),
                  ),
                ),
              ),

              // Vignette overlay
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFA07080B),
                        Color(0xB307080B),
                        Color(0x3307080B),
                      ],
                      stops: [0.0, 0.45, 0.9],
                    ),
                  ),
                ),
              ),

              // Main Application Scope
              TvNavigationScope(
                controller: _navigationController,
                groupId: 'demo_root',
                preferredEntryNodeId: 'hero_btn_play',
                child: SingleChildScrollView(
                  controller: _mainScrollController,
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 18),

                      // Top App Header Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        child: TvNavigationScope(
                          controller: _navigationController,
                          groupId: 'scope_header',
                          autoFocus: false,
                          boundaries: const NavigationBoundaries(
                            canExitLeft: false,
                            canExitRight: false,
                            canExitUp: false,
                            canExitDown: true,
                            nextGroupDown: 'scope_hero',
                          ),
                          child: _buildTopHeaderBar(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Hero Content Banner Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 44),
                        child: TvNavigationScope(
                          controller: _navigationController,
                          groupId: 'scope_hero',
                          autoFocus: true,
                          preferredEntryNodeId: 'hero_btn_play',
                          boundaries: const NavigationBoundaries(
                            canExitLeft: false,
                            canExitRight: false,
                            canExitUp: true,
                            canExitDown: true,
                            nextGroupUp: 'scope_header',
                            nextGroupDown: 'scope_whats_new',
                          ),
                          child: _buildHeroContent(currentHero),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Shelf 1: "What's New" Poster Card Rail
                      _buildShelfHeader("What's New"),
                      const SizedBox(height: 12),
                      TvNavigationScope(
                        controller: _navigationController,
                        groupId: 'scope_whats_new',
                        autoFocus: false,
                        preferredEntryNodeId: 'wn_card_0',
                        boundaries: const NavigationBoundaries(
                          canExitLeft: false,
                          canExitRight: false,
                          canExitUp: true,
                          canExitDown: true,
                          nextGroupUp: 'scope_hero',
                          nextGroupDown: 'scope_live_channels',
                        ),
                        child: _buildMediaShelf('wn_card', whatsNewItems),
                      ),

                      const SizedBox(height: 32),

                      // Shelf 2: "Live TV Channels" EPG Rail
                      _buildShelfHeader("Live Channels"),
                      const SizedBox(height: 12),
                      TvNavigationScope(
                        controller: _navigationController,
                        groupId: 'scope_live_channels',
                        autoFocus: false,
                        preferredEntryNodeId: 'ch_card_0',
                        boundaries: const NavigationBoundaries(
                          canExitLeft: false,
                          canExitRight: false,
                          canExitUp: true,
                          canExitDown: true,
                          nextGroupUp: 'scope_whats_new',
                          nextGroupDown: 'scope_trending',
                        ),
                        child: _buildLiveChannelShelf(liveChannels),
                      ),

                      const SizedBox(height: 32),

                      // Shelf 3: "Trending Now" Poster Card Rail
                      _buildShelfHeader("Trending Content"),
                      const SizedBox(height: 12),
                      TvNavigationScope(
                        controller: _navigationController,
                        groupId: 'scope_trending',
                        autoFocus: false,
                        preferredEntryNodeId: 'tr_card_0',
                        boundaries: const NavigationBoundaries(
                          canExitLeft: false,
                          canExitRight: false,
                          canExitUp: true,
                          canExitDown: false,
                          nextGroupUp: 'scope_live_channels',
                        ),
                        child: _buildMediaShelf('tr_card', trendingNowItems),
                      ),
                    ],
                  ),
                ),
              ),

              // Detail Modal Overlay Scope
              if (_selectedMedia != null || _selectedChannel != null)
                _buildDetailModalOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShelfHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeaderBar() {
    return Row(
      children: [
        // App Logo Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: const [
              Icon(Icons.tv_rounded, color: Colors.white, size: 22),
              SizedBox(width: 8),
              Text(
                'SPATIAL TV',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 32),

        // Navigation Tabs Bar
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_categories.length, (index) {
                final catId = 'header_tab_$index';
                final isSelected = _selectedCategoryIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: TvFocusable(
                    id: catId,
                    groupId: 'scope_header',
                    focusBuilder: (context, child, isFocused) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isFocused
                              ? const Color(0xFF6366F1)
                              : (isSelected ? Colors.white12 : Colors.transparent),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isFocused ? Colors.white : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: isFocused
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF6366F1).withValues(alpha: 0.5),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            color: isFocused || isSelected ? Colors.white : Colors.white60,
                            fontSize: 14,
                            fontWeight: isFocused || isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                        _scrollToTop();
                      },
                      child: const SizedBox(),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),

        // Search & Debugger Buttons
        TvFocusable(
          id: 'btn_toggle_debug',
          groupId: 'scope_header',
          focusBuilder: (context, child, isFocused) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isFocused
                    ? const Color(0xFF6366F1)
                    : (_debugOverlayEnabled ? Colors.indigo.shade900 : const Color(0xFF1E212D)),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isFocused ? Colors.white : Colors.white24,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.bug_report_rounded,
                    color: isFocused ? Colors.white : Colors.white70,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _debugOverlayEnabled ? 'Debug: ON' : 'Debug: OFF',
                    style: TextStyle(
                      color: isFocused ? Colors.white : Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
          child: GestureDetector(
            onTap: () {
              setState(() {
                _debugOverlayEnabled = !_debugOverlayEnabled;
              });
            },
            child: const SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroContent(MediaItem item) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            item.gradient[0].withValues(alpha: 0.8),
            item.gradient[1].withValues(alpha: 0.6),
            Colors.transparent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.provider.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.genre,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      TvFocusable(
                        id: 'hero_btn_play',
                        groupId: 'scope_hero',
                        focusBuilder: (context, child, isFocused) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: isFocused ? const Color(0xFF6366F1) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: isFocused
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF6366F1).withValues(alpha: 0.6),
                                        blurRadius: 18,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.play_arrow_rounded,
                                  color: isFocused ? Colors.white : Colors.black,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Play Now',
                                  style: TextStyle(
                                    color: isFocused ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: GestureDetector(
                          onTap: () => _openMediaDetail(item),
                          child: const SizedBox(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TvFocusable(
                        id: 'hero_btn_next',
                        groupId: 'scope_hero',
                        focusBuilder: (context, child, isFocused) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: isFocused ? Colors.white24 : Colors.white10,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isFocused ? Colors.white : Colors.white24,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.skip_next_rounded, color: Colors.white),
                                SizedBox(width: 6),
                                Text('Next Hero', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _heroIndex = (_heroIndex + 1) % heroCarousel.length;
                            });
                          },
                          child: const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaShelf(String prefix, List<MediaItem> items) {
    return SizedBox(
      height: 200,
      child: TvScrollableRow(
        groupId: 'scope_$prefix',
        pivotFraction: 0.25,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final cardId = '${prefix}_$index';

          return Container(
            margin: const EdgeInsets.only(left: 44, right: 0),
            child: TvFocusable(
              id: cardId,
              groupId: 'scope_$prefix',
              focusBuilder: (context, child, isFocused) {
                return AnimatedScale(
                  scale: isFocused ? 1.06 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  child: Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: item.gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isFocused ? Colors.white : Colors.white12,
                        width: isFocused ? 3 : 1,
                      ),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.5),
                                blurRadius: 20,
                                spreadRadius: 3,
                              ),
                            ]
                          : [],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.movie_rounded,
                            color: isFocused ? Colors.white : Colors.white54,
                            size: 32,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.category,
                            style: const TextStyle(color: Colors.white60, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: GestureDetector(
                onTap: () => _openMediaDetail(item),
                child: const SizedBox(),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLiveChannelShelf(List<ChannelItem> channels) {
    return SizedBox(
      height: 140,
      child: TvScrollableRow(
        groupId: 'scope_live_channels',
        pivotFraction: 0.25,
        children: List.generate(channels.length, (index) {
          final channel = channels[index];
          final cardId = 'ch_card_$index';

          return Container(
            margin: const EdgeInsets.only(left: 44, right: 0),
            child: TvFocusable(
              id: cardId,
              groupId: 'scope_live_channels',
              focusBuilder: (context, child, isFocused) {
                return AnimatedScale(
                  scale: isFocused ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  child: Container(
                    width: 220,
                    height: 140,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13151D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isFocused ? Colors.white : Colors.white12,
                        width: isFocused ? 3 : 1,
                      ),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: channel.logoColor.withValues(alpha: 0.5),
                                blurRadius: 18,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: channel.logoColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.live_tv_rounded, color: Colors.white, size: 18),
                            ),
                            Text(
                              channel.timeRemaining,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          channel.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          channel.currentProgram,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: GestureDetector(
                onTap: () => _openChannelDetail(channel),
                child: const SizedBox(),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDetailModalOverlay() {
    final title = _selectedMedia?.title ?? _selectedChannel?.name ?? 'Media Item';
    final desc = _selectedMedia?.description ?? _selectedChannel?.currentProgram ?? '';

    return Positioned.fill(
      child: Container(
        color: Colors.black87,
        child: Center(
          child: TvNavigationScope(
            controller: _navigationController,
            groupId: 'detail_modal_scope',
            isModal: true,
            preferredEntryNodeId: 'modal_btn_play',
            child: Container(
              width: 520,
              padding: const EdgeInsets.all(36),
              decoration: BoxDecoration(
                color: const Color(0xFF1E212D),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF6366F1), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.movie_filter_rounded, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    desc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TvFocusable(
                        id: 'modal_btn_play',
                        groupId: 'detail_modal_scope',
                        focusBuilder: (context, child, isFocused) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            decoration: BoxDecoration(
                              color: isFocused ? const Color(0xFF6366F1) : Colors.white10,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isFocused ? Colors.white : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: const Text(
                              'Start Playback',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                        child: const SizedBox(),
                      ),
                      const SizedBox(width: 16),
                      TvFocusable(
                        id: 'modal_btn_close',
                        groupId: 'detail_modal_scope',
                        focusBuilder: (context, child, isFocused) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            decoration: BoxDecoration(
                              color: isFocused ? Colors.white24 : Colors.white10,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isFocused ? Colors.white : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: const Text('Close Modal', style: TextStyle(color: Colors.white)),
                          );
                        },
                        child: GestureDetector(
                          onTap: _closeModal,
                          child: const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
