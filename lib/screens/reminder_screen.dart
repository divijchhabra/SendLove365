// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

List<bool> holidaysList = [false,false,false,false,false,false,false,false,false,false,];

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  DateTime? date;
  bool isCheckedValentines = false;
  bool isCheckedHolidays = false;
  bool isCheckedCustom = false;



  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future selectNotification(String? payload) async {
    //Handle notification tapped logic here
  }
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {

  }


  showNotification(DateTime selectedDateTime, String name, String occasion) async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

    await flutterLocalNotificationsPlugin!.initialize(initializationSettings,
        onSelectNotification: selectNotification);



    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    // await flutterLocalNotificationsPlugin!.showWeeklyAtDayAndTime(2, '${document['showname']} is Live!', '',Day(dayNumber),Time(document['starttime'],0,0), platformChannelSpecifics);
    if(selectedDateTime.day== DateTime.now().day && selectedDateTime.year== DateTime.now().year &&
        selectedDateTime.month== DateTime.now().month){

      print('reminding today');
      await flutterLocalNotificationsPlugin!.show(
          0, 'It\'s $name\'s $occasion ${selectedDate.month} ${selectedDateTime.day}', 'Send a gift now!', platformChannelSpecifics,
        payload: 'Default_Sound',);


    }else {
      await flutterLocalNotificationsPlugin!.schedule(2, 'It\'s $name\'s $occasion ${selectedDate.month} ${selectedDateTime.day}'
          , 'Send a gift now!',
          DateTime(selectedDateTime.year, selectedDateTime.month,
              selectedDateTime.day, 12, 0), platformChannelSpecifics);
    }
    final snackBar = SnackBar(content: Text('Reminder Added!'));

    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/ding.mp3"),
      volume: 0.1,

      showNotification: false,
    );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  TextEditingController occasionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    request();

  }

  request()async {
    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }


  _showDialog(context){
    showDialog(
      context: context,
      builder:(c){
        return Padding(
          padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1,
            vertical:   MediaQuery.of(context).size.width*0.55,),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),


            child:  Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: (){
                            Navigator.pop(c);
                          },
                          child: Icon(Icons.close,size: 30,))),
                  Container(

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.green,
                      ),
                      height: 100,
                      width: 100,
                      child: Icon(Icons.check,color: Colors.white,size: 50,)),
                  Text('Reminder Added Successfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ),),

                  GradientButton(
                      onPressed: (){

                        Navigator.pop(c);
                      }, child: Text('Set Another Reminder',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white
                    ),), gradient: gradient1)
                ],
              ),
            ),
          ),
        );
      },
    );
    }

  List holidaysNames=[
    'Valentine’s Day',
    'Easter',
    'Mother’s Day',
    'Father’s Day',
    'Independence Day',
    'Halloween',
    'Thanksgiving',
    'Christmas',
    'Kwanzaa',
    'New Years Eve'
  ];
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
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       checkColor: Colors.white,
                    //       value: isCheckedValentines,
                    //       onChanged: (bool? value) {
                    //         setState(() {
                    //           isCheckedValentines = value!;
                    //         });
                    //       },
                    //     ),
                    //     const Text(
                    //       "Valentines Day",
                    //       style: kTextStyle,
                    //     ),
                    //   ],
                    // ),
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
                          "Holidays",
                          style: kTextStyle,
                        ),
                      ],
                    ),

                    if(isCheckedHolidays)
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Column(
                          children: [
                            for(int i=0;i<holidaysNames.length;i++)
                           ReusableCheckbox(index: i,text: holidaysNames[i]),
                            SizedBox(height: 15,),
                            GradientButton(
                              onPressed: () {
                                DateTime todayDate = DateTime.now();



                                _showDialog(context);

                                  if(holidaysList[0]){
                                   selectedDate = DateTime(todayDate.isAfter(DateTime(todayDate.year,2,14))? todayDate.year+1 : todayDate.year,
                                        2 , 14, 0, 0);
                                    showNotification(selectedDate,'Don\'t forget','Valentine’s Day');
                                  } else if(holidaysList[1]){

                                  } else if (holidaysList[2] ){

                                  }else if (holidaysList[3] ){

                                  }else if (holidaysList[4] ){
                                    selectedDate = DateTime(todayDate.isAfter(DateTime(todayDate.year,7,4))? todayDate.year+1 : todayDate.year,
                                        7 , 4, 0, 0);
                                    showNotification(selectedDate,'Don\'t forget','Independence Day');
                                  }else if (holidaysList[5] ){
                                    selectedDate = DateTime(todayDate.isAfter(DateTime(todayDate.year,10,31))? todayDate.year+1 : todayDate.year,
                                        10 , 31, 0, 0);
                                    showNotification(selectedDate,'Don\'t forget','Halloween Day');
                                  }else if (holidaysList[6] ){

                                  }else if (holidaysList[7] ){
                                    selectedDate = DateTime(todayDate.isAfter(DateTime(todayDate.year,12,25))? todayDate.year+1 : todayDate.year,
                                        12 , 25, 0, 0);
                                    showNotification(selectedDate,'Don\'t forget','Christmas Day');
                                  }else if (holidaysList[8] ){
                                    selectedDate = DateTime(todayDate.isAfter(DateTime(todayDate.year,12,26))? todayDate.year+1 : todayDate.year,
                                        12 , 26, 0, 0);
                                    showNotification(selectedDate,'Don\'t forget','Kwanzaa');
                                  }else if (holidaysList[9] ){
                                    selectedDate = DateTime(todayDate.isAfter(DateTime(todayDate.year,12,31))? todayDate.year+1 : todayDate.year,
                                        12 , 31, 0, 0);
                                    showNotification(selectedDate,'Don\'t forget','New Years Eve');
                                  }
                                  setState(() {
                                    isCheckedHolidays=false;
                                   holidaysList = [false,false,false,false,false,false,false,false,false,false,];
                                  });
                                AssetsAudioPlayer.newPlayer().open(
                                  Audio("assets/ding.mp3"),
                                  volume: 0.1,

                                  showNotification: false,
                                );

                              },
                              child: const Text(
                                "Set Reminder",
                                textAlign: TextAlign.center,
                                style: kButtonTextStyle,
                              ),
                              gradient: gradient1,
                            ),
                            SizedBox(height: 25,),
                          ],
                        ),
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
                    if (isCheckedCustom)
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
                                // height: 51,
                                width: 130,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: dateController,
                                  style: TextStyle(fontSize: 12),
                                  onTap: () {
                                    // DatePicker.showDateTimePicker(context,
                                    //     showTitleActions: true,
                                    //     minTime: DateTime(2022, 1, 1),
                                    //     maxTime: DateTime(2050, 6, 7),
                                    //     onChanged: (date) {
                                    //
                                    //     }, onConfirm: (date) {
                                    //       selectedDate=date;
                                    //       dateController.text = '${date.day}-${date.month}-${date.year}';
                                    //       setState(() {
                                    //
                                    //       });
                                    //       print('confirm $date');
                                    //     }, currentTime: DateTime.now(), locale: LocaleType.en);
                                    pickDate(context);
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



                              _showDialog(context);
                              showNotification(selectedDate,nameController.text,occasionController.text);

                              },
                            child: const Text(
                              "Remind me on this date",
                              textAlign: TextAlign.center,
                              style: kButtonTextStyle,
                            ),
                            gradient: gradient1,
                          ),
                          const SizedBox(height: 15),
                          GradientButton(
                            onPressed: () {
                              DateTime originalDate = selectedDate;

                              selectedDate.subtract(Duration(days: 7));
                              setState(() {

                              });
                              showNotification(selectedDate,nameController.text,occasionController.text + '(7 Days left!)');
                              showNotification(originalDate,nameController.text,occasionController.text);
                            },
                            child: const Text(
                              "Remind me 7 days before",
                              textAlign: TextAlign.center,
                              style: kButtonTextStyle,
                            ),
                            gradient: gradient1,
                          ),
                          const SizedBox(height: 15),
                          GradientButton(
                            onPressed: () {
                              DateTime originalDate = selectedDate;

                              selectedDate.subtract(Duration(days: 14));
                              setState(() {

                              });

                              showNotification(selectedDate,nameController.text,occasionController.text + '(14 Days left!)');

                              showNotification(originalDate,nameController.text,occasionController.text);
                            },
                            child: const Text(
                              "Remind me 14 days before",
                              textAlign: TextAlign.center,
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

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final DateTime? newDate = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kPrimaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            // textButtonTheme: TextButtonThemeData(
            //   style: TextButton.styleFrom(
            //     primary: Colors.white,
            //     backgroundColor: kPrimaryColor,
            //     textStyle: TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ),
          child: child!,
        );
      },
      initialDate: initialDate,
      firstDate: DateTime(2000, 1, 1),
      lastDate:DateTime(2050, 1, 1),
    );

    if (newDate == null) return;

    setState(() {
      date = newDate;
      dateController.text = '${date?.day}-${date?.month}-${date?.year}';
    });
  }
}


class ReusableCheckbox extends StatefulWidget {
  ReusableCheckbox({this.index=0,this.text=""});
  final int index;
  final String text;

  @override
  State<ReusableCheckbox> createState() => _ReusableCheckboxState();
}

class _ReusableCheckboxState extends State<ReusableCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          value: holidaysList[widget.index],
          onChanged: (bool? value) {
            if(holidaysList[widget.index]){
              holidaysList[widget.index]=false;
            }else{
              holidaysList[widget.index]=true;
            }
            setState(() {});
          },
        ),
         Text(
          widget.text,
          style: kTextStyle,
        ),
      ],
    );
  }
}
