import 'dart:developer';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:universal_io/io.dart';

// A valid Dart identifier that can be used for a package, i.e. no
// capital letters.
// https://dart.dev/guides/language/language-tour#important-concepts
final RegExp _identifierRegExp = RegExp(r'[a-z_][a-z\d_]*');
final RegExp _orgNameRegExp = RegExp(r'^[a-zA-Z][\w-]*(\.[a-zA-Z][\w-]*)+$');

class CreateCommand extends Command<int> {
  CreateCommand() {
    argParser.addOption('name', abbr: 'n', defaultsTo: 'my_awesme_project');
  }
  @override
  String get description => 'Creates a new flutter project.';

  @override
  String get name => 'create';

  @override
  String get invocation => 'clean_cli create <project name>';

  @override
  String get summary => '$invocation\n$description';

  ArgResults? argResultOverrides;

  ArgResults get _argResults => argResultOverrides ?? argResults!;

  @override
  Future<int> run() async {
    Logger().progress('Bootstrapping');
    print(_projectName);
    final response = await MasonGenerator.fromBrick(
      Brick.git(
        GitPath(
          'https://github.com/felangel/mason',
          path: 'bricks/greeting',
        ),
      ),
    );
    // TODO: Generate on Path
    print(response.files.map((e) => e.path));
    return ExitCode.success.code;
  }

  String get _projectName {
    final rest = _argResults.rest;
    final projectName = rest.first;
    _validateProjectName(projectName);
    return projectName;
  }

  void _validateProjectName(String name) {
    final isValidProjectName = _isValidPackageName(name);
    if (!isValidProjectName) {
      throw UsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }
  }

  bool _isValidOrgName(String name) {
    return _orgNameRegExp.hasMatch(name);
  }

  bool _isValidPackageName(String name) {
    final match = _identifierRegExp.matchAsPrefix(name);
    return match != null && match.end == name.length;
  }
}
