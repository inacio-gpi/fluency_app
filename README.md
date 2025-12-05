# Fluency App - Mini Fluency Learning Path

Uma aplicação Flutter que implementa uma trilha de aprendizado de inglês, inspirada na experiência da Fluency Academy.

## 📋 Sobre o Projeto

Este projeto foi desenvolvido como um desafio Flutter para criar uma aplicação de trilha de aprendizado com lições e tarefas. A aplicação permite que os usuários visualizem seu progresso em uma trilha de aprendizado, acessem lições individuais e marquem tarefas como concluídas.

## 🏗️ Arquitetura

O projeto segue os princípios de **Clean Architecture** com uma estrutura bem definida em três camadas:

### Camadas

1. **Domain (Domínio)**

   - Entidades: `LearningPath`, `Lesson`, `Task`
   - Repositórios (interfaces): `PathRepository`
   - Casos de Uso: `GetLearningPath`, `GetLesson`, `UpdateLessonProgress`

2. **Data (Dados)**

   - Models: Implementações das entidades com serialização JSON
   - DataSources: `PathMockDataSource`, `PathLocalDataSource`
   - Repositories (implementação): `PathRepositoryImpl`

3. **Presentation (Apresentação)**
   - Controllers: Gerenciamento de estado personalizado
   - Pages: Telas da aplicação
   - Widgets: Componentes reutilizáveis

### Estrutura de Pastas

```
lib/
├── core/
│   ├── errors/              # Failures e Exceptions
│   ├── injection/           # Injeção de dependência (GetIt)
│   ├── presentation/        # BaseController (abstração setState)
│   ├── routes/              # Rotas da aplicação
│   ├── storage/             # HiveStorageManager
│   ├── theme/               # Tema da aplicação
│   └── usecase/             # UseCase abstrato
├── features/
│   ├── path/
│   │   ├── domain/          # Entidades, repositórios, casos de uso
│   │   ├── data/            # Models, datasources, repositório impl
│   │   └── presentation/    # Controller, pages, widgets
│   └── lesson/
│       └── presentation/    # Controller, pages, widgets
└── main.dart
```

## 🎨 Gerenciamento de Estado

Foi implementada uma **abstração customizada usando setState** que funciona de forma similar ao Bloc:

### BaseController

```dart
abstract class BaseController<S> extends ChangeNotifier {
  S _state;

  BaseController(this._state);

  S get state => _state;

  @protected
  void emit(S newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }
}
```

### Como Funciona

- **Events**: Classes que representam eventos (ex: `LoadPathEvent`, `ToggleTaskCompletionEvent`)
- **States**: Classes que representam estados (ex: `PathLoading`, `PathLoaded`, `PathError`)
- **Controller**: Recebe eventos através do método `handleEvent()` e emite estados usando `emit()`
- **UI**: Escuta mudanças de estado através de `addListener()` e reconstrui quando necessário

### Exemplo de Uso

```dart
// Controller
class PathController extends BaseController<PathState> {
  PathController({required this.getLearningPath}) : super(PathInitial());

  void handleEvent(PathEvent event) {
    if (event is LoadPathEvent) {
      _onLoadPath();
    }
  }

  Future<void> _onLoadPath() async {
    emit(PathLoading());
    final result = await getLearningPath();
    result.fold(
      (failure) => emit(PathError(message: failure.message)),
      (path) => emit(PathLoaded(path: path)),
    );
  }
}

// Na UI
@override
void initState() {
  super.initState();
  widget.controller.addListener(_onStateChanged);
  widget.controller.handleEvent(LoadPathEvent());
}

void _onStateChanged() {
  if (mounted) {
    setState(() {});
  }
}
```

## 💾 Armazenamento Local

O projeto utiliza **Hive** para persistência local:

### HiveStorageManager

- **Singleton Pattern**: Instância única gerenciada globalmente
- **Gerenciamento de Boxes**: Abertura e cache automático de boxes
- **API Simplificada**: Métodos `get()`, `put()`, `delete()`, `clear()`
- **Reutilizável**: Pode ser usado por qualquer feature

### Vantagens

- Não é necessário inicializar boxes manualmente em cada datasource
- Gerenciamento centralizado de boxes
- Fácil de testar e mockar
- Tratamento de erros consistente

## 🎯 Funcionalidades

### Tela da Trilha (Path)

- ✅ Visualização da trilha de aprendizado
- ✅ Lista de lições com indicadores visuais de status:
  - **Completed**: Lição completada (verde com ícone de check)
  - **Current**: Lição atual (azul com ícone de play)
  - **Locked**: Lição bloqueada (cinza com ícone de cadeado)
- ✅ Progresso geral da trilha
- ✅ Animações ao carregar lições
- ✅ Refresh para recarregar dados
- ✅ Navegação para tela de tarefas ao clicar na lição

### Tela de Tarefas (Lesson Tasks)

- ✅ Visualização de todas as tarefas da lição
- ✅ Informações da lição (XP, tempo estimado)
- ✅ Progresso de conclusão das tarefas
- ✅ Marcar/desmarcar tarefas como concluídas
- ✅ Diferentes tipos de tarefas com ícones personalizados:
  - Ouça e Repita (headphones)
  - Múltipla Escolha (quiz)
  - Preencher Lacunas (edit)
  - Ordenação (reorder)
  - Role-play (voice)
- ✅ Animações ao marcar tarefas
- ✅ Persistência automática do progresso
- ✅ Visual feedback com cores e estados

## 🚀 Como Executar

### Pré-requisitos

- Flutter 3.10.1 ou superior
- Dart SDK

### Instalação

1. Clone o repositório:

```bash
cd fluency_app
```

2. Instale as dependências:

```bash
flutter pub get
```

3. Execute o aplicativo:

```bash
flutter run
```

### Build para Produção

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🔮 Próximos Passos

Se tivesse mais tempo, implementaria:

### Melhorias Técnicas

1. **Desacoplamento de Dependências Externas**

   - Criar **NavigationAdapter** para abstrair GetX navigation
   - Implementar **DependencyInjectionAdapter** para isolar GetX DI
   - Criar interfaces para serviços externos (storage, http, etc)
   - Facilitar migração futura para outras soluções (Provider, Riverpod, etc)
   - Reduzir acoplamento e aumentar testabilidade

2. **Testes Completos**

   - Aumentar cobertura de testes para 90%+

3. **Arquitetura e Código**

   - Adicionar **Logging** estruturado e rastreável
   - Implementar **Error Handling** centralizado

4. **CI/CD**

   - GitHub Actions para testes automáticos
   - Pipeline de build e deploy
   - Code quality checks (linting, formatting)
   - Análise de cobertura de testes
   - Deploy automático para ambientes de staging/produção

5. **Internacionalização**

   - Suporte a múltiplos idiomas
   - Localização de conteúdo
   - Formatação de datas e números por região
   - RTL (Right-to-Left) support

## 🤝 Contribuindo

Este é um projeto de desafio, mas sugestões são bem-vindas!

## 📄 Licença

Este projeto é parte de um desafio técnico.

---
