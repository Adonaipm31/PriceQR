import '/components/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      "title": "Restaurant-Bar San Nicolás",
      "location": "Center - Getsemaní",
      "price": "\$10-31/avg",
      "rating": "4.6"
    },
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  Widget buildCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            child: Image.asset(
              item["image"]!,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"]!,
                  style: GoogleFonts.karla(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 18,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item["location"]!,
                      style: GoogleFonts.karla(
                        color:
                            FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
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
                        fontWeight: FontWeight.bold,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item["rating"]!,
                          style: GoogleFonts.karla(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
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
          FlutterFlowTheme.of(context).primaryBackground,

      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: Container(
                    height: 58,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .secondaryBackground,
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Search places...',
                        prefixIcon: Icon(
                          Icons.search_rounded,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                TabBar(
                  controller: _tabController,
                  labelColor:
                      FlutterFlowTheme.of(context).primary,
                  unselectedLabelColor:
                      FlutterFlowTheme.of(context)
                          .secondaryText,
                  indicatorColor:
                      FlutterFlowTheme.of(context).primary,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.hotel_rounded),
                      text: "Hotels",
                    ),
                    Tab(
                      icon: Icon(Icons.beach_access_rounded),
                      text: "Beachs",
                    ),
                    Tab(
                      icon: Icon(Icons.restaurant_rounded),
                      text: "Restaurants",
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
              child: NavBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}