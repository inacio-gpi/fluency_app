import 'package:fluency_app/features/path/data/datasources/path_local_datasource.dart';
import 'package:fluency_app/features/path/data/datasources/path_mock_datasource.dart';
import 'package:fluency_app/features/path/domain/repositories/path_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([PathRepository, PathMockDataSource, PathLocalDataSource])
void main() {}
