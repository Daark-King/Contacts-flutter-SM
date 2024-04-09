import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Contact App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/new-contact': (context) => const NewContactView(),
      },
    ),
  );
}

class Contact {
  final String name;

  Contact({required this.name});
}

class ContactBook {
  ContactBook._sharedInstance();
  static final ContactBook shared = ContactBook._sharedInstance();
  factory ContactBook() => shared;

  final List<Contact> contacts = [];

  int get length => contacts.length;

  void add({required Contact contact}) {
    contacts.add(contact);
  }

  void remove({required Contact contact}) {
    contacts.remove(contact);
  }

  Contact? contact({
    required int atIndex,
  }) =>
      length > atIndex ? contacts[atIndex] : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactBook contactBook = ContactBook();
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Home Page')),
          backgroundColor: Colors.deepPurple,
        ),
        body: ListView.builder(
          itemCount: contactBook.length,
          itemBuilder: (contex, index) {
            final contact = contactBook.contact(atIndex: index)!;
            return ListTile(
              title: Text(contact.name),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).pushNamed('/new-contact');
          },
          child: const Icon(Icons.add),
        ));
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Contact'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter a new contact name here',
            ),
          ),
          TextButton(
            onPressed: () {
              final contact = Contact(name: _controller.text);
              ContactBook().add(contact: contact);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Add Contact',
            ),
          )
        ],
      ),
    );
  }
}
