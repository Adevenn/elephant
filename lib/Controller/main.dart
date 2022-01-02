import '/View/controller_view.dart';
import 'controller.dart';

void main() {
  Controller controller = Controller();
  ControllerView controllerView = ControllerView(controller);
  controllerView.start();
}