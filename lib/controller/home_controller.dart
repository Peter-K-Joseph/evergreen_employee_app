import 'package:evergreen_employee_app/mischelaneous/database.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString greetings = "Hello".obs;
  RxString name = "...".obs;
  RxString imageURL =
      'https://lh3.googleusercontent.com/a/AAcHTtfyfIvLYQYanOU2FFYjMI7Av99Sren7hnx1Sftm88wsbac=s576-c-no'
          .obs;

  void generateGreetings() {
    var hour = DateTime.now().hour;
    var day = DateTime.now().weekday;
    if (hour < 12) {
      greetings.value = "Good Morning";
    } else if (hour < 17) {
      greetings.value = "Good Afternoon";
    } else {
      greetings.value = "Good Evening";
    }
    if (day == DateTime.sunday) {
      greetings.value = "Happy Sunday";
    }
  }

  void updateUserInformation() async {
    var name = await DatabaseStore().getEmployee();
    this.name.value = name[0]["name"];
  }

  @override
  void onInit() {
    super.onInit();
    generateGreetings();
    updateUserInformation();
  }
}
