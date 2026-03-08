import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notifications_model.dart';
export 'notifications_model.dart';

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({super.key});

  static String routeName = 'Notifications';
  static String routePath = '/notifications';

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  late NotificationsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> notifications = [
    {
      "name": "David Silbia",
      "message": "Scanned your pass key and entered the gate.",
      "time": "Just now",
      "image": "assets/images/Ellipse_61.png",
      "read": false
    },
    {
      "name": "Rachel Kinch",
      "message": "Will attend Snow removal at Oct 22, 2024.",
      "time": "1 hr ago",
      "image": "assets/images/Ellipse_64.png",
      "read": false
    },
    {
      "name": "System Update",
      "message": "Main gate will be down for maintenance for 4 hours.",
      "time": "9 hr ago",
      "image": "assets/images/Ellipse_65.png",
      "read": true
    },
    {
      "name": "Security",
      "message": "A visitor has arrived at the main entrance.",
      "time": "Yesterday",
      "image": "assets/images/Ellipse_61.png",
      "read": true
    },
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget notificationCard(int index) {
    final item = notifications[index];

    return Dismissible(
      key: Key(item["name"] + index.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          notifications.removeAt(index);
        });
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          setState(() {
            notifications[index]["read"] = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Notification opened"),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: item["read"]
                ? const LinearGradient(
                    colors: [Colors.white, Colors.white],
                  )
                : const LinearGradient(
                    colors: [
                      Color(0xFFE8F1FF),
                      Color(0xFFF6F9FF)
                    ],
                  ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      item["image"],
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (!item["read"])
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["name"],
                      style: GoogleFonts.karla(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: const Color(0xFF060518),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item["message"],
                      style: GoogleFonts.karla(
                        fontSize: 13,
                        color: const Color(0xFF3C3E56),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item["time"],
                style: GoogleFonts.karla(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.safePop(),
          ),
          title: Text(
            "Notifications",
            style: GoogleFonts.karla(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return notificationCard(index);
          },
        ),
      ),
    );
  }
}