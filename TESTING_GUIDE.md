# 🧪 Guia de Testes - Fluency App

Este documento descreve a estratégia e implementação de testes no projeto Fluency App.

## 📋 Sumário

- [Visão Geral](#visão-geral)
- [Estrutura de Testes](#estrutura-de-testes)
- [Executando Testes](#executando-testes)
- [Cobertura de Código](#cobertura-de-código)
- [Tipos de Testes](#tipos-de-testes)

## 🎯 Visão Geral

O projeto implementa testes seguindo os princípios de **Clean Architecture**, com testes organizados por camadas:

- **Domain Layer**: Testes de entidades e use cases
- **Data Layer**: Testes de models, repositories e data sources
- **Presentation Layer**: Testes de controllers e widgets

### Ferramentas Utilizadas

- **flutter_test**: Framework de testes do Flutter
- **mockito**: Para criação de mocks
- **build_runner**: Para geração automática de mocks
- **test**: Package adicional de testes Dart

## 📁 Estrutura de Testes

```
test/
├── core/
│   └── storage/
│       └── hive_storage_manager_test.dart
├── features/
│   ├── lesson/
│   │   └── presentation/
│   │       ├── controller/
│   │       │   └── lesson_controller_test.dart
│   │       └── widgets/
│   │           └── task_card_test.dart
│   └── path/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── path_mock_datasource_test.dart
│       │   └── models/
│       │       ├── learning_path_model_test.dart
│       │       ├── lesson_model_test.dart
│       │       └── task_model_test.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── learning_path_test.dart
│       │   │   ├── lesson_test.dart
│       │   │   └── task_test.dart
│       │   └── usecases/
│       │       ├── get_learning_path_test.dart
│       │       ├── get_lesson_test.dart
│       │       ├── reset_progress_test.dart
│       │       └── update_lesson_progress_test.dart
│       └── presentation/
│           ├── controller/
│           │   └── path_controller_test.dart
│           └── widgets/
│               └── lesson_node_test.dart
├── fixtures/
│   └── fixtures.dart
├── helpers/
│   └── test_helper.dart
└── widgets/
    ├── animated_linear_progress_indicator_test.dart
    ├── animated_progress_indicator_test.dart
    └── widget_test.dart
```

## 🚀 Executando Testes

### Comandos Básicos

```bash
# Executar todos os testes
flutter test

# Executar testes de um arquivo específico
flutter test test/features/path/domain/entities/task_test.dart

# Executar testes com cobertura
flutter test --coverage

# Executar testes em modo watch (observa mudanças)
flutter test --watch
```

### Scripts Personalizados

O projeto inclui scripts úteis para facilitar a execução de testes:

#### 1. Testes com Cobertura HTML

```bash
./run_tests_with_coverage.sh
```

Este script:
- Executa todos os testes
- Gera relatório de cobertura
- Cria HTML visual da cobertura
- Abre automaticamente no navegador

#### 2. Resumo de Cobertura

```bash
./test_coverage_summary.sh
```

Este script mostra:
- Total de linhas testadas
- Percentual de cobertura
- Resumo por arquivo

## 📊 Cobertura de Código

### Visualizando Cobertura

Após executar `flutter test --coverage`, você pode:

1. **Ver arquivo bruto**: `coverage/lcov.info`
2. **Gerar HTML** (requer lcov):
   ```bash
   genhtml coverage/lcov.info -o coverage/html
   open coverage/html/index.html
   ```

### Instalando lcov

```bash
# macOS
brew install lcov

# Ubuntu/Debian
sudo apt-get install lcov

# Windows (WSL)
sudo apt-get install lcov
```

### Metas de Cobertura

O projeto visa manter:
- **Domain Layer**: > 90% de cobertura
- **Data Layer**: > 80% de cobertura
- **Presentation Layer**: > 75% de cobertura
- **Cobertura Geral**: > 80%

## 🧩 Tipos de Testes

### 1. Testes de Entidades (Domain)

Testam a lógica de negócio das entidades.

**Exemplo: Task Entity**
```dart
test('copyWith should return new instance with updated values', () {
  const task = Task(id: '1', title: 'Test', ...);
  final updated = task.copyWith(isCompleted: true);
  
  expect(updated.isCompleted, true);
  expect(updated.id, task.id);
});
```

**O que é testado:**
- ✅ Criação de entidades
- ✅ Método `copyWith`
- ✅ Cálculos (progress, totals)
- ✅ Equality

### 2. Testes de Use Cases

Testam a orquestração de lógica de negócio.

**Exemplo: GetLearningPath**
```dart
test('should get learning path from repository', () async {
  // arrange
  when(mockRepository.getLearningPath())
      .thenAnswer((_) async => Right(tLearningPath));

  // act
  final result = await useCase();

  // assert
  expect(result, Right(tLearningPath));
  verify(mockRepository.getLearningPath());
});
```

**O que é testado:**
- ✅ Chamada correta ao repositório
- ✅ Tratamento de sucesso (Right)
- ✅ Tratamento de erro (Left)
- ✅ Transformação de dados

### 3. Testes de Models (Data)

Testam serialização e deserialização de dados.

**Exemplo: TaskModel**
```dart
group('fromMap', () {
  test('should return a valid model from JSON', () {
    final jsonMap = {
      'id': 'task_1',
      'title': 'Test Task',
      'type': 'listen_repeat',
      'estimatedSeconds': 60,
    };

    final result = TaskModel.fromMap(jsonMap);

    expect(result, isA<Task>());
    expect(result.id, 'task_1');
  });
});
```

**O que é testado:**
- ✅ Conversão de JSON para modelo
- ✅ Conversão de modelo para JSON
- ✅ Valores padrão
- ✅ Herança de entidades

### 4. Testes de Controllers (Presentation)

Testam o gerenciamento de estado.

**Exemplo: PathController**
```dart
test('should emit [PathLoading, PathLoaded] when data is gotten successfully',
    () async {
  // arrange
  when(mockGetLearningPath())
      .thenAnswer((_) async => Right(tLearningPath));

  // assert later
  expectLater(
    controller.stream,
    emitsInOrder([
      PathLoading(),
      PathLoaded(path: tLearningPath),
    ]),
  );

  // act
  controller.handleEvent(LoadPathEvent());
});
```

**O que é testado:**
- ✅ Estado inicial
- ✅ Transições de estado
- ✅ Tratamento de eventos
- ✅ Tratamento de erros

### 5. Testes de Widgets

Testam a renderização e interação de componentes.

**Exemplo: TaskCard**
```dart
testWidgets('should call onToggle when tapped',
    (WidgetTester tester) async {
  bool wasTapped = false;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: TaskCard(
          task: tTask,
          isCompleted: false,
          onToggle: () { wasTapped = true; },
        ),
      ),
    ),
  );

  await tester.tap(find.byType(Card));
  await tester.pumpAndSettle();

  expect(wasTapped, true);
});
```

**O que é testado:**
- ✅ Renderização correta
- ✅ Exibição de texto e ícones
- ✅ Interações (tap, scroll)
- ✅ Animações
- ✅ Estados visuais

## 🎨 Boas Práticas

### 1. Organização

```dart
group('Feature/Component', () {
  late MyClass sut; // System Under Test
  late MockDependency mockDep;

  setUp(() {
    mockDep = MockDependency();
    sut = MyClass(mockDep);
  });

  tearDown(() {
    // Cleanup
  });

  test('should do something', () {
    // arrange
    // act
    // assert
  });
});
```

### 2. Nomenclatura

- Use nomes descritivos: `should return valid data when API call succeeds`
- Siga o padrão AAA: Arrange, Act, Assert
- Agrupe testes relacionados com `group()`

### 3. Mocks

```dart
// Gerar mocks com build_runner
// No arquivo test/helpers/test_helper.dart:
@GenerateMocks([
  PathRepository,
  PathMockDataSource,
])
void main() {}

// Gerar:
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Fixtures

Centralize dados de teste em `test/fixtures/fixtures.dart`:

```dart
class Fixtures {
  static Task get task1 => const Task(...);
  static Lesson get currentLesson => Lesson(...);
  static LearningPath get learningPath => LearningPath(...);
}
```

## 📈 Melhorias Futuras

- [ ] Testes de integração
- [ ] Testes de performance
- [ ] Testes de acessibilidade
- [ ] Golden tests (snapshot visual)
- [ ] Testes E2E com `integration_test`

## 🐛 Troubleshooting

### Problema: Mocks não encontrados

**Solução:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Problema: Coverage não gera HTML

**Solução:**
```bash
# Instalar lcov
brew install lcov  # macOS
sudo apt-get install lcov  # Linux
```

### Problema: Testes falhando por timeout

**Solução:**
```dart
testWidgets('my test', (tester) async {
  // ...
}, timeout: const Timeout(Duration(seconds: 60)));
```

## 📚 Recursos

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Mockito Package](https://pub.dev/packages/mockito)
- [Test Package](https://pub.dev/packages/test)
- [Very Good Ventures Testing Guide](https://verygood.ventures/blog/guide-to-flutter-testing)

---

**Última atualização**: Dezembro 2025

