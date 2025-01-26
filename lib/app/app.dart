import 'package:winfo_ai_journaling_app/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:winfo_ai_journaling_app/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:winfo_ai_journaling_app/ui/views/home/home_view.dart';
import 'package:winfo_ai_journaling_app/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:winfo_ai_journaling_app/ui/views/journaling/journaling_view.dart';
import 'package:winfo_ai_journaling_app/services/ai_journaling_assistant_service.dart';
import 'package:winfo_ai_journaling_app/ui/bottom_sheets/create_journal_entry/create_journal_entry_sheet.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: JournalingView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: AiJournalingAssistantService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    StackedBottomsheet(classType: CreateJournalEntrySheet),
// @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
