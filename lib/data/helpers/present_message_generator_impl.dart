import 'dart:typed_data';

import 'package:image_size_getter/image_size_getter.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/enums/message_type.dart';
import '../../domain/helpers/present_message_generator.dart';
import '../../domain/models/common/image_meta.dart';
import '../../domain/models/message/message.dart';
import '../../domain/models/message/message_wrapper.dart';
import '../../domain/stores/current_user_info_store.dart';

@LazySingleton(as: PresentMessageGenerator)
class PresentMessageGeneratorImpl implements PresentMessageGenerator {
  PresentMessageGeneratorImpl(
    this._currentUserInfoStore,
    this._uuid,
  );

  final CurrentUserInfoStore _currentUserInfoStore;
  final Uuid _uuid;

  @override
  Future<MessageWrapper> generateFromText({
    required int chatId,
    required String text,
  }) async {
    final int? currentUserId = await _currentUserInfoStore.getCurrentUserId();
    final String sendId = _uuid.v4();

    final Message message = Message(
      id: -1,
      userId: currentUserId ?? -1,
      chatId: chatId,
      type: MessageType.text,
      textMessage: text,
      createdAt: DateTime.now(),
      isOwn: true,
    );

    return MessageWrapper(
      id: sendId,
      message: message,
      isSent: false,
      progress: 0,
    );
  }

  @override
  Future<MessageWrapper> generateFromImage({
    required int chatId,
    required Uint8List image,
  }) async {
    final int? currentUserId = await _currentUserInfoStore.getCurrentUserId();
    final String sendId = _uuid.v4();
    final Size imageSize = ImageSizeGetter.getSize(MemoryInput(image));

    final Message message = Message(
      id: -1,
      userId: currentUserId ?? -1,
      chatId: chatId,
      type: MessageType.image,
      createdAt: DateTime.now(),
      isOwn: true,
      imageMeta: ImageMeta(
        width: imageSize.width,
        height: imageSize.height,
      ),
    );

    return MessageWrapper(
      id: sendId,
      message: message,
      isSent: false,
      progress: 0,
      inMemoryImage: image,
    );
  }

  @override
  Future<MessageWrapper> generateFromVideo({
    required int chatId,
    required Uint8List video,
  }) async {
    final int? currentUserId = await _currentUserInfoStore.getCurrentUserId();
    final String sendId = _uuid.v4();

    final Message message = Message(
      id: -1,
      userId: currentUserId ?? -1,
      chatId: chatId,
      type: MessageType.video,
      createdAt: DateTime.now(),
      isOwn: true,
    );

    return MessageWrapper(
      id: sendId,
      message: message,
      isSent: false,
      progress: 0,
      inMemoryVideo: video,
    );
  }

  @override
  Future<MessageWrapper> generateFromVoice({
    required int chatId,
    required Uint8List voice,
  }) async {
    final int? currentUserId = await _currentUserInfoStore.getCurrentUserId();
    final String sendId = _uuid.v4();

    final Message message = Message(
      id: -1,
      userId: currentUserId ?? -1,
      chatId: chatId,
      type: MessageType.voice,
      createdAt: DateTime.now(),
      isOwn: true,
    );

    return MessageWrapper(
      id: sendId,
      message: message,
      isSent: false,
      progress: 0,
      inMemoryVoice: voice,
    );
  }

  @override
  Future<MessageWrapper> generateFromFile({
    required int chatId,
    required Uint8List file,
  }) async {
    final int? currentUserId = await _currentUserInfoStore.getCurrentUserId();
    final String sendId = _uuid.v4();

    final Message message = Message(
      id: -1,
      userId: currentUserId ?? -1,
      chatId: chatId,
      type: MessageType.file,
      createdAt: DateTime.now(),
      isOwn: true,
    );

    return MessageWrapper(
      id: sendId,
      message: message,
      isSent: false,
      progress: 0,
      inMemoryVoice: file,
    );
  }
}
