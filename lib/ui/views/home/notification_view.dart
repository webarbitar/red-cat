import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ret_cat/core/constance/style.dart';
import 'package:ret_cat/core/utils/string_extension.dart';
import 'package:ret_cat/core/view_model/home/home_view_modal.dart';
import 'package:ret_cat/ui/shared/ui_comp_mixin.dart';
import 'package:ret_cat/ui/shared/ui_helpers.dart';
import 'package:ret_cat/ui/widgets/loader_widget.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> with UiCompMixin {
  late final HomeViewModal _homeViewModal;
  final DateFormat _format = DateFormat("dd, MMM yyy hh:mm a");

  @override
  void initState() {
    super.initState();
    _homeViewModal = context.read<HomeViewModal>();
    initNotificationModule();
  }

  void initNotificationModule() async {
    busyNfy.value = true;
    final res = await _homeViewModal.fetchNotifications();
    busyNfy.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
        elevation: 0.0,
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: ValueListenableBuilder(
          valueListenable: busyNfy,
          builder: (context, busy, _) {
            if (busy) {
              return const Center(
                child: LoaderWidget(color: primaryColor),
              );
            }
            return Consumer<HomeViewModal>(builder: (context, model, _) {
              if (model.notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.notifications,
                        size: 70,
                        color: Colors.grey,
                      ),
                      UIHelper.verticalSpaceSmall,
                      Text('Notifications not found!')
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(14),
                itemCount: model.notifications.length,
                itemBuilder: (context, index) {
                  var data = model.notifications[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title.capitalize(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        UIHelper.verticalSpaceSmall,
                        Text(
                          data.description,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        UIHelper.verticalSpaceSmall,
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _format.format(data.createdAt),
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            });
          }),
    );
  }
}
