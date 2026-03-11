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
      "message": "Main gate maintenance for 4 hours.",
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

  int get unreadCount =>
      notifications.where((n) => n["read"] == false).length;

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

  void markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n["read"] = true;
      }
    });
  }

  void clearAll() {
    setState(() {
      notifications.clear();
    });
  }

  Widget notificationCard(int index) {
    final item = notifications[index];

    return Dismissible(
      key: Key(item["name"] + index.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 25),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          notifications.removeAt(index);
        });
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          setState(() {
            notifications[index]["read"] = true;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: item["read"] ? Colors.white : const Color(0xFFEFF4FF),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Row(
            children: [

              /// Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: AssetImage(item["image"]),
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

              const SizedBox(width: 14),

              /// Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      item["name"],
                      style: GoogleFonts.karla(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      item["message"],
                      style: GoogleFonts.karla(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              /// Time
              Text(
                item["time"],
                style: GoogleFonts.karla(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey[400],
          ),

          const SizedBox(height: 16),

          Text(
            "No Notifications",
            style: GoogleFonts.karla(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "You're all caught up!",
            style: GoogleFonts.karla(
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
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
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          actions: [

            if (notifications.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.done_all, color: Colors.black),
                onPressed: markAllAsRead,
              ),

            if (notifications.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.black),
                onPressed: clearAll,
              ),
          ],
        ),

        body: Column(
          children: [

            /// Unread indicator
            if (unreadCount > 0)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [

                    const Icon(Icons.notifications_active,
                        color: Colors.blue),

                    const SizedBox(width: 10),

                    Text(
                      "$unreadCount unread notifications",
                      style: GoogleFonts.karla(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            Expanded(
              child: notifications.isEmpty
                  ? emptyState()
                  : ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return notificationCard(index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}