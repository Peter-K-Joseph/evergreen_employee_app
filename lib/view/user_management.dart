import 'package:evergreen_employee_app/mischelaneous/http_requests.dart';
import 'package:evergreen_employee_app/mischelaneous/overlays.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserManagement extends StatelessWidget {
  const UserManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modify Employee Records',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => const NewUserCreation(),
                transition: Transition.downToUp,
              );
            },
            icon: const Hero(
              tag: "user_add_icon",
              child: Icon(
                Icons.person_add_alt_1_outlined,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: HttpRequests().getUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.body.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${snapshot.data!.body[index]['name']}',
                    ),
                    subtitle: Text(
                      snapshot.data!.body[index]['department'],
                    ),
                    leading: Container(
                      height: 35.0,
                      width: 35.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: randomColorGenerator(),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: snapshot.data!.body[index]['photo_url'] != '' &&
                                snapshot.data!.body[index]['photo_url'] != null
                            ? Image.network(
                                snapshot.data!.body[index]['photo_url'],
                                fit: BoxFit.contain,
                              )
                            : Center(
                                child: Text(
                                  snapshot.data!.body[index]['name'][0],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      )),
    );
  }
}

class NewUserCreation extends StatelessWidget {
  const NewUserCreation({super.key});

  InputDecoration decorationReturner(String hint, String label, IconData icon) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      floatingLabelStyle: TextStyle(color: Colors.grey.shade800),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.grey.shade500,
          width: 1.5,
        ),
      ),
      prefixIcon: Icon(icon),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Hero(
              tag: "user_add_icon",
              child: Icon(
                Icons.person_add_alt_1_outlined,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'New User',
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[],
                  ),
                ),
                TextFormField(
                  decoration: decorationReturner(
                    'Peter K Joseph',
                    'Name',
                    Icons.person_outline_rounded,
                  ),
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: decorationReturner(
                    'peter@evergreenpv.com',
                    'Email',
                    Icons.email_outlined,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: decorationReturner(
                    '9879756654',
                    'Phone Number',
                    Icons.contact_phone_outlined,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Department',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Designation',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Create',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
