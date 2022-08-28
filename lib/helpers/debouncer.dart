import 'dart:async';
// Creditos
// https://stackoverflow.com/a/52922130/7834829

class Debouncer<T> {

  Debouncer({ 
    required this.duration, 
    this.onValue 
  });

  final Duration duration; // cantidad de tiempo a esperar de un valor 

  void Function(T value)? onValue; // respuesta

  T? _value; // valor 
  Timer? _timer; // funcion de control 
  
  T get value => _value!;

  set value(T val) {
    _value = val;
    _timer?.cancel();
    _timer = Timer(duration, () => onValue!(_value!));
  }  
}