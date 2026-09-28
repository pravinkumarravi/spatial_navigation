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
        scaffoldBackgroundColor: const Color(0xFF0F1016),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE50914),
          surface: Color(0xFF1A1C24),
        ),
      ),
      home: const TvHomePage(),
    );
  }
}

class TvHomePage extends StatefulWidget {
  const TvHomePage({super.key});

  @override
  State<TvHomePage> createState() => _TvHomePageState();
}

class _TvHomePageState extends State<TvHomePage> {
  late final SpatialNavigationController _navigationController;
  bool _debugOverlayEnabled = false;
  String? _selectedMovieTitle;

  @override
  void initState() {
    super.initState();
    _navigationController = SpatialNavigationController();
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }

  void _showMovieModal(String title) {
    setState(() {
      _selectedMovieTitle = title;
    });
    _navigationController.showModal('movie_detail_modal');
  }

  void _hideMovieModal() {
    _navigationController.hideModal('movie_detail_modal');
    setState(() {
      _selectedMovieTitle = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TvNavigationListener(
      controller: _navigationController,
      onBack: () {
        if (_navigationController.scope.hasModal) {
          _hideMovieModal();
        }
      },
      child: SpatialNavigationDebugger(
        controller: _navigationController,
        enabled: _debugOverlayEnabled,
        child: Scaffold(
          body: Stack(
            children: [
              // Main Ambient Background Gradient
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF141722),
                        Color(0xFF0F1016),
                        Color(0xFF08090C),
                      ],
                    ),
                  ),
                ),
              ),

              // Main App Layout Scope
              TvNavigationScope(
                controller: _navigationController,
                groupId: 'main_dashboard',
                child: Row(
                  children: [
                    // Sidebar Navigation
                    _buildSidebar(),

                    // Main Content Scrollable View
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Bar & Debug Toggle
                            _buildHeaderBar(),

                            const SizedBox(height: 24),

                            // Hero Banner Card
                            _buildHeroBanner(),

                            const SizedBox(height: 36),

                            // Trending Movies Section
                            const Text(
                              'Trending Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildMovieRow('trending', 8),

                            const SizedBox(height: 32),

                            // Popular TV Shows Section
                            const Text(
                              'Popular TV Series',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildMovieRow('popular', 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Modal Overlay Dialog
              if (_selectedMovieTitle != null) _buildModalDialog(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return TvNavigationScope(
      controller: _navigationController,
      groupId: 'sidebar_menu',
      boundaries: const NavigationBoundaries(canExitLeft: false),
      child: Container(
        width: 100,
        color: const Color(0xFF12141C),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Brand Logo Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE50914),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.tv, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 50),
            _buildSidebarIconButton('nav_home', Icons.home_rounded),
            _buildSidebarIconButton('nav_search', Icons.search_rounded),
            _buildSidebarIconButton('nav_movies', Icons.movie_rounded),
            _buildSidebarIconButton('nav_favorites', Icons.favorite_rounded),
            const Spacer(),
            _buildSidebarIconButton('nav_settings', Icons.settings_rounded),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarIconButton(String id, IconData icon) {
    return TvFocusable(
      id: id,
      groupId: 'sidebar_menu',
      focusBuilder: (context, child, isFocused) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 12),
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: isFocused ? const Color(0xFFE50914) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
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
          child: Icon(
            icon,
            color: isFocused ? Colors.white : Colors.white54,
            size: 26,
          ),
        );
      },
      child: Container(),
    );
  }

  Widget _buildHeaderBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Spatial Navigation Engine',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Use Android TV D-Pad / Keyboard Arrows to Navigate',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ],
        ),
        TvFocusable(
          id: 'btn_toggle_debug',
          groupId: 'main_dashboard',
          focusBuilder: (context, child, isFocused) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isFocused
                    ? const Color(0xFFE50914)
                    : (_debugOverlayEnabled ? const Color(0xFF2A2D3D) : const Color(0xFF1E212D)),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isFocused ? Colors.white : Colors.white24,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bug_report_rounded,
                    color: isFocused ? Colors.white : Colors.white70,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _debugOverlayEnabled ? 'Debugger: ON' : 'Debugger: OFF',
                    style: TextStyle(
                      color: isFocused ? Colors.white : Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
          onFocused: () {},
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

  Widget _buildHeroBanner() {
    return TvFocusable(
      id: 'hero_banner',
      groupId: 'main_dashboard',
      focusBuilder: (context, child, isFocused) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF2C1035), Color(0xFF0F1B3E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: isFocused ? const Color(0xFFE50914) : Colors.white10,
              width: isFocused ? 3 : 1,
            ),
            boxShadow: isFocused
                ? [
                    BoxShadow(
                      color: const Color(0xFFE50914).withValues(alpha: 0.4),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ]
                : [],
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE50914),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'FEATURED RELEASE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Interstellar Odyssey',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Press D-Pad Center / Enter to view interactive detail modal',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.play_circle_fill_rounded,
                  size: 64,
                  color: isFocused ? const Color(0xFFE50914) : Colors.white38,
                ),
              ],
            ),
          ),
        );
      },
      onFocused: () {},
      child: GestureDetector(
        onTap: () => _showMovieModal('Interstellar Odyssey'),
        child: const SizedBox(),
      ),
    );
  }

  Widget _buildMovieRow(String category, int count) {
    final colors = [
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.deepOrange,
      Colors.pink,
      Colors.cyan,
    ];

    return SizedBox(
      height: 180,
      child: TvScrollableRow(
        groupId: 'main_dashboard',
        pivotFraction: 0.3,
        children: List.generate(count, (index) {
          final movieId = '${category}_card_$index';
          final title = '${category.toUpperCase()} #${index + 1}';
          final color = colors[index % colors.length];

          return Container(
            margin: const EdgeInsets.only(right: 18),
            child: TvFocusable(
              id: movieId,
              groupId: 'main_dashboard',
              focusBuilder: (context, child, isFocused) {
                return AnimatedScale(
                  scale: isFocused ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 140,
                    height: 180,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isFocused ? Colors.white : Colors.white12,
                        width: isFocused ? 3 : 1,
                      ),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.3),
                                blurRadius: 18,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.movie_filter_rounded, color: color, size: 36),
                          const SizedBox(height: 12),
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: GestureDetector(
                onTap: () => _showMovieModal(title),
                child: const SizedBox(),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildModalDialog() {
    return Positioned.fill(
      child: Container(
        color: Colors.black87,
        child: Center(
          child: TvNavigationScope(
            controller: _navigationController,
            groupId: 'movie_detail_modal',
            isModal: true,
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF1E212D),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE50914), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.movie_rounded, size: 64, color: Color(0xFFE50914)),
                  const SizedBox(height: 16),
                  Text(
                    _selectedMovieTitle ?? 'Movie Details',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Spatial navigation mode is currently restricted to this modal dialog scope. Press ESC / Back key to dismiss.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TvFocusable(
                        id: 'modal_btn_play',
                        groupId: 'movie_detail_modal',
                        focusBuilder: (context, child, isFocused) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: isFocused ? const Color(0xFFE50914) : Colors.white10,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('Play Now', style: TextStyle(color: Colors.white)),
                          );
                        },
                        child: const SizedBox(),
                      ),
                      const SizedBox(width: 16),
                      TvFocusable(
                        id: 'modal_btn_close',
                        groupId: 'movie_detail_modal',
                        focusBuilder: (context, child, isFocused) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: isFocused ? Colors.white24 : Colors.white10,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('Close', style: TextStyle(color: Colors.white)),
                          );
                        },
                        onFocused: () {},
                        child: GestureDetector(
                          onTap: _hideMovieModal,
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
