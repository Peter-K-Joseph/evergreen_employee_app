import 'dart:io';
import 'dart:math';

import 'package:evergreen_employee_app/mischelaneous/http_requests.dart';
import 'package:evergreen_employee_app/model/http_requests_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class PeopleController extends GetxController {
  int currentPlaceholderIndex = 0;
  Rx<Widget> current = (const Center(
    child: Column(children: [
      CircularProgressIndicator(),
      SizedBox(
        height: 10,
      ),
      Text('Activating Extensions'),
    ]),
  ) as Widget)
      .obs;

  void updateOnFilter({required String searchQuery}) {}

  getDepartments() async {
    HTTPResponseBody response = await HttpRequests().getDepartments();
    if (response.statusCode == HttpStatus.ok) {
      current.value = RefreshIndicator(
        onRefresh: () async {
          await getDepartments();
        },
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: response.body.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(response.body[index]["name"]),
              trailing: const Icon(Icons.arrow_forward_ios),
              leading: const Icon(
                Icons.school_outlined,
              ),
              onTap: () {
                getPeople(department: response.body[index]["id"].toString());
              },
            );
          },
        ),
      );
    } else {
      current.value = Center(
        child: RefreshIndicator(
          onRefresh: () async {
            await getDepartments();
          },
          child: SizedBox(
            height: MediaQuery.of(Get.context!).size.height,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 160,
                  ),
                  const Icon(
                    Icons.error_outline,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Something went wrong.\nPlease try again later\n\nnuvie_release ERR#${response.statusCode}\n\n${response.body['message']}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      getDepartments();
                    },
                    child: const SizedBox(
                      width: 150,
                      child: Row(
                        children: [
                          Spacer(),
                          Icon(
                            Icons.refresh,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Retry',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
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

  getPeople({required String department}) async {
    HTTPResponseBody response = await HttpRequests().getPeople(department);
    if (response.statusCode == HttpStatus.ok) {
      current.value = ListView.builder(
        shrinkWrap: true,
        itemCount: response.body.length + 1,
        itemBuilder: (context, index) {
          if (response.body.length == 0) {
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Icon(
                  Icons.person_search_outlined,
                  size: 100,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'No Employee Found',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    getDepartments();
                  },
                  child: const SizedBox(
                    width: 150,
                    child: Row(
                      children: [
                        Spacer(),
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Go Back',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          if (index == 0) {
            return ListTile(
              title: const Text('Go Back'),
              leading: const Icon(
                Icons.arrow_back_ios,
              ),
              onTap: () {
                getDepartments();
              },
            );
          }
          return ListTile(
            title: Text(response.body[index - 1]['name']),
            subtitle: Text(response.body[index - 1]['employee_id']),
            trailing: const Icon(Icons.arrow_forward_ios),
            leading: const Icon(
              Icons.person_outlined,
            ),
            onTap: () {
              Get.to(
                () => ContactInfoDisplay(
                  memberID: response.body[index - 1]['employee_id'],
                ),
              );
            },
          );
        },
      );
    } else {
      current.value = const Center(
        child: Text('Something went wrong'),
      );
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getDepartments();
  }
}

class ContactInfoDisplay extends StatelessWidget {
  const ContactInfoDisplay({
    Key? key,
    required this.memberID,
  }) : super(key: key);

  final String memberID;

  Color randomColorGenerator() {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      const Color.fromARGB(255, 232, 102, 255),
      Colors.orange,
      const Color.fromARGB(255, 255, 113, 160),
      Colors.teal,
      const Color.fromARGB(255, 255, 177, 149),
      const Color.fromARGB(255, 109, 131, 255),
    ];
    // geberate radom number
    int randomNumber = Random().nextInt(colors.length);
    return colors[randomNumber];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Info'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            FutureBuilder(
              future: HttpRequests().getEmployeeDetails(memberID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 100.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: randomColorGenerator(),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: snapshot.data!.body['photo_url'] != null
                                  ? Image.network(
                                      snapshot.data!.body['photo_url'],
                                      fit: BoxFit.contain,
                                    )
                                  : Center(
                                      child: Text(
                                        '${snapshot.data!.body['name'][0]}',
                                        style: const TextStyle(fontSize: 50),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            snapshot.data!.body['name'],
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: snapshot.data!.body['email'],
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to clipboard'),
                                ),
                              );
                            },
                            child: Text(
                              snapshot.data!.body['email'],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: snapshot.data!.body['phone'],
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to clipboard'),
                                ),
                              );
                            },
                            child: Text(
                              snapshot.data!.body['phone'],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // SEND MAIL
                              launchUrl(Uri.parse(
                                  'mailto:${snapshot.data!.body['email']}'));
                            },
                            child: const Text('Send Mail'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // CALL
                              launchUrl(Uri.parse(
                                  'tel:${snapshot.data!.body['phone']}'));
                            },
                            child: const Text('Call'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // WHATSAPP
                              launchUrl(Uri.parse(
                                  'https://wa.me/${snapshot.data!.body['phone']}'));
                            },
                            child: const Text('WhatsApp'),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return const Center(
                  child: Text('Something went wrong'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
