import 'package:evergreen_employee_app/mischelaneous/http_requests.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrevRecordsEmployee extends StatelessWidget {
  const PrevRecordsEmployee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Previous Records"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: HttpRequests().getHoursWorkedInDateRange(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.body.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {},
                      title: Text(snapshot.data!.body[index]["month"]),
                      leading: const Icon(Icons.calendar_today),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      subtitle: Text(
                          'Worked ${snapshot.data!.body[index]["hour"].toString()} hrs / ${snapshot.data!.body[index]["total"].toString()} entries'),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
