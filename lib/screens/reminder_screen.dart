import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool isCheckedValentines = false;
  bool isCheckedHolidays = false;
  bool isCheckedCustom = false;
  FlutterLocalNotificationsPlugin ?flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  showNotification(DateTime date, String name, String occasion) async {

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android:  androidPlatformChannelSpecifics, iOS:iOSPlatformChannelSpecifics);


    // await flutterLocalNotificationsPlugin!.showWeeklyAtDayAndTime(2, '${document['showname']} is Live!', '',Day(dayNumber),Time(document['starttime'],0,0), platformChannelSpecifics);
    // await flutterLocalNotificationsPlugin!.periodicallyShow(2, '', '',Day(date.day),Time(date.hour,date.minute,0), platformChannelSpecifics);

    final snackBar = SnackBar(
        content: Text('Reminder Added!'));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    /*
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);

     */
  }

  DateTime selectedDate=DateTime.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  TextEditingController occasionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/logo1.jpg',
                            height: 68,
                            width: 68,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Text("Reminders",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Set up reminders for special dates and never forget another holiday, birthday, or anniversary.",
                      style: kTextStyle,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: isCheckedValentines,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedValentines = value!;
                            });
                          },
                        ),
                        const Text(
                          "Valentines Day",
                          style: kTextStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: isCheckedHolidays,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedHolidays = value!;
                            });
                          },
                        ),
                        const Text(
                          "All Holidays",
                          style: kTextStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: isCheckedCustom,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedCustom = value!;
                            });
                          },
                        ),
                        const Text(
                          "Add Custom Reminder",
                          style: kTextStyle,
                        ),
                      ],
                    ),
                    if(isCheckedCustom)
                    Column(
                      children: [
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 51,
                          width: 368,
                          child: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Recipient's Name",

                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 51,
                              width: 175,
                              child: TextFormField(
                                controller: occasionController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelText: "Occasion",
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 51,
                              width: 130,
                              child: TextFormField(
                                readOnly: true,
                                controller: dateController,
                                style: TextStyle(
                                  fontSize: 12
                                ),
                                onTap: (){
                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(2022, 1, 1),
                                      maxTime: DateTime(2050, 6, 7),
                                      onChanged: (date) {

                                      }, onConfirm: (date) {
                                        selectedDate=date;
                                        dateController.text = '${date.day}-${date.month}-${date.year}';
                                        setState(() {

                                        });
                                        print('confirm $date');
                                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                                },
                                decoration: InputDecoration(
                                  suffixIcon: const Padding(
                                    padding: EdgeInsets.only(
                                        top: 0), // add padding to adjust icon
                                    child: Icon(Icons.date_range_rounded),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelText: "Date",
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        GradientButton(
                          onPressed: () {
                            // showNotification(selectedDate,nameController.text,occasionController.text);

                          },
                          child: const Text(
                            "Remind me on this date",
                            style: kButtonTextStyle,
                          ),
                          gradient: gradient1,
                        ),
                        const SizedBox(height: 15),
                        GradientButton(
                          onPressed: () {},
                          child: const Text(
                            "Remind me 7 days before",
                            style: kButtonTextStyle,
                          ),
                          gradient: gradient1,
                        ),
                        const SizedBox(height: 15),
                        GradientButton(
                          onPressed: () {},
                          child: const Text(
                            "Remind me 14 days before",
                            style: kButtonTextStyle,
                          ),
                          gradient: gradient1,
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
