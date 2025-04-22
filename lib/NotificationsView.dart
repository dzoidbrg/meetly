import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meetlyv2/model.dart';
import 'package:provider/provider.dart';

class NotificationsView extends StatefulWidget {
  NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppwriteData>(builder: (context, model, _) {
      return FutureBuilder<List<NotificationToDisplay>>(
        future: model.getAllNotifications(),
        builder: (context, snapshot) {
          return SafeArea(
              child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("Notifications",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      // Refresh the notifications
                    });
                  },
                ),
              ],
            ),
            body: _buildNotificationsList(snapshot),
          ));
        },
      );
    });
  }

  Widget _buildNotificationsList(
      AsyncSnapshot<List<NotificationToDisplay>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (snapshot.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading notifications',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              snapshot.error.toString(),
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              color: Colors.grey,
              size: 60,
            ),
            SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final notification = snapshot.data![index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.event_available,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(
                notification.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(notification.desc),
              ),
              isThreeLine: true,
              onTap: () {
                // Handle notification tap if needed
              },
            ),
          );
        },
      );
    }
  }
}
