import 'package:flutter/material.dart';

//· Proveedor de estado para manejar la navegación y el estado de la interfaz de usuario
class UIProvider extends ChangeNotifier {
  int _selectedMenuOpt = 0;

  //* Getter para obtener el valor de _selectedMenuOpt
  int get selectedMenuOpt {
    return _selectedMenuOpt;
  }

  //* Establece el valor de _selectedMenuOpt y notifica a los oyentes
  set selectedMenuOpt(int menu) {
    _selectedMenuOpt = menu;
    notifyListeners();
  }
}
