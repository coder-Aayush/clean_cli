import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:clean_cli/src/commands/create/create.dart';
import 'package:mason/mason.dart';

class CleanCliCommandRunner extends CommandRunner<int> {
  static const timeout = Duration(milliseconds: 500);

  CleanCliCommandRunner() : super('clean_cli', 'Clean CLI') {
    addCommand(CreateCommand());
  }

  @override
  Future<int> run(Iterable<String> args) async {
    final argsResult = parse(args);
    return await runCommand(argsResult);
  }

  @override
  Future<int> runCommand(ArgResults topLevelResults) async {
    int? exitCode = 0;
    // if (topLevelResults['version'] == true) {
    // } else {
    //   exitCode = await super.runCommand(topLevelResults) as int;
    // }

    exitCode = await super.runCommand(topLevelResults);
    return exitCode ?? ExitCode.osError.code;
  }
}
