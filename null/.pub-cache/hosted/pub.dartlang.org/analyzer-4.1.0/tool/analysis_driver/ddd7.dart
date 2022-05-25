import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/memory_file_system.dart';
import 'package:analyzer/src/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/src/test_utilities/mock_sdk.dart';

void main() async {
  final resourceProvider = MemoryResourceProvider();

  final sdkRoot = resourceProvider.getFolder('/sdk');
  createMockSdk(
    resourceProvider: resourceProvider,
    root: sdkRoot,
  );

  resourceProvider.newFile('/home/test/lib/a.dart', r'''
void f(int a) {
  a as int;
}
''');

  resourceProvider.newFile('/home/test/lib/b.dart', r'''
void f(int a) {}
''');

  var file = resourceProvider.newFile('/home/test/lib/test.dart', r'''
import 'a.dart'
  if (my.flag) 'b.dart';
''');

  final collection = AnalysisContextCollectionImpl(
    includedPaths: ['/home'],
    resourceProvider: resourceProvider,
    sdkPath: sdkRoot.path,
    declaredVariables: {
      'my.flag': 'false',
    },
  );

  final analysisContext = collection.contextFor(file.path);
  final analysisSession = analysisContext.currentSession;

  final unitResult = await analysisSession.getResolvedUnit(file.path);
  unitResult as ResolvedUnitResult;

  print(
    unitResult.libraryElement.importedLibraries
        .map((e) => e.source.fullName)
        .toList(),
  );
}
