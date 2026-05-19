import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/components/nav_bar_invitado_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';

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

  Set<String> favorites = {};

  final List<Map<String, String>> hotels = [
    {
      "image": "assets/images/hotel1.png",
      "title": "InterContinental Hotel",
      "location": "Cartagena, Colombia",
      "price": "\$160/night",
      "rating": "4.7"
    },
    {
      "image": "assets/images/hotel2.jpg",
      "title": "Hyatt Regency Hotel",
      "location": "Bocagrande",
      "price": "\$195/night",
      "rating": "4.7"
    },
  ];

  final List<Map<String, String>> beachs = [
    {
      "image": "assets/images/beach1.jpg",
      "title": "Casa Córdoba Barú",
      "location": "Barú Island",
      "price": "\$140/night",
      "rating": "4.5"
    },
  ];

  final List<Map<String, String>> restaurants = [
    {
      "image": "assets/images/restaurant1.jpg",
      "title": "San Nicolás",
      "location": "Getsemaní",
      "price": "\$10-31 avg",
      "rating": "4.6"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  bool get isLoggedIn =>
      FirebaseAuth.instance.currentUser != null;

  void requireLogin(VoidCallback action) {
    if (!isLoggedIn) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.lock, size: 50),
                SizedBox(height: 10),
                Text(
                  "Regístrate para usar esta función",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );
    } else {
      action();
    }
  }

  Widget buildCard(Map<String, String> item) {
    final isFav = favorites.contains(item["title"]);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context)
            .secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  item["image"]!,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      isFav
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      requireLogin(() {
                        setState(() {
                          if (isFav) {
                            favorites
                                .remove(item["title"]);
                          } else {
                            favorites
                                .add(item["title"]!);
                          }
                        });
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"]!,
                  style: GoogleFonts.karla(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        FlutterFlowTheme.of(context)
                            .primaryText,
                  ),
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 18),
                    const SizedBox(width: 4),
                    Text(item["location"]!),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item["price"]!,
                      style: GoogleFonts.karla(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            FlutterFlowTheme.of(context)
                                .primary,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(item["rating"]!),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildTab(List<Map<String, String>> data) {
    return ListView.builder(
      padding:
          const EdgeInsets.fromLTRB(16, 20, 16, 120),
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
                      const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search places...",
                      prefixIcon:
                          const Icon(Icons.search),
                      filled: true,
                      fillColor:
                          Colors.white,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                TabBar(
                  controller: _tabController,
                  labelColor:
                      FlutterFlowTheme.of(context)
                          .primary,
                  unselectedLabelColor:
                      Colors.grey,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.hotel),
                      text: "Hotels",
                    ),
                    Tab(
                      icon: Icon(Icons.beach_access),
                      text: "Beachs",
                    ),
                    Tab(
                      icon: Icon(Icons.restaurant),
                      text: "Food",
                    ),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      buildTab(hotels),
                      buildTab(beachs),
                      buildTab(restaurants),
                    ],
                  ),
                ),
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: NavBarInvitadoWidget(),
            ),
          ],
        ),
      ),
    );
  }
}