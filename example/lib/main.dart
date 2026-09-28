import 'package:flutter/material.dart';
import 'package:spatial_navigation/spatial_navigation.dart';

void main() {
  runApp(const JioTvApp());
}

class JioTvApp extends StatelessWidget {
  const JioTvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JioTV+ Spatial Navigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF07080B),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE50914),
          surface: Color(0xFF13151D),
        ),
      ),
      home: const JioTvHomePage(),
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
// Mock Database (Matching user reference image)
// ---------------------------------------------------------------------------
final List<MediaItem> heroCarousel = [
  const MediaItem(
    id: 'hero_tomorrow_war',
    title: 'The Tomorrow War',
    category: 'Drama',
    year: '2023',
    certification: 'U/A 13+',
    genre: 'Drama | English | 2023 | U/A 13+',
    provider: 'Prime Video',
    description:
        'After the defeat of the Empire at the hands of Rebel forces, a lone bounty hunter operating in the Outer Rim, away from the dom...',
    gradient: [Color(0xFF1E293B), Color(0xFF0F172A), Color(0xFF020617)],
  ),
  const MediaItem(
    id: 'hero_jawan',
    title: 'Jawan',
    category: 'Action Thriller',
    year: '2023',
    certification: 'U/A 16+',
    genre: 'Action | Hindi | 2023 | U/A 16+',
    provider: 'Netflix',
    description:
        'A high-octane action thriller outlining the emotional journey of a man who is set to rectify the wrongs in society against formidable odds.',
    gradient: [Color(0xFF3F0713), Color(0xFF1F0309), Color(0xFF0A0103)],
  ),
  const MediaItem(
    id: 'hero_farzi',
    title: 'Farzi',
    category: 'Crime Thriller',
    year: '2023',
    certification: 'A 18+',
    genre: 'Crime | Hindi | 2023 | A 18+',
    provider: 'Prime Video',
    description:
        'A brilliant small-time artist gets pulled into the murky high-stakes con job of counterfeiting currency and is pursued by a fiery task force officer.',
    gradient: [Color(0xFF2E1065), Color(0xFF0F0728), Color(0xFF05020F)],
  ),
];

final List<MediaItem> whatsNewItems = [
  const MediaItem(
    id: 'wn_bholaa',
    title: 'BHOLAA',
    category: 'Action Thriller',
    year: '2023',
    certification: 'U/A 16+',
    genre: 'Action | Hindi | 2023',
    provider: 'JioCinema',
    description: 'An ex-convict journeys home to meet his young daughter after 10 years, facing a gauntlet of lethal obstacles.',
    gradient: [Color(0xFF3B1808), Color(0xFF1A0A03), Color(0xFF0D0501)],
  ),
  const MediaItem(
    id: 'wn_baahubali2',
    title: 'Baahubali 2',
    category: 'Epic Action',
    year: '2017',
    certification: 'U/A 13+',
    genre: 'Action | Telugu | 2017',
    provider: 'Hotstar',
    description: 'When Shiva discovers his royal heritage, he embarks on an epic quest to avenge his father and free his mother.',
    gradient: [Color(0xFF78350F), Color(0xFF451A03), Color(0xFF1C0A00)],
  ),
  const MediaItem(
    id: 'wn_dasvi',
    title: 'दसवीं (Dasvi)',
    category: 'Social Comedy',
    year: '2022',
    certification: 'U/A 13+',
    genre: 'Comedy | Hindi | 2022',
    provider: 'JioCinema',
    description: 'An uneducated politician decides to spend his prison sentence studying for his high school 10th grade exam.',
    gradient: [Color(0xFF064E3B), Color(0xFF022C22), Color(0xFF01140F)],
  ),
  const MediaItem(
    id: 'wn_spy',
    title: 'SPY',
    category: 'Espionage',
    year: '2023',
    certification: 'U/A 16+',
    genre: 'Thriller | Telugu | 2023',
    provider: 'Prime Video',
    description: 'A RAW agent embarks on a secret mission to stop a nuclear disaster while uncovering secrets regarding Netaji Subhash Chandra Bose.',
    gradient: [Color(0xFF1E3A8A), Color(0xFF0F172A), Color(0xFF020617)],
  ),
  const MediaItem(
    id: 'wn_bawaal',
    title: 'BAWAAL',
    category: 'Romantic Drama',
    year: '2023',
    certification: 'U/A 13+',
    genre: 'Drama | Hindi | 2023',
    provider: 'Prime Video',
    description: 'A history teacher and his new bride travel across Europe, experiencing World War II sites that mirror their relationship troubles.',
    gradient: [Color(0xFF831843), Color(0xFF500724), Color(0xFF1F020E)],
  ),
  const MediaItem(
    id: 'wn_piku',
    title: 'PIKU',
    category: 'Comedy Drama',
    year: '2015',
    certification: 'U',
    genre: 'Drama | Hindi | 2015',
    provider: 'SonyLIV',
    description: 'A road trip to Kolkata brings an eccentric aging father, his architect daughter, and an impatient cab owner closer.',
    gradient: [Color(0xFF14532D), Color(0xFF052E16), Color(0xFF021209)],
  ),
];

final List<MediaItem> trendingNowItems = [
  const MediaItem(
    id: 'tr_rrr',
    title: 'RRR',
    category: 'Period Action',
    year: '2022',
    certification: 'U/A 16+',
    genre: 'Action | Telugu | 2022',
    provider: 'Netflix',
    description: 'A fearless warrior on a perilous mission comes face to face with a steely cop serving British forces in pre-independent India.',
    gradient: [Color(0xFF7C2D12), Color(0xFF431407), Color(0xFF1C0802)],
  ),
  const MediaItem(
    id: 'tr_kgf2',
    title: 'K.G.F: Chapter 2',
    category: 'Action Thriller',
    year: '2022',
    certification: 'U/A 16+',
    genre: 'Action | Kannada | 2022',
    provider: 'Prime Video',
    description: 'In the blood-soaked Kolar Gold Fields, Rocky must defend his supremacy against allies, government officials, and rivals.',
    gradient: [Color(0xFF713F12), Color(0xFF3F2206), Color(0xFF1A0E02)],
  ),
  const MediaItem(
    id: 'tr_pathaan',
    title: 'PATHAAN',
    category: 'Spy Action',
    year: '2023',
    certification: 'U/A 16+',
    genre: 'Action | Hindi | 2023',
    provider: 'Prime Video',
    description: 'An exiled RAW agent returns to team up with a fellow spy to take down Outfit X, a rogue mercenary outfit threatening the nation.',
    gradient: [Color(0xFF0369A1), Color(0xFF075985), Color(0xFF082F49)],
  ),
  const MediaItem(
    id: 'tr_animal',
    title: 'ANIMAL',
    category: 'Action Thriller',
    year: '2023',
    certification: 'A 18+',
    genre: 'Action | Hindi | 2023',
    provider: 'Netflix',
    description: 'A fiercely obsessive son embarks on a brutal rampage of vengeance against anyone who threatens his estranged father.',
    gradient: [Color(0xFF7F1D1D), Color(0xFF450A0A), Color(0xFF1C0303)],
  ),
];

final List<ChannelItem> liveChannels = [
  const ChannelItem(
    id: 'ch_star_plus',
    name: 'Star Plus HD',
    category: 'General Entertainment',
    currentProgram: 'Anupamaa',
    timeRemaining: '22m left',
    logoColor: Color(0xFFE11D48),
  ),
  const ChannelItem(
    id: 'ch_sony_liv',
    name: 'Sony SET HD',
    category: 'Entertainment',
    currentProgram: 'Kaun Banega Crorepati',
    timeRemaining: '45m left',
    logoColor: Color(0xFF0284C7),
  ),
  const ChannelItem(
    id: 'ch_zee_tv',
    name: 'Zee TV HD',
    category: 'General Entertainment',
    currentProgram: 'Kundali Bhagya',
    timeRemaining: '15m left',
    logoColor: Color(0xFF9333EA),
  ),
  const ChannelItem(
    id: 'ch_aaj_tak',
    name: 'Aaj Tak HD',
    category: 'News Live',
    currentProgram: 'Dangal Prime Debate',
    timeRemaining: 'LIVE',
    logoColor: Color(0xFFDC2626),
  ),
  const ChannelItem(
    id: 'ch_star_sports',
    name: 'Star Sports 1',
    category: 'Sports Live',
    currentProgram: 'India vs England Live Cricket',
    timeRemaining: 'LIVE',
    logoColor: Color(0xFF16A34A),
  ),
  const ChannelItem(
    id: 'ch_discovery',
    name: 'Discovery HD',
    category: 'Infotainment',
    currentProgram: 'Man vs Wild: India Special',
    timeRemaining: '30m left',
    logoColor: Color(0xFF0D9488),
  ),
];

// ---------------------------------------------------------------------------
// Main TV Home Page
// ---------------------------------------------------------------------------
class JioTvHomePage extends StatefulWidget {
  const JioTvHomePage({super.key});

  @override
  State<JioTvHomePage> createState() => _JioTvHomePageState();
}

class _JioTvHomePageState extends State<JioTvHomePage> {
  late final SpatialNavigationController _navigationController;
  final ScrollController _mainScrollController = ScrollController();

  int _selectedCategoryIndex = 0;
  int _heroIndex = 0;
  bool _debugOverlayEnabled = false;
  MediaItem? _selectedMedia;
  ChannelItem? _selectedChannel;

  final List<String> _categories = [
    'For You',
    'Digital TV',
    'Catch Up TV',
    'Movies',
    'Shows',
    'Kids',
    'Music',
    'Sports',
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
              // Atmospheric Cinema Background with dynamic hero gradient & illustration
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

              // Cinematic particles & vignette overlay
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

              // Subtle bottom shadow gradient
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0x9907080B),
                        Color(0xFF07080B),
                      ],
                      stops: [0.3, 0.7, 1.0],
                    ),
                  ),
                ),
              ),

              // Main Application Scope
              TvNavigationScope(
                controller: _navigationController,
                groupId: 'jio_tv_root',
                preferredEntryNodeId: 'hero_btn_play',
                child: SingleChildScrollView(
                  controller: _mainScrollController,
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 18),

                      // Top App Bar
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

                      // Hero Content Section
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
                        child: _buildWhatsNewRow(),
                      ),

                      const SizedBox(height: 28),

                      // Shelf 2: "Live TV Channels" Shelf
                      _buildShelfHeader("Live TV Now Streaming"),
                      const SizedBox(height: 12),
                      TvNavigationScope(
                        controller: _navigationController,
                        groupId: 'scope_live_channels',
                        autoFocus: false,
                        preferredEntryNodeId: 'channel_card_0',
                        boundaries: const NavigationBoundaries(
                          canExitLeft: false,
                          canExitRight: false,
                          canExitUp: true,
                          canExitDown: true,
                          nextGroupUp: 'scope_whats_new',
                          nextGroupDown: 'scope_trending',
                        ),
                        child: _buildLiveChannelsRow(),
                      ),

                      const SizedBox(height: 28),

                      // Shelf 3: "Trending Blockbusters"
                      _buildShelfHeader("Trending Now"),
                      const SizedBox(height: 12),
                      TvNavigationScope(
                        controller: _navigationController,
                        groupId: 'scope_trending',
                        autoFocus: false,
                        preferredEntryNodeId: 'trending_card_0',
                        boundaries: const NavigationBoundaries(
                          canExitLeft: false,
                          canExitRight: false,
                          canExitUp: true,
                          canExitDown: false,
                          nextGroupUp: 'scope_live_channels',
                        ),
                        child: _buildTrendingNowRow(),
                      ),
                    ],
                  ),
                ),
              ),

              // Detail Modal Dialog Overlay
              if (_selectedMedia != null || _selectedChannel != null) _buildModalOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Header / Top Navigation Bar
  // -------------------------------------------------------------------------
  Widget _buildTopHeaderBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // JioTV+ Brand Logo
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE50914),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Jio',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'tv+',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),

        const SizedBox(width: 20),

        // YouTube LiveTV Quick Action Button
        TvFocusable(
          id: 'btn_nav_youtube',
          groupId: 'scope_header',
          onFocused: _scrollToTop,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Switched to LiveTV stream!')),
            );
          },
          focusBuilder: (context, child, isFocused) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF0000),
                border: Border.all(
                  color: isFocused ? Colors.white : Colors.transparent,
                  width: 2.5,
                ),
                boxShadow: isFocused
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFF0000).withValues(alpha: 0.8),
                          blurRadius: 14,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
            );
          },
          child: const SizedBox(),
        ),

        const SizedBox(width: 10),

        // Search Icon Button
        TvFocusable(
          id: 'btn_nav_search',
          groupId: 'scope_header',
          onFocused: _scrollToTop,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Voice & Text Search')),
            );
          },
          focusBuilder: (context, child, isFocused) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFocused ? Colors.white : const Color(0x33FFFFFF),
                border: Border.all(
                  color: isFocused ? Colors.white : Colors.white24,
                  width: 2,
                ),
                boxShadow: isFocused
                    ? [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                Icons.search_rounded,
                color: isFocused ? Colors.black : Colors.white,
                size: 18,
              ),
            );
          },
          child: const SizedBox(),
        ),

        const SizedBox(width: 12),

        // Category Navigation Bar
        Expanded(
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0x2B000000),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x22FFFFFF)),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final categoryName = _categories[index];
                final isSelected = _selectedCategoryIndex == index;

                return TvFocusable(
                  id: 'nav_category_$index',
                  groupId: 'scope_header',
                  onFocused: () {
                    _scrollToTop();
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  onPressed: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  focusBuilder: (context, child, isFocused) {
                    final active = isFocused || isSelected;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isFocused
                            ? Colors.white
                            : (isSelected ? const Color(0x40FFFFFF) : Colors.transparent),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: isFocused
                            ? [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          categoryName,
                          style: TextStyle(
                            color: isFocused
                                ? Colors.black
                                : (isSelected ? Colors.white : Colors.white70),
                            fontSize: 12,
                            fontWeight: active ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                  child: const SizedBox(),
                );
              },
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Notifications Bell
        TvFocusable(
          id: 'btn_nav_notifications',
          groupId: 'scope_header',
          onFocused: _scrollToTop,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No new notifications')),
            );
          },
          focusBuilder: (context, child, isFocused) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFocused ? Colors.white : const Color(0x33FFFFFF),
                border: Border.all(
                  color: isFocused ? Colors.white : Colors.white24,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: isFocused ? Colors.black : Colors.white,
                size: 18,
              ),
            );
          },
          child: const SizedBox(),
        ),

        const SizedBox(width: 10),

        // Settings Gear Icon (also toggles Debug overlay)
        TvFocusable(
          id: 'btn_nav_settings',
          groupId: 'scope_header',
          onFocused: _scrollToTop,
          onPressed: () {
            setState(() => _debugOverlayEnabled = !_debugOverlayEnabled);
          },
          focusBuilder: (context, child, isFocused) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFocused ? Colors.white : const Color(0x33FFFFFF),
                border: Border.all(
                  color: isFocused ? Colors.white : Colors.white24,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.settings_outlined,
                color: isFocused ? Colors.black : Colors.white,
                size: 18,
              ),
            );
          },
          child: const SizedBox(),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Hero Content Section
  // -------------------------------------------------------------------------
  Widget _buildHeroContent(MediaItem hero) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Switch to LiveTV in One click" sub-pill bubble
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xCC0B101D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1D4ED8), width: 1.5),
          ),
          child: const Text(
            'Switch to LiveTV in One click',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Prime Video Provider Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF00A8E1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.movie_creation_outlined, size: 12, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                hero.provider.toLowerCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Large Hero Title
        Text(
          hero.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 6),

        // Genre / Year / Metadata Line
        Row(
          children: [
            Text(
              hero.category,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const Text(' | ', style: TextStyle(color: Colors.white38, fontSize: 14)),
            Text(
              hero.genre.split('|')[1].trim(),
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const Text(' | ', style: TextStyle(color: Colors.white38, fontSize: 14)),
            Text(
              hero.year,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: const Color(0x33FFFFFF),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white30),
              ),
              child: Text(
                hero.certification,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Synopsis
        SizedBox(
          width: 520,
          child: Text(
            hero.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),

        const SizedBox(height: 18),

        // Action Buttons Row
        Row(
          children: [
            // Play Button
            TvFocusable(
              id: 'hero_btn_play',
              groupId: 'scope_hero',
              onPressed: () => _openMediaDetail(hero),
              focusBuilder: (context, child, isFocused) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 140,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isFocused ? Colors.white : const Color(0x26FFFFFF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isFocused ? Colors.white : const Color(0x55FFFFFF),
                      width: 2,
                    ),
                    boxShadow: isFocused
                        ? [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.5),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: isFocused ? Colors.black : Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Play',
                        style: TextStyle(
                          color: isFocused ? Colors.black : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: const SizedBox(),
            ),

            const SizedBox(width: 14),

            // More Info / Details Button
            TvFocusable(
              id: 'hero_btn_details',
              groupId: 'scope_hero',
              onPressed: () => _openMediaDetail(hero),
              focusBuilder: (context, child, isFocused) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 120,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isFocused ? const Color(0xFFE50914) : const Color(0x26FFFFFF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isFocused ? Colors.white : const Color(0x33FFFFFF),
                      width: 2,
                    ),
                    boxShadow: isFocused
                        ? [
                            BoxShadow(
                              color: const Color(0xFFE50914).withValues(alpha: 0.5),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      'Details',
                      style: TextStyle(
                        color: isFocused ? Colors.white : Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
              child: const SizedBox(),
            ),

            const SizedBox(width: 16),

            // Next Banner Button
            TvFocusable(
              id: 'hero_btn_next',
              groupId: 'scope_hero',
              onPressed: () {
                setState(() {
                  _heroIndex = (_heroIndex + 1) % heroCarousel.length;
                });
              },
              focusBuilder: (context, child, isFocused) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 38,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isFocused ? Colors.white : const Color(0x26FFFFFF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isFocused ? Colors.white : const Color(0x33FFFFFF),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: isFocused ? Colors.black : Colors.white,
                    size: 24,
                  ),
                );
              },
              child: const SizedBox(),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Carousel Indicator Dots
        Row(
          children: List.generate(6, (index) {
            final isActive = index == (_heroIndex % 6);
            return Container(
              margin: const EdgeInsets.only(right: 6),
              width: isActive ? 8 : 5,
              height: isActive ? 8 : 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.white : Colors.white30,
              ),
            );
          }),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Shelf Header
  // -------------------------------------------------------------------------
  Widget _buildShelfHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 18),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Shelf 1: "What's New" Poster Card Rail (Bholaa, Baahubali 2, Dasvi, SPY...)
  // -------------------------------------------------------------------------
  Widget _buildWhatsNewRow() {
    return SizedBox(
      height: 125,
      child: TvScrollableRow(
        groupId: 'scope_whats_new',
        padding: const EdgeInsets.symmetric(horizontal: 44),
        pivotFraction: 0.25,
        children: List.generate(whatsNewItems.length, (index) {
          final item = whatsNewItems[index];
          final id = 'wn_card_$index';

          return Container(
            margin: const EdgeInsets.only(right: 14),
            child: TvFocusable(
              id: id,
              groupId: 'scope_whats_new',
              onPressed: () => _openMediaDetail(item),
              focusBuilder: (context, child, isFocused) {
                return AnimatedScale(
                  scale: isFocused ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  child: Container(
                    width: 190,
                    height: 115,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFocused ? Colors.white : Colors.white12,
                        width: isFocused ? 3.0 : 1,
                      ),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.45),
                                blurRadius: 18,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Card Artistic Poster Background
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: item.gradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.movie_filter_rounded,
                                    size: 32,
                                    color: Colors.white.withValues(alpha: 0.35),
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      item.title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Vignette & Bottom Label
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Color(0x80000000),
                                  Color(0xF0000000),
                                ],
                                stops: [0.4, 0.75, 1.0],
                              ),
                            ),
                          ),
                        ),

                        // Title Text and Provider Tag
                        Positioned(
                          left: 10,
                          right: 10,
                          bottom: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0x66FFFFFF),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  item.provider,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                item.category,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 9.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const SizedBox(),
            ),
          );
        }),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Shelf 2: Live Channels Row
  // -------------------------------------------------------------------------
  Widget _buildLiveChannelsRow() {
    return SizedBox(
      height: 110,
      child: TvScrollableRow(
        groupId: 'scope_live_channels',
        padding: const EdgeInsets.symmetric(horizontal: 44),
        pivotFraction: 0.25,
        children: List.generate(liveChannels.length, (index) {
          final channel = liveChannels[index];
          final id = 'channel_card_$index';

          return Container(
            margin: const EdgeInsets.only(right: 14),
            child: TvFocusable(
              id: id,
              groupId: 'scope_live_channels',
              onPressed: () => _openChannelDetail(channel),
              focusBuilder: (context, child, isFocused) {
                return AnimatedScale(
                  scale: isFocused ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  child: Container(
                    width: 175,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF131724),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFocused ? const Color(0xFFE50914) : Colors.white12,
                        width: isFocused ? 3.0 : 1,
                      ),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: const Color(0xFFE50914).withValues(alpha: 0.5),
                                blurRadius: 18,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: channel.logoColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                channel.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.5,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDC2626),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: const Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              channel.currentProgram,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              channel.timeRemaining,
                              style: const TextStyle(color: Colors.white54, fontSize: 9.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const SizedBox(),
            ),
          );
        }),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Shelf 3: "Trending Now" Poster Rail
  // -------------------------------------------------------------------------
  Widget _buildTrendingNowRow() {
    return SizedBox(
      height: 125,
      child: TvScrollableRow(
        groupId: 'scope_trending',
        padding: const EdgeInsets.symmetric(horizontal: 44),
        pivotFraction: 0.25,
        children: List.generate(trendingNowItems.length, (index) {
          final item = trendingNowItems[index];
          final id = 'trending_card_$index';

          return Container(
            margin: const EdgeInsets.only(right: 14),
            child: TvFocusable(
              id: id,
              groupId: 'scope_trending',
              onPressed: () => _openMediaDetail(item),
              focusBuilder: (context, child, isFocused) {
                return AnimatedScale(
                  scale: isFocused ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  child: Container(
                    width: 190,
                    height: 115,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFocused ? Colors.white : Colors.white12,
                        width: isFocused ? 3.0 : 1,
                      ),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.45),
                                blurRadius: 18,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: item.gradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                item.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Color(0x80000000),
                                  Color(0xF0000000),
                                ],
                                stops: [0.4, 0.75, 1.0],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          right: 10,
                          bottom: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0x66FFFFFF),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  item.provider,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                item.category,
                                style: const TextStyle(color: Colors.white70, fontSize: 9.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const SizedBox(),
            ),
          );
        }),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Modal Detail Dialog Overlay (Demonstrating Modal Scope Isolation)
  // -------------------------------------------------------------------------
  Widget _buildModalOverlay() {
    return Positioned.fill(
      child: Container(
        color: const Color(0xD9000000),
        child: Center(
          child: TvNavigationScope(
            controller: _navigationController,
            groupId: 'detail_modal_scope',
            isModal: true,
            preferredEntryNodeId: 'modal_btn_action',
            child: Container(
              width: 520,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF161922),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE50914), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 36,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE50914),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _selectedMedia != null ? 'STREAMING NOW' : 'LIVE BROADCAST',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TvFocusable(
                        id: 'modal_btn_close_icon',
                        groupId: 'detail_modal_scope',
                        onPressed: _closeModal,
                        focusBuilder: (context, child, isFocused) {
                          return Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFocused ? Colors.white : const Color(0x33FFFFFF),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: isFocused ? Colors.black : Colors.white,
                            ),
                          );
                        },
                        child: const SizedBox(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _selectedMedia?.title ?? _selectedChannel?.name ?? 'Details',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _selectedMedia != null
                        ? '${_selectedMedia!.genre}  •  Provider: ${_selectedMedia!.provider}'
                        : '${_selectedChannel!.category}  •  Playing: ${_selectedChannel!.currentProgram}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _selectedMedia?.description ??
                        'Live broadcast in High Definition with Dolby Digital audio. Spatial navigation focus is restricted exclusively inside this modal scope.',
                    style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      // Watch / Play Button
                      TvFocusable(
                        id: 'modal_btn_action',
                        groupId: 'detail_modal_scope',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Starting playback for ${_selectedMedia?.title ?? _selectedChannel?.name}')),
                          );
                          _closeModal();
                        },
                        focusBuilder: (context, child, isFocused) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: isFocused ? const Color(0xFFE50914) : const Color(0x33FFFFFF),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isFocused ? Colors.white : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  _selectedMedia != null ? 'Watch Movie' : 'Watch Channel',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const SizedBox(),
                      ),

                      const SizedBox(width: 12),

                      // Add to Watchlist Button
                      TvFocusable(
                        id: 'modal_btn_watchlist',
                        groupId: 'detail_modal_scope',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to your Watchlist!')),
                          );
                        },
                        focusBuilder: (context, child, isFocused) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isFocused ? Colors.white : const Color(0x22FFFFFF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_rounded,
                                  color: isFocused ? Colors.black : Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Watchlist',
                                  style: TextStyle(
                                    color: isFocused ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const SizedBox(),
                      ),

                      const Spacer(),

                      // Close Dialog Button
                      TvFocusable(
                        id: 'modal_btn_dismiss',
                        groupId: 'detail_modal_scope',
                        onPressed: _closeModal,
                        focusBuilder: (context, child, isFocused) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isFocused ? Colors.white : const Color(0x22FFFFFF),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isFocused ? Colors.white : Colors.white24,
                                width: isFocused ? 2 : 1,
                              ),
                              boxShadow: isFocused
                                  ? [
                                      BoxShadow(
                                        color: Colors.white.withValues(alpha: 0.4),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Text(
                              'Dismiss',
                              style: TextStyle(
                                color: isFocused ? Colors.black : Colors.white70,
                                fontSize: 13,
                                fontWeight: isFocused ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          );
                        },
                        child: const SizedBox(),
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
