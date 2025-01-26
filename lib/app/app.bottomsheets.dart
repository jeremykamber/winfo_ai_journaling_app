// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedBottomsheetGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/bottom_sheets/create_journal_entry/create_journal_entry_sheet.dart';
import '../ui/bottom_sheets/notice/notice_sheet.dart';

enum BottomSheetType {
  notice,
  createJournalEntry,
}

void setupBottomSheetUi() {
  final bottomsheetService = locator<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.notice: (context, request, completer) =>
        NoticeSheet(request: request, completer: completer),
    BottomSheetType.createJournalEntry: (context, request, completer) =>
        CreateJournalEntrySheet(request: request, completer: completer),
  };

  bottomsheetService.setCustomSheetBuilders(builders);
}
