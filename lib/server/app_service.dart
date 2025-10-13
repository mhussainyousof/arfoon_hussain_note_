import 'package:arfoon_note/client/open_isar.dart';
import 'package:arfoon_note/server/server.dart';
import 'package:path_provider/path_provider.dart';

class AppService {
  final NoteServer noteServer;
  final UserRepo localStorageService;
  final ThemeRepo themeRepository;

  AppService._(
      {required this.noteServer,
      required this.localStorageService,
      required this.themeRepository});

  static Future<AppService> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await openIsar(dir.path);

    return AppService._(
        noteServer: NoteServer.instance(isar),
        localStorageService: UserRepo(),
        themeRepository: ThemeRepo());
  }
}
