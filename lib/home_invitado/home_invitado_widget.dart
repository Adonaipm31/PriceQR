import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/components/nav_bar_invitado_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HomeInvitadoWidget extends StatefulWidget {
  const HomeInvitadoWidget({super.key});

  static String routeName = 'HomeInvitado';
  static String routePath = '/homeInvitado';

  @override
  State<HomeInvitadoWidget> createState() =>
      _HomeInvitadoWidgetState();
}

class _HomeInvitadoWidgetState
    extends State<HomeInvitadoWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> hotels = [
    {
      "image": "assets/images/hotel1.png",
      "title": "InterContinental Hotel",
      "location": "Cartagena, Colombia",
      "price": "Login to view",
      "rating": "4.7"
    },
    {
      "image": "assets/images/hotel2.jpg",
      "title": "Hyatt Regency Hotel",
      "location": "Bocagrande",
      "price": "Login to view",
      "rating": "4.7"
    },
  ];

  final List<Map<String, String>> beachs = [
    {
      "image": "assets/images/beach1.jpg",
      "title": "Casa Córdoba Barú",
      "location": "Barú Island",
      "price": "Login to view",
      "rating": "4.5"
    },
  ];

  final List<Map<String, String>> restaurants = [
    {
      "image": "assets/images/restaurant1.jpg",
      "title": "San Nicolás",
      "location": "Getsemaní",
      "price": "Login to view",
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
  }

  bool get isLoggedIn =>
      FirebaseAuth.instance.currentUser != null;

  void requireLogin() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 24),

              CircleAvatar(
                radius: 34,
                backgroundColor:
                    FlutterFlowTheme.of(context)
                        .primary
                        .withOpacity(0.1),
                child: Icon(
                  Icons.workspace_premium,
                  size: 36,
                  color:
                      FlutterFlowTheme.of(context)
                          .primary,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Unlock Premium Features",
                style: GoogleFonts.karla(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Create an account to access verified prices, save favorites and receive tourist safety alerts.",
                textAlign: TextAlign.center,
                style: GoogleFonts.karla(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    context.pushNamed(
                      'RegistroCliente',
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        FlutterFlowTheme.of(context)
                            .primary,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),

                  child: Text(
                    "Create Account",
                    style: GoogleFonts.karla(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Maybe later",
                  style: GoogleFonts.karla(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildLockedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.lock,
            color: Colors.white,
            size: 16,
          ),
          SizedBox(width: 4),
          Text(
            "Members Only",
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
                        Colors.black.withOpacity(0.45),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 14,
                bottom: 14,
                child: buildLockedBadge(),
              ),

              Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      requireLogin();
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
                          "Verified prices locked",
                          style:
                              GoogleFonts.karla(
                            fontSize: 12,
                            color: Colors.red,
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
                                Colors.grey,
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
                    onPressed: () {
                      requireLogin();
                    },

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.black87,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),

                    icon: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),

                    label: Text(
                      "Login to Unlock",
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
                            "Welcome Guest 👋",
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
                            "Explore Cartagena",
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
                            Colors.grey.shade300,
                        child: const Icon(
                          Icons.person_outline,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

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
                        Color(0xFF111827),
                        Color(0xFF374151),
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
                        Icons.workspace_premium,
                        color: Colors.white,
                        size: 34,
                      ),

                      const SizedBox(
                        width: 14,
                      ),

                      Expanded(
                        child: Text(
                          "Create an account to unlock verified prices, favorites and exclusive tourist alerts.",
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
                      text: "Restaurants",
                    ),
                  ],
                ),

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
              child:
                  NavBarInvitadoWidget(),
            ),
          ],
        ),
      ),
    );
  }
}