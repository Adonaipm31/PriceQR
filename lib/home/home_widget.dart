import '/components/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static String routeName = 'Home';
  static String routePath = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final user = FirebaseAuth.instance.currentUser;

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Set<String> favorites = {};

  final List<Map<String, String>> hotels = [
    {
      "id": "hotel_001",
      "image": "assets/images/hotel1.png",
      "title": "InterContinental Hotel",
      "location": "Cartagena, Colombia",
      "price": "\$160/night",
      "rating": "4.7"
    },
    {
      "id": "hotel_002",
      "image": "assets/images/hotel2.jpg",
      "title": "Hyatt Regency Hotel",
      "location": "Bocagrande",
      "price": "\$195/night",
      "rating": "4.7"
    },
  ];

  final List<Map<String, String>> beachs = [
    {
      "id": "beach_001",
      "image": "assets/images/beach1.jpg",
      "title": "Casa Córdoba Barú",
      "location": "Barú Island",
      "price": "\$140/night",
      "rating": "4.5"
    },
  ];

  final List<Map<String, String>> restaurants = [
    {
      "id": "restaurant_001",
      "image": "assets/images/restaurant1.jpg",
      "title": "Restaurant-Bar San Nicolás",
      "location": "Center - Getsemaní",
      "price": "\$10-31/avg",
      "rating": "4.6"
    },
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );

    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(user!.uid)
          .collection('favorites')
          .get();

      final favs = snapshot.docs
          .map((doc) => doc.id)
          .toSet();

      setState(() {
        favorites = favs;
      });
    } catch (e) {
      print("Error loading favorites: $e");
    }
  }

  Future<void> toggleFavorite(
    Map<String, String> item,
  ) async {
    try {
      final docRef = firestore
          .collection('users')
          .doc(user!.uid)
          .collection('favorites')
          .doc(item["id"]);

      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.delete();

        setState(() {
          favorites.remove(item["id"]);
        });
      } else {
        await docRef.set({
          "id": item["id"],
          "title": item["title"],
          "location": item["location"],
          "image": item["image"],
          "price": item["price"],
          "rating": item["rating"],
          "createdAt": Timestamp.now(),
        });

        setState(() {
          favorites.add(item["id"]!);
        });
      }
    } catch (e) {
      print("Error saving favorite: $e");
    }
  }

  Widget buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.verified,
            color: Colors.white,
            size: 16,
          ),
          SizedBox(width: 4),
          Text(
            "Verified",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(Map<String, String> item) {
    final isFav = favorites.contains(item["id"]);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color:
            FlutterFlowTheme.of(context)
                .secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Image.asset(
                  item["image"]!,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.35),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 14,
                bottom: 14,
                child: buildVerifiedBadge(),
              ),

              Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      isFav
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await toggleFavorite(item);
                    },
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"]!,
                  style: GoogleFonts.karla(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        FlutterFlowTheme.of(
                          context,
                        ).primaryText,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 18,
                      color:
                          FlutterFlowTheme.of(
                            context,
                          ).secondaryText,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      item["location"]!,
                      style: GoogleFonts.karla(
                        color:
                            FlutterFlowTheme.of(
                              context,
                            ).secondaryText,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          "Verified tourist price",
                          style:
                              GoogleFonts.karla(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          item["price"]!,
                          style:
                              GoogleFonts.karla(
                            fontSize: 22,
                            fontWeight:
                                FontWeight
                                    .bold,
                            color:
                                FlutterFlowTheme.of(
                                      context,
                                    )
                                    .primary,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color:
                              Colors.amber,
                        ),

                        const SizedBox(
                          width: 4,
                        ),

                        Text(
                          item["rating"]!,
                          style:
                              GoogleFonts.karla(
                            fontWeight:
                                FontWeight
                                    .bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {},

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          FlutterFlowTheme.of(
                            context,
                          ).primary,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),

                    icon: const Icon(
                      Icons.explore,
                      color: Colors.white,
                    ),

                    label: Text(
                      "Explore Place",
                      style:
                          GoogleFonts.karla(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildTab(
    List<Map<String, String>> data,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        16,
        20,
        16,
        120,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return buildCard(data[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          FlutterFlowTheme.of(context)
              .primaryBackground,

      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // HEADER
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    16,
                    20,
                    16,
                    10,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            "Welcome back 👋",
                            style:
                                GoogleFonts.karla(
                              fontSize: 16,
                              color:
                                  FlutterFlowTheme.of(
                                        context,
                                      )
                                      .secondaryText,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            "Discover safe places",
                            style:
                                GoogleFonts.karla(
                              fontSize: 28,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color:
                                  FlutterFlowTheme.of(
                                        context,
                                      )
                                      .primaryText,
                            ),
                          ),
                        ],
                      ),

                      CircleAvatar(
                        radius: 26,
                        backgroundColor:
                            FlutterFlowTheme.of(
                              context,
                            ).primary,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // PREMIUM CARD
                Container(
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  padding:
                      const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(0xFF0EA5E9),
                        Color(0xFF2563EB),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons
                            .verified_user,
                        color: Colors.white,
                        size: 34,
                      ),

                      const SizedBox(
                        width: 14,
                      ),

                      Expanded(
                        child: Text(
                          "You have access to verified prices and saved favorites with PriceQR.",
                          style:
                              GoogleFonts.karla(
                            color:
                                Colors.white,
                            fontWeight:
                                FontWeight
                                    .bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // SEARCH
                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Container(
                    height: 58,
                    decoration: BoxDecoration(
                      color:
                          FlutterFlowTheme.of(
                            context,
                          ).secondaryBackground,
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                    child: TextFormField(
                      decoration:
                          const InputDecoration(
                        hintText:
                            'Search places...',
                        prefixIcon: Icon(
                          Icons
                              .search_rounded,
                        ),
                        border:
                            InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // TABS
                TabBar(
                  controller:
                      _tabController,
                  labelColor:
                      FlutterFlowTheme.of(
                        context,
                      ).primary,
                  unselectedLabelColor:
                      FlutterFlowTheme.of(
                            context,
                          )
                          .secondaryText,
                  indicatorColor:
                      FlutterFlowTheme.of(
                        context,
                      ).primary,
                  tabs: const [
                    Tab(
                      icon: Icon(
                        Icons.hotel_rounded,
                      ),
                      text: "Hotels",
                    ),
                    Tab(
                      icon: Icon(
                        Icons
                            .beach_access_rounded,
                      ),
                      text: "Beachs",
                    ),
                    Tab(
                      icon: Icon(
                        Icons
                            .restaurant_rounded,
                      ),
                      text:
                          "Restaurants",
                    ),
                  ],
                ),

                // CONTENT
                Expanded(
                  child: TabBarView(
                    controller:
                        _tabController,
                    children: [
                      buildTab(hotels),
                      buildTab(beachs),
                      buildTab(
                        restaurants,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Align(
              alignment:
                  Alignment.bottomCenter,
              child: NavBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}