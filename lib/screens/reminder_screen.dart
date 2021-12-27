import 'package:flutter/material.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool isCheckedValentines = false;
  bool isCheckedHolidays = false;
  bool isCheckedCustom = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/Send LOve Icon envelope.png',
                      height: 68,
                      width: 68,
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
                const SizedBox(height: 30),
                SizedBox(
                  height: 51,
                  width: 368,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Recipient\'s Name",
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
                  onPressed: () {},
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
          ),
        ),
      ),
    );
  }
}
