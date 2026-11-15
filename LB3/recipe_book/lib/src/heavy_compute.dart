import 'dart:isolate';
import 'dart:math';

/// Глобальна змінна для демонстрації ізоляції пам’яті.
int sharedCounter = 0;

/// Підрахунок простих чисел (важке синхронне обчислення).
int countPrimes(int limit) {
  sharedCounter += 1;
  var count = 0;
  for (var n = 2; n <= limit; n++) {
    if (_isPrime(n)) {
      count += 1;
    }
  }
  return count;
}

bool _isPrime(int value) {
  if (value < 2) {
    return false;
  }
  final root = sqrt(value).toInt();
  for (var i = 2; i <= root; i++) {
    if (value % i == 0) {
      return false;
    }
  }
  return true;
}

/// Запуск у окремому ізоляті.
Future<int> countPrimesInIsolate(int limit) {
  return Isolate.run(() => countPrimes(limit));
}
