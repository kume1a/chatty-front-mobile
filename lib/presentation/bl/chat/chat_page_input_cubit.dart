import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/composite_disposable.dart';
import '../../../domain/models/chat/chat.dart';
import '../../../domain/models/message/message.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/repositories/message_repository.dart';
import '../../core/routes/route_arguments/chat_page_args.dart';
import '../../toasts/failure_notifiers/simple_action_failure_notifier.dart';
import '../core/events/event_chat.dart';
import '../core/events/event_message.dart';

part 'chat_page_input_cubit.freezed.dart';

@freezed
class ChatPageInputState with _$ChatPageInputState {
  const factory ChatPageInputState({
    required bool isSendButtonEnabled,
    required bool isSendOptionsShowing,
  }) = _ChatPageInputState;

  factory ChatPageInputState.initial() => const ChatPageInputState(
        isSendButtonEnabled: false,
        isSendOptionsShowing: false,
      );
}

@injectable
class ChatPageInputCubit extends Cubit<ChatPageInputState>
    with CompositeDisposable<ChatPageInputState> {
  ChatPageInputCubit(
    this._messageRepository,
    this._chatRepository,
    this._eventBus,
    this._simpleActionFailureNotifier,
  ) : super(ChatPageInputState.initial());

  final MessageRepository _messageRepository;
  final ChatRepository _chatRepository;
  final EventBus _eventBus;
  final SimpleActionFailureNotifier _simpleActionFailureNotifier;

  final FocusNode inputFocusNode = FocusNode();
  final TextEditingController inputEditingController = TextEditingController();

  Either<FetchFailure, Chat>? _chat;

  late final ChatPageArgs _args;

  Future<void> init(ChatPageArgs args) async {
    _args = args;

    addSubscription(_eventBus.on<EventChat>().listen((EventChat event) {
      event.when(
        chatLoaded: (Either<FetchFailure, Chat> chat) => _chat = chat,
      );
    }));

    inputEditingController.addListener(() {
      final bool isSendButtonEnabled = inputEditingController.text.trim().isNotEmpty;
      if (isSendButtonEnabled != state.isSendButtonEnabled) {
        emit(state.copyWith(isSendButtonEnabled: isSendButtonEnabled));
      }
    });
  }

  @override
  Future<void> close() async {
    inputEditingController.dispose();
    inputFocusNode.dispose();

    return super.close();
  }

  void onMorePressed() {
    if (!state.isSendOptionsShowing) {
      inputFocusNode.unfocus();
    }

    emit(state.copyWith(isSendOptionsShowing: !state.isSendOptionsShowing));
  }

  Future<void> onSendPressed() async {
    final String content = inputEditingController.text;
    if (content.trim().isEmpty) {
      return;
    }

    final Chat? chat = await _resolveChat();
    if (chat == null) {
      return;
    }

    final Either<SimpleActionFailure, Message> result = await _messageRepository.sendMessage(
      chatId: chat.id,
      textMessage: content,
    );

    result.fold(
      _simpleActionFailureNotifier.notify,
      (Message r) {
        _eventBus.fire(EventMessage.sent(r));
        inputEditingController.clear();
      },
    );
  }

  Future<Chat?> _resolveChat() async {
    if (_chat != null && _chat!.isRight()) {
      return _chat!.rightOrThrow;
    }

    final Either<FetchFailure, Chat> chat = await _chatRepository.getChatByUserId(
      userId: _args.userId,
    );

    _eventBus.fire(EventChat.chatLoaded(chat));
    return chat.get;
  }
}
