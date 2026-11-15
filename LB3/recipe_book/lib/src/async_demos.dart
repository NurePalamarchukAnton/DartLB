import 'dart:async';

import 'async_repository.dart';
import 'difficulty.dart';
import 'heavy_compute.dart';
import 'ingredient.dart';
import 'recipe.dart';

/// Демонстрація «забутого await».
Future<void> demoForgottenAwait(AsyncRecipeRepository<Recipe> repo) async {
  print('--- забутий await ---');
  unawaited(
    repo.load('missing').then((value) {
      print('пізній результат load: $value');
    }),
  );
  print('рядок після виклику без await');
  await Future<void>.delayed(const Duration(milliseconds: 400));
}

/// Stopwatch: послідовно vs Future.wait.
Future<void> demoStopwatch() async {
  print('--- Stopwatch ---');
  Future<void> op() => Future<void>.delayed(const Duration(milliseconds: 500));

  final sequential = Stopwatch()..start();
  await op();
  await op();
  await op();
  sequential.stop();
  print('послідовно: ${sequential.elapsedMilliseconds} мс');

  final parallel = Stopwatch()..start();
  await Future.wait([op(), op(), op()]);
  parallel.stop();
  print('Future.wait: ${parallel.elapsedMilliseconds} мс');
}

/// Future.wait vs ParallelWaitError.
Future<void> demoParallelErrors() async {
  print('--- помилки групи ---');
  Future<String> ok(String label) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return label;
  }

  Future<String> fail() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    throw StateError('збій операції');
  }

  try {
    await Future.wait([ok('a'), fail(), ok('c')]);
  } on Object catch (error) {
    print('Future.wait: $error');
  }

  try {
    await (ok('a'), fail(), ok('c')).wait;
  } on ParallelWaitError<
    (String?, String?, String?),
    (AsyncError?, AsyncError?, AsyncError?)
  > catch (error) {
    print('ParallelWaitError values=${error.values} errors=${error.errors}');
  }
}

/// try/catch без await.
Future<void> demoUncaughtAsync() async {
  print('--- неспіймана async-помилка ---');
  try {
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 10), () {
        throw StateError('пізня помилка');
      }).catchError((Object error) {
        print('спіймано через catchError: $error');
      }),
    );
    print('try/catch навколо виклику без await завершився одразу');
  } on Object catch (error) {
    print('несподівано спіймано в try: $error');
  }
  await Future<void>.delayed(const Duration(milliseconds: 50));
}

/// Лінивість async*.
Future<void> demoAsyncStar(AsyncRecipeRepository<Recipe> repo) async {
  print('--- async* ---');
  final stream = repo.watchAll();
  print('генератор створено, підписки ще немає');
  await for (final recipe in stream.take(2)) {
    print('отримано: ${recipe.title}');
  }
}

/// StreamController.
Future<void> demoController() async {
  print('--- StreamController ---');
  final controller = StreamController<CatalogEvent>();
  controller.add(RecipeAdded(_sample()));
  controller.add(RecipeUpdated(_sample()));
  controller.add(RecipeRemoved('x'));

  final subscription = controller.stream.listen(
    (event) => print('listen: ${event.label}'),
    onError: (Object error) => print('listen error: $error'),
    cancelOnError: false,
  );

  await Future<void>.delayed(const Duration(milliseconds: 20));
  controller.addError(StateError('помилка в потоці'));
  controller.add(RecipeRemoved('after-error'));
  await Future<void>.delayed(const Duration(milliseconds: 20));
  await subscription.cancel();
  await controller.close();
  print('підписку скасовано');
}

/// Single vs broadcast.
Future<void> demoBroadcast() async {
  print('--- single vs broadcast ---');
  final single = StreamController<int>();
  single.stream.listen((_) {});
  try {
    single.stream.listen((_) {});
  } on Object catch (error) {
    print('повторна підписка single: $error');
  }
  await single.close();

  final broadcast = StreamController<int>.broadcast();
  broadcast.stream.listen((value) => print('b1:$value'));
  broadcast.stream.listen((value) => print('b2:$value'));
  broadcast.add(1);
  await Future<void>.delayed(Duration.zero);
  await broadcast.close();
}

/// Конвеєр Stream.
Future<void> demoStreamPipeline(AsyncRecipeRepository<Recipe> repo) async {
  print('--- конвеєр Stream ---');
  final labels = await repo
      .watchAll()
      .where((recipe) => recipe.cookMinutes <= 30)
      .map((recipe) => recipe.title)
      .take(3)
      .toList();
  print(labels.join(', '));
}

/// Isolate.run.
Future<void> demoIsolate() async {
  print('--- Isolate.run ---');
  sharedCounter = 0;
  const limit = 250000;

  final localWatch = Stopwatch()..start();
  final local = countPrimes(limit);
  localWatch.stop();
  print(
    'головний ізолят: $local за ${localWatch.elapsedMilliseconds} мс, '
    'sharedCounter=$sharedCounter',
  );

  final before = sharedCounter;
  final isoWatch = Stopwatch()..start();
  final remote = await countPrimesInIsolate(limit);
  isoWatch.stop();
  print(
    'Isolate.run: $remote за ${isoWatch.elapsedMilliseconds} мс, '
    'sharedCounter після=$sharedCounter (було $before)',
  );
}

Recipe _sample() =>
    Recipe('Sample', 'Test', 20, Difficulty.easy, [Ingredient('salt', 1)]);
