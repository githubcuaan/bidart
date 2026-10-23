import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/domain/models/scoring/chain_state.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/game_session.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_mode.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/screens/rooms/in_room/turn_scores/turn_scores_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final startedAt = DateTime.utc(2026, 10, 21, 12);

  PlayerInGame player(String id, String name) =>
      PlayerInGame(id: id, displayName: name, joinedAt: startedAt);

  Room room({
    String? previousPlayerId = 'huy',
    String currentPlayerId = 'tuan',
  }) => Room(
    id: 'room-1',
    name: 'Phòng #09',
    ownerId: 'tuan',
    mode: RoomMode.local,
    status: RoomStatus.active,
    createdAt: startedAt,
    revision: 1,
    participants: [
      player('tuan', 'Tuấn Anh'),
      player('huy', 'Huy Bida'),
      player('minh', 'Minh Rasson'),
      player('long', 'Hoàng Long'),
    ],
    activePlayerIds: const ['tuan', 'huy', 'minh', 'long'],
    playerOrder: const ['tuan', 'minh', 'long', 'huy'],
    scores: const {'tuan': 45, 'huy': -15, 'minh': 10, 'long': -40},
    ruleVersions: const [],
    currentRuleVersion: 1,
    games: [
      GameSession(
        id: 'game-1',
        roomId: 'room-1',
        gameNumber: 1,
        status: GameStatus.inProgress,
        startedAt: startedAt,
        currentPlayerId: currentPlayerId,
        previousPlayerId: previousPlayerId,
        payerId: 'huy',
        playerOrder: const ['tuan', 'minh', 'long', 'huy'],
        remainingBalls: {9},
        chainState: const ChainState(
          isBreakChain: false,
          hasLegalPotInChain: true,
        ),
      ),
    ],
    currentGameId: 'game-1',
    endConditions: const EndConditions(),
    pendingEndReasons: const {},
  );

  Widget harness(Room room) => MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SizedBox(width: 328, child: TurnScoresSection(room: room)),
      ),
    ),
  );

  testWidgets('shows the live shooter first and the rotation after them', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(harness(room()));

    expect(find.text('LƯỢT ĐÁNH & ĐIỂM SỐ HIỆN TẠI'), findsOneWidget);
    expect(find.text('Thứ tự bắn đến xoay vòng'), findsOneWidget);

    expect(find.text('Tuấn Anh'), findsOneWidget);
    expect(find.text('ĐANG CÓ CƠ'), findsOneWidget);
    expect(find.text('Đang nhắm bắn Bi 9'), findsOneWidget);
    expect(find.text('Nếu ăn: Huy Bida chịu đền'), findsOneWidget);
    expect(find.text('+45đ'), findsOneWidget);
    expect(find.byIcon(Icons.sports_esports), findsOneWidget);

    expect(find.text('Huy Bida'), findsOneWidget);
    expect(find.text('Bắn trước đó'), findsOneWidget);
    expect(find.text('Nguy cơ chịu đền nếu Tuấn Anh ăn'), findsOneWidget);
    expect(find.text('-15đ'), findsOneWidget);
    expect(find.text('Hạng 3'), findsOneWidget);
    expect(find.byIcon(Icons.priority_high), findsOneWidget);

    expect(find.text('Minh Rasson'), findsOneWidget);
    expect(find.text('Lượt tiếp: Sau Tuấn Anh'), findsOneWidget);
    expect(find.text('+10đ'), findsOneWidget);
    expect(find.text('Hạng 2'), findsOneWidget);

    expect(find.text('Hoàng Long'), findsOneWidget);
    expect(find.text('Chờ vòng mới'), findsOneWidget);
    expect(find.text('-40đ'), findsOneWidget);
    expect(find.text('Hạng 4'), findsOneWidget);

    double rowY(String name) => tester.getTopLeft(find.text(name)).dy;
    expect(rowY('Tuấn Anh'), lessThan(rowY('Minh Rasson')));
    expect(rowY('Minh Rasson'), lessThan(rowY('Hoàng Long')));
    expect(rowY('Hoàng Long'), lessThan(rowY('Huy Bida')));

    expect(tester.takeException(), isNull);
  });

  testWidgets('current row keeps the dark turn surface', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(harness(room()));

    final row = tester.widget<Container>(
      find
          .ancestor(of: find.text('Tuấn Anh'), matching: find.byType(Container))
          .first,
    );
    final decoration = row.decoration! as BoxDecoration;
    expect(decoration.gradient, isA<LinearGradient>());
    expect(decoration.borderRadius, BorderRadius.circular(18));
    expect(
      tester
          .widget<AnimatedDefaultTextStyle>(
            find
                .ancestor(
                  of: find.text('Tuấn Anh'),
                  matching: find.byType(AnimatedDefaultTextStyle),
                )
                .first,
          )
          .style
          .color,
      Colors.white,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('animates the turn hand-off between player cards', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    double rowY(String id) =>
        tester.getTopLeft(find.byKey(ValueKey('turn-score-row-$id'))).dy;

    await tester.pumpWidget(harness(room()));
    final tuanStart = rowY('tuan');
    final minhStart = rowY('minh');

    await tester.pumpWidget(harness(room(currentPlayerId: 'minh')));
    // The first frame after the hand-off still shows the cards in their old
    // slots, then the reorder animation moves both cards.
    expect(rowY('tuan'), closeTo(tuanStart, 0.1));
    expect(rowY('minh'), closeTo(minhStart, 0.1));

    await tester.pump(const Duration(milliseconds: 120));
    expect(rowY('tuan'), greaterThan(tuanStart));
    expect(rowY('minh'), lessThan(minhStart));

    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('ĐANG CÓ CƠ'), findsOneWidget);

    final minhRow = tester.widget<Container>(
      find
          .ancestor(
            of: find.text('Minh Rasson'),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(
      (minhRow.decoration! as BoxDecoration).gradient,
      isA<LinearGradient>(),
    );

    final tuanRow = tester.widget<Container>(
      find
          .ancestor(of: find.text('Tuấn Anh'), matching: find.byType(Container))
          .first,
    );
    expect((tuanRow.decoration! as BoxDecoration).gradient, isNull);
    expect(
      tester.getTopLeft(find.text('Minh Rasson')).dy,
      lessThan(tester.getTopLeft(find.text('Tuấn Anh')).dy),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('payer stays at risk while the shooter keeps the cue', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(harness(room(previousPlayerId: 'tuan')));

    expect(find.text('Huy Bida'), findsOneWidget);
    expect(find.text('Bắn trước đó'), findsOneWidget);
    expect(find.text('Nguy cơ chịu đền nếu Tuấn Anh ăn'), findsOneWidget);
    expect(find.text('Nếu ăn: Huy Bida chịu đền'), findsOneWidget);
    expect(find.text('-15đ'), findsOneWidget);
    expect(find.byIcon(Icons.priority_high), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('score colours follow leader, positive and negative rules', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(harness(room()));

    Color? colourOf(String text) => tester
        .widget<AnimatedDefaultTextStyle>(
          find
              .ancestor(
                of: find.text(text),
                matching: find.byType(AnimatedDefaultTextStyle),
              )
              .first,
        )
        .style
        .color;

    final colors = AppSemanticColors.light;
    expect(colourOf('+45đ'), colors.currentTurnScore);
    expect(colourOf('+10đ'), colors.positive);
    expect(colourOf('-15đ'), colors.negative);
    expect(colourOf('-40đ'), colors.negative);
    expect(tester.takeException(), isNull);
  });
}
