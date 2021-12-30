import 'package:contacts_service/contacts_service.dart';

Future<void> getContacts() async {
  Iterable<Contact> contacts =
      await ContactsService.getContacts(withThumbnails: false);
  List<Contact> contactsList = contacts.toList();

  // now print first 50 number's contacts
  for (int i = 0; i < 50; i++) {
    print(contactsList[i].phones!.first.value.toString());
  }
}
